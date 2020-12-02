//
//  RectangleView.swift
//  SutieWatch
//
//  Created by SutieDev on 2020/12/02.
//  Copyright © 2020 developers. All rights reserved.
//

import UIKit

class RectangleView: WatchFrameView {

    override func draw(_ rect: CGRect) {
//        self.layer.sublayers?.removeAll()
        
        print("[RectangleView] rectangle rect : \(rect)")
        super.draw(rect)
    }
}

