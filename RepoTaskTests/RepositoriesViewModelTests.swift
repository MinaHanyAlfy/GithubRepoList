//
//  RepositoriesViewModelTests.swift
//  RepoTaskTests
//
//  Created by John Doe on 2023-06-20.
//

import XCTest
import Combine
@testable import RepoTask

final class RepositoriesViewModelTests: XCTestCase {
    var viewModel: RepositoriesViewModel!
    var cancellables: Set<AnyCancellable>!
//    var dataRepo: Repository?
    
    override func setUp() {
        super.setUp()
        viewModel = RepositoriesViewModel()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchData() {
        // Setup
     
        let expectation = XCTestExpectation(description: "Data fetched")
        viewModel
            .$data.sink { data in
                print("Data updated: \(data)")
                XCTAssertNotNil(data)
                
                expectation.fulfill()
            }.store(in: &cancellables)
        
        // Exercise
        viewModel.fetchData()
        
        // Wait for expectation
        let result = XCTWaiter.wait(for: [expectation], timeout: 5.0)
    }
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
