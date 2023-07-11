//
//  main.m
//  LaurelSwizzlingExample
//
//  Created by Sen on 2023/7/11.
//

#import <Foundation/Foundation.h>
#import <LaurelSwizzling/LaurelSwizzling.h>
#import "Student.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Student *student = [[Student alloc] init];
        NSLog(@"%@", [student study]);
        
        [LaurelOverrideSwizzle overrideImplementation: ^id _Nonnull(__unsafe_unretained Class  _Nonnull cls, SEL  _Nonnull originCMD, IMPProvider  _Nonnull originalIMPProvider) {
            return ^NSString *(__kindof Student *student, id arg, ...) {
                return @"Student end study";
            };
        } withMethod: @selector(study) forClass: [Student class]];
        NSLog(@"%@", [student study]);
        
        [LaurelExtendSwizzle extendVoidImplementation: ^(__kindof Student *student) {
            NSLog(@"say hello extend");
        } withMethod: @selector(sayHello) forClass: [Student class]];
        [student sayHello];
    }
    return 0;
}
