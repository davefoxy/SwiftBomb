//
//  StringUtils.swift
//  SwiftBomb
//
//  Created by David Fox on 07/05/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

typealias ResourceInfoTuple = (value: String?, label: String)

func createResourceInfoString(infos: [ResourceInfoTuple]) -> NSMutableAttributedString {
    
    var infoString = NSMutableAttributedString()
    
    for info in infos {
        
        if let value = info.value {
            updateInfo(&infoString, label: info.label, value: value)
        }
    }
    
    return infoString
}

func updateInfo(inout info: NSMutableAttributedString, label: String, value: String) {
    
    info.mutableString.appendString("\(label) \(value)\n")
    info.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(17), range: info.mutableString.rangeOfString(label))
}