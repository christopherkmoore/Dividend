
import XCTest
@testable import Dividend

/*
 Pretty tired of the API changing or Codable failing going to make some tests
 for all the types conforming to codable, and make sure there are no changes to
 data structures
 */

class ChartCodableTests: XCTestCase {
    
    var testStock: Stock!
    
    override func setUp() {
        
        let expectation = self.expectation(description: "async method")
        IEXApiClient.shared.getStock("MO") { (success, stock, error) in
            
            guard success == true else {
                XCTAssertTrue(success)
                XCTFail(error!.localizedDescription)
                return
            }
            
            guard let stock = stock else {
                XCTFail(error!.localizedDescription)
                return
            }
            self.testStock = stock
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 4, handler: nil)
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testChartDataOneDay() {

        let expectation = self.expectation(description: "async calls")
        
        IEXApiClient.shared.getChartDataOneDay(for: testStock) { (success, chartPoint, error) in
            XCTAssertTrue(success)
            
            guard let dayChartPoints = chartPoint else {
                XCTFail(error!.localizedDescription)
                return
            }
            
            let set = NSOrderedSet(array: dayChartPoints)
            self.testStock.chartPoints = set
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testChartDataOneYear() {
        
        let expectation = self.expectation(description: "async calls")
        
        IEXApiClient.shared.getChartDataOneYear(for: testStock) { (success, stock, error) in
            XCTAssertTrue(success)
            
            guard let yearChartPoints = stock?.chartPointsOneYear else {
                XCTFail(error!.localizedDescription)
                return
            }
            
            self.testStock.chartPointsOneYear = yearChartPoints
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        testMakeOneYearChart()
    }
    
    // Needs to be executed in order or else xcode will blow it up by running it before everything else.
    func testMakeOneYearChart() {
        
        guard let points = testStock?.chartPointsOneYear?.array as? [ChartPointOneYear] else {
            print("Unable to cast stocks chart points into proper type")
            XCTFail()
            return
        }
        
        let chart = Chart(frame: CGRect(x: 0, y: 0, width: 0, height: 0), with: points)
        XCTAssertNotNil(chart)
    }
}
