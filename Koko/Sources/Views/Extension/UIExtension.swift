//
//  UIExtension.swift
//  Koko
//
//  Created by 顏家揚 on 2023/11/8.
//

import Foundation
import UIKit
extension UIView {
    
    var x: CGFloat {
        get {
            self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var y: CGFloat {
         get {
             self.frame.origin.y
         }
         set {
             self.frame.origin.y = newValue
         }
     }

     var height: CGFloat {
         get {
             self.frame.size.height
         }
         set {
             self.frame.size.height = newValue
         }
     }

     var width: CGFloat {
         get {
             self.frame.size.width
         }
         set {
             self.frame.size.width = newValue
         }
     }
}
