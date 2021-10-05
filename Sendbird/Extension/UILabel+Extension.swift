//
//  UILabel+Extension.swift
//  Sendbird
//
//  Created by 이해상 on 2021/09/27.
//

import UIKit

extension UILabel {
    
    // UILabel For Multilines
    convenience init(number: Int) {
        self.init()
        self.numberOfLines = number
    }
}
