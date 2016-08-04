//
//  EasyTimerTimeInterval.swift
//  EasyTimerTimeInterval
//
//  Created by Niklas Fahl on 3/2/16.
//  Copyright © 2016 High Bay. All rights reserved.
//

import Foundation

// Powered by Swifty Timer Extension - radex
extension Double {
    public var millisecond: NSTimeInterval  { return self / 1000 }
    public var second: NSTimeInterval       { return self }
    public var minute: NSTimeInterval       { return self * 60 }
    public var hour: NSTimeInterval         { return self * 3600 }
    public var day: NSTimeInterval          { return self * 3600 * 24 }
}

extension Int {
    public var millisecond: NSTimeInterval  { return Double(self) / 1000 }
    public var second: NSTimeInterval       { return Double(self) }
    public var minute: NSTimeInterval       { return Double(self) * 60 }
    public var hour: NSTimeInterval         { return Double(self) * 3600 }
    public var day: NSTimeInterval          { return Double(self) * 3600 * 24 }
}