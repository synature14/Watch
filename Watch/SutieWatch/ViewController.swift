//
//  ViewController.swift
//  SutieWatch
//
//  Created by SutieDev on 2020/11/18.
//  Copyright © 2020 developers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var view01: UIView!
    
    var scanLayout: ScanLayout = .classic {
        didSet {
            setScanLayout(scanLayout)
        }
    }
    
    private var circleView: CircleView!
    private var secondTimer: Timer!
    private var minuteTimer: Timer!
    private var hourTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leading: CGFloat = 50.0
        let bottomConstant: CGFloat = 30.0
        let circleViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 2)
        let diameter = circleViewFrame.width - leading * 2
        
        let rect = CGRect(x: circleViewFrame.width - diameter - leading,
                          y: circleViewFrame.height - diameter - bottomConstant,
                          width: diameter, height: diameter)
        self.circleView = CircleView(frame: rect, scanLayout: self.scanLayout)
        circleView.scanLayout = self.scanLayout
        circleView.backgroundColor = #colorLiteral(red: 0.68707937, green: 0.846567452, blue: 0.5675443411, alpha: 1)
        self.view.addSubview(circleView)
        
        // 0. timer 1초
        self.secondTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                   target: self,
                                                   selector: #selector(tickPerSecond),
                                                   userInfo: nil,
                                                   repeats: true)
        
//        self.minuteTimer = Timer.scheduledTimer(timeInterval: 60.0,
//                                                target: self,
//                                                selector: #selector(tickPerMinute),
//                                                userInfo: nil,
//                                                repeats: true)
//
//        self.hourTimer = Timer.scheduledTimer(timeInterval: 60.0,
//                                                target: self,
//                                                selector: #selector(tickPerMinute),
//                                                userInfo: nil,
//                                                repeats: true)
    }
    
    // 1초 ticking
    @objc func tickPerSecond() {
        let time = DateFormatter.localizedString(from: Date(),
                                                 dateStyle: .medium,
                                                 timeStyle: .medium)
        print("[1초] 시간 : \(time)")
        let secondHandViewAnchor = circleView.secondHandView.layer.anchorPoint
        print("secondHandView Anchor = \(secondHandViewAnchor)")
        circleView.setAnchorPoint(anchorPoint: secondHandViewAnchor, forView: circleView.secondHandView)
    }
    
    // 1분 ticking
    @objc func tickPerMinute() {
        let time = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
        print("[1분] 경과 : \(time)")
        let minuteHandViewAnchor = circleView.minuteHandView.layer.anchorPoint
        
        print("minuteHandView Anchor = \(minuteHandViewAnchor)")
        circleView.setAnchorPoint(anchorPoint: minuteHandViewAnchor, forView: circleView.minuteHandView)
    }
    
    // 1시간 ticking
    @objc func tickPerHour() {
        let time = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
        print("[1시간] 경과: \(time)")
        let hourHandViewAnchor = circleView.hourHandView.layer.anchorPoint
        circleView.setAnchorPoint(anchorPoint: hourHandViewAnchor, forView: circleView.hourHandView)
    }
}

extension ViewController {
    func setScanLayout(_ layout: ScanLayout) {
        self.circleView.changeScan(layout)
    }
}

