//
//  ZLWeakProxy.swift
//  PhotoApp
//
//  Created by Ali on 4.12.2021.
//

import UIKit

class ZLWeakProxy: NSObject {

    private weak var target: NSObjectProtocol?
    
    init(target: NSObjectProtocol) {
        self.target = target
        super.init()
    }
    
    class func proxy(withTarget target: NSObjectProtocol) -> ZLWeakProxy {
        return ZLWeakProxy.init(target: target)
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return target
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        return target?.responds(to: aSelector) ?? false
    }
    
}

