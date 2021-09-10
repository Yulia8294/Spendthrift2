//
//  UIColor+Extensions.swift
//  Spendthrift2
//
//  Created by Yulia Novikova on 9/10/21.
//

import UIKit

extension UIColor {
    
    class func color(data: Data) -> UIColor? {
        try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
    }
    
    func encode() -> Data? {
        try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }
}
