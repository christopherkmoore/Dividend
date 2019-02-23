
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
        testStock = nil
    }
    
    func testChartDataOneDay() {

        let expectation = self.expectation(description: "async calls")
        
        IEXApiClient.shared.getChartDataOneDay(for: testStock) { (success, chartPoint, error) in
            XCTAssertTrue(success)
            
            guard let _ = chartPoint else {
                XCTFail(error!.localizedDescription)
                return
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testChartDataOneYear() {
        
        let expectation = self.expectation(description: "async calls")
        
        IEXApiClient.shared.getChartDataOneYear(for: testStock) { (success, chartPoint, error) in
            XCTAssertTrue(success)
            
            guard let _ = chartPoint else {
                XCTFail(error!.localizedDescription)
                return
            }
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
