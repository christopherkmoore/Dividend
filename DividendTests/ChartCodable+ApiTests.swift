
import XCTest
@testable import Dividend

/*
 Pretty tired of the API changing or Codable failing going to make some tests
 for all the types conforming to codable, and make sure there are no changes to
 data structures
 */

class ChartCodableTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {

        var apiSuccess = false
        var outsideScopeStock: Stock!
        let expectation1 = self.expectation(description: "async calls")
        
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
            outsideScopeStock = stock
            expectation1.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        let expectation2 = self.expectation(description: "async calls2")
        IEXApiClient.shared.getChartDataTest(for: outsideScopeStock, withRequest: .chart) { (success, chartPoint, error) in
            
            guard let chartPoints = chartPoint else {
                XCTFail(error!.localizedDescription)
                return
            }
            apiSuccess = true
            expectation2.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
    }
}
