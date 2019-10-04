//
//  SwiftExtensionTool.swift
//  Canonchain
//
//  Created by LEE on 8/2/18.
//  Copyright © 2018 LEE. All rights reserved.
//

import Foundation
import UIKit
protocol SelfAware: class {
    static func awake()
}
class NothingToSeeHere {
    static func harmlessFunction() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            (types[index] as? SelfAware.Type)?.awake()
        }
        types.deallocate()
        //   types.deallocate( capacity: typeCount)
    }
}
extension UIApplication {
    private static let runOnce: Void = {
        NothingToSeeHere.harmlessFunction()
    }()
    override open var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        UIApplication.runOnce
        return super.next
    }
}

public func swizzlingForClass(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
    let originalMethod = class_getInstanceMethod(forClass, originalSelector)
    let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
    guard (originalMethod != nil && swizzledMethod != nil) else {
        return
    }
    if class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) {
        class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
    } else {
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }
}
