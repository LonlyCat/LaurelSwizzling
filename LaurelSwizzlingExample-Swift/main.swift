//
//  main.swift
//  LaurelSwizzlingExample-Swift
//
//  Created by Sen on 2023/7/11.
//

import Foundation
import LaurelSwizzling

let student = Student()
print("\(student.study())")

Swizzling.overrider.overrideImplementation(impBlock: { oriClass, oriCMD, impProvider in
    typealias ClosureType = @convention(block) (AnyObject) -> NSString
    let closure: ClosureType = { student in
        return "Student end study"
    }
    return closure
}, withMethod: #selector(student.study), for: Student.self)

print("\(student.study())")
