//
//  ViewController.swift
//  SutieWatch
//
//  Created by SutieDev on 2020/11/18.
//  Copyright © 2020 developers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var scanLayout: ScanLayout = .classic {
        didSet {
            setScanLayout(scanLayout)
        }
    }
    
    // 반드시 셋팅
    var circleView: CircleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leading: CGFloat = 50.0
        let bottomConstant: CGFloat = 30.0
        let circleViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 2)
        let diameter = circleViewFrame.width - leading * 2
        
        let rect = CGRect(x: circleViewFrame.width - diameter - leading,
                          y: circleViewFrame.height - diameter - bottomConstant,
                          width: diameter, height: diameter)
        self.circleView = CircleView(frame: rect)
        circleView.scanLayout = self.scanLayout
        
        
        
        circleView.backgroundColor = #colorLiteral(red: 0.68707937, green: 0.846567452, blue: 0.5675443411, alpha: 1)
        self.view.addSubview(circleView)
    }


}

extension ViewController {
    func setScanLayout(_ layout: ScanLayout) {
        self.circleView.changeScan(layout)
    }
}

