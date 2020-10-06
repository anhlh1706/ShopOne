//
//  AppHelper.swift
//  ShopOne
//
//  Created by Lê Hoàng Anh on 06/10/2020.
//

import Foundation
import UIKit.UILabel

final class AppHelper {
    
    class func estimatedWidth(ofString string: String, withFont font: UIFont?, spacing: Float? = nil) -> CGFloat {
        let label = Label()
        label.text = string
        label.font = font
        label.sizeToFit()
        return label.frame.width
    }
    
    class func estimatedHeight(ofString string: String, withFont font: UIFont, spacing: Float? = nil, lineWidth: CGFloat) -> CGFloat {
        let label = Label(frame: CGRect(x: 0, y: 0, width: lineWidth, height: 2000))
        label.numberOfLines = 0
        label.text = string
        label.font = font
        label.sizeToFit()
        return label.frame.height
    }
}
