//
//  LaurelSwizzlingTests.swift
//  LaurelSwizzlingTests
//
//  Created by Sen on 2023/7/10.
//

import XCTest
@testable import LaurelSwizzling

class LaurelSwizzlingTests: XCTestCase {
    
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
        
        
        //        print("Before swizzling: \(Student().study())")
        //        Swizzling.overrider.overrideImplementation(impBlock: { oriClass, oriCMD, originalIMPProvider in
        //            typealias ClosureType = @convention(c) (AnyObject) -> NSString
        //            let swizzleImp: ClosureType = { student in
        //                return "CollegeStudent study"
        //            }
        //            return swizzleImp
        //        }, withMethod: NSSelectorFromString("study"), for: Student.self)
        //        print("After swizzling: \(Student().study())");
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
