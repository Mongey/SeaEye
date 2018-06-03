//
//  BuildStatusColor.swift
//  SeaEye
//
//  Created by Conor Mongey on 29/04/2018.
//  Copyright © 2018 Nolaneo. All rights reserved.
//

import Foundation
import Cocoa

func ColorForStatus(status: String) -> NSColor?{
    switch status{
        case "success": return greenColor()
        case "fixed": return greenColor()
        case "no_tests": return redColor()
        case "failed": return redColor()
        case "timedout": return redColor()
        case "running": return blueColor()
        case "canceled": return grayColor()
        case "retried": return grayColor()
    default:
        return nil
    }
}
fileprivate func greenColor() -> NSColor {
    return isDarkModeEnabled() ? NSColor.green : NSColorFromRGB(0x229922)
}

fileprivate func redColor() -> NSColor {
    return isDarkModeEnabled() ? NSColorFromRGB(0xff5b5b) : NSColor.red
}

fileprivate func blueColor() -> NSColor {
    return isDarkModeEnabled() ? NSColorFromRGB(0x00bfff) : NSColorFromRGB(0x0096c8)
}

fileprivate func grayColor() -> NSColor {
    return isDarkModeEnabled() ? NSColor.lightGray : NSColor.gray
}

fileprivate func NSColorFromRGB(_ rgbValue: UInt) -> NSColor {
    return NSColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
