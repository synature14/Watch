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
        
        let rect = CGRect(x: self.view.frame.width - diameter - leading,
                          y: circleViewFrame.height - diameter - bottomConstant,
                          width: diameter, height: diameter)
        self.circleView = CircleView(frame: rect, scanLayout: self.scanLayout)
        circleView.scanLayout = self.scanLayout
        circleView.backgroundColor = #colorLiteral(red: 0.68707937, green: 0.846567452, blue: 0.5675443411, alpha: 1)
        self.view.addSubview(circleView)
        
        // timer 1초
        self.secondTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                   target: self,
                                                   selector: #selector(tickPerSecond),
                                                   userInfo: nil,
                                                   repeats: true)
    }
    
    // 1초 ticking
    @objc func tickPerSecond() {
        let timeArray: [String] = currentTime()
        
        guard let hour = NumberFormatter().number(from: timeArray[0]),
            let minute = NumberFormatter().number(from: timeArray[1]) else {
                return
        }
        
        circleView.setDegrees(forView: circleView.secondHandView)
        
        DispatchQueue.main.async {
            self.tickPerMinute(Int(truncating: minute))
        }
//        tickPerHour(Int(truncating: hour))
    }
    
    // 1분 ticking
    func tickPerMinute(_ minute: Int) {
        print("\n****** tickPerMinute : \(minute)분 ********")
        
        let minuteRadian = CGFloat(minute) * 6.0 * .pi / 180.0
        let minuteDegrees: CGFloat = minuteRadian * 180 / .pi
//        let minuteTransform = CGAffineTransform(rotationAngle:minuteRadian)
        
        let radians = atan2(circleView.minuteHandView.transform.b, circleView.minuteHandView.transform.a)
        var currentDegrees: CGFloat = radians * 180 / .pi
        
        if currentDegrees == 360.0 {
            currentDegrees = 0
        }
        
        if minute < 30 {
            // degree가 양수
        } else {
            // degree가 음수
            currentDegrees = abs(360 + currentDegrees)
        }

        // 분침 움직일 필요가 없음
        if minuteDegrees == currentDegrees {
            return
        }
       
        circleView.setDegrees(forView: circleView.minuteHandView)
    }

    // 1시간 ticking
    func tickPerHour(_ hour: Int) {
        let time = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
        print("\n\n******* [1시간] 경과: \(time) ********")
        let hourHandViewAnchor = circleView.hourHandView.layer.anchorPoint
        circleView.setDegrees(forView: circleView.hourHandView)
    }
    
    // MARK: - 시간 (return 시, 분, 초)
    func currentTime() -> [String] {
        let date = DateFormatter.localizedString(from: Date(),
                                                 dateStyle: .medium,
                                                 timeStyle: .medium)
        var dateArray = date.split(separator: " ")
        let AMPM = dateArray.popLast()
        
        if AMPM == "AM" {
            // 오전 시간 백그라운드뷰 설정
            
        } else if AMPM == "PM" {
            // 오후 시간 백그라운드뷰 설정
        }
        
        let timeArray = dateArray.popLast()

        guard let time = timeArray?.split(separator: ":") else {
            return []
        }
        let secondStr = String(time[2])
        let minuteStr = String(time[1])
        let hourStr = String(time[0])
        return [hourStr, minuteStr, secondStr]
    }
}

extension ViewController {
    func setScanLayout(_ layout: ScanLayout) {
        self.circleView.changeScan(layout)
    }
}

