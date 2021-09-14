//
//  UIImage+Extensions.swift
//  Spendthrift2
//
//  Created by Yulia Novikova on 9/14/21.
//

import UIKit

extension UIImage {
    
    func resized(to newSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            let hScale = newSize.height / size.height
            let vScale = newSize.width / size.width
            let scale = max(hScale, vScale)
            let resizedSize = CGSize(width: size.width * scale, height: size.height * scale)
            var middle = CGPoint.zero
            
            if resizedSize.width > newSize.width {
                middle.x -= (resizedSize.width - newSize.width)/2.0
            }
            if resizedSize.height > newSize.height {
                middle.y -= (resizedSize.height - newSize.height)/2.0
            }
            
            draw(in: CGRect(origin: middle, size: resizedSize))
        }
    }
}
