//
//  UIView+Extension.swift
//  SutieWatch
//
//  Created by SutieDev on 2020/11/19.
//  Copyright © 2020 developers. All rights reserved.
//

import UIKit

extension UIView {
    func rotate(angle: CGFloat) {
        let radians = angle * 180.0 * .pi
        let rotation = self.transform.rotated(by: radians)
        self.transform = rotation
    }
}

