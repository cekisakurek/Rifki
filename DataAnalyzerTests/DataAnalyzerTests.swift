//
//  DataAnalyzerTests.swift
//  DataAnalyzerTests
//
//  Created by Cihan Emre Kisakurek on 31.03.20.
//  Copyright © 2020 cekisakurek. All rights reserved.
//

import XCTest
@testable import DataAnalyzer

class DataAnalyzerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    func testLoadCVS() {
        
        guard let path = Bundle(for: type(of: self)).url(forResource: "BitcoinTest", withExtension: "csv") else {
            XCTAssert(false, "Couldn't load file")
            return
        }
        
        let exp = expectation(description: "\(#function)\(#line)")
        
        let csvOP = CSVOperation(url: path)
        
        csvOP.completionBlock =
        {
            exp.fulfill()
            XCTAssert(!csvOP.data!.isEmpty, "Couldn't load file")
                
        }
        

        let importQueue = ImportOperationQueue()
        
        importQueue.queue.addOperation(csvOP)
        
//        OperationQueue
        
//        let url =
//        let csvOp = CSVOperation(url: <#T##URL#>)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
