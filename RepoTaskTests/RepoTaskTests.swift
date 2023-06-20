//
//  RepoTaskTests.swift
//  RepoTaskTests
//
//  Created by John Doe on 2023-06-18.
//

import XCTest
@testable import RepoTask

final class RepoTaskTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        
        ///For Test Date Formatter....
        //   self.dateManagerMoreTest()
        //   self.dateManagerLessTest()
        
        ///For Test Array SubTracting
        //        self.arraySubTractingTest()
        
    }
    
    
    //MARK: - For Test Date Formatter More && Less 6 Months -
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    /// To Test Date Formatter if it more than 6 month
    func dateManagerMoreTest() {
        let dateStr = "2008-01-27T22:18:57Z"
        let date = dateStr.getDateValue
        
        //Date after Formatting
        XCTAssertEqual("Sunday, Jan 27, 2008", date?.formatDateSinceCreationDate())
    }
    
    /// To Test Date Formatter if it less than 6 month
    func dateManagerLessTest() {
        let dateStr = "2023-01-27T22:18:57Z"
        let date = dateStr.getDateValue
        
        //Date after Formatting
        XCTAssertEqual("4 months ago", date?.formatDateSinceCreationDate())
    }
    /// To Test Array Subtracting
    func arraySubTractingTest () {
        var array = [1,2,3,4,5,6,8,9,10]
        let subArr = array.subtracting([1,2,3])
        array = subArr
        XCTAssertEqual(array[0], subArr[0])
    }
}
