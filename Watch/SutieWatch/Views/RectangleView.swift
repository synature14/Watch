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
        setLabelDesign(layout: self.scanLayout)
        super.draw(rect)
    }
    
    
    func setLabelDesign(layout: ScanLayout) {
        switch layout {
        case .natural:
            print("[RectangleView] natural")
           
            
        case .modern:
            print("[RectangleView] modern")
            self.hourHandView.layer.borderWidth = 1
            self.hourHandView.layer.borderColor = #colorLiteral(red: 0, green: 0.5843137255, blue: 0.568627451, alpha: 1)
                        
        case .classic:
            print("[RectangleView] classic")
            self.hourHandView.layer.borderWidth = 1
            self.hourHandView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        }
    }
    
    override func changeScan(_ layout: ScanLayout) {
        
    }
}

