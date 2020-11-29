//
//  ViewController.swift
//  SutieWatch
//
//  Created by SutieDev on 2020/11/18.
//  Copyright © 2020 developers. All rights reserved.
//

import UIKit

struct WatchTime {
    var hour: Int
    var minute: Int
//    let second: Int
}

class ViewController: UIViewController {
    var scanLayout: ScanLayout = .classic {
        didSet {
            self.circleView.changeScan(scanLayout)
        }
    }
    
    private var buttons: [UIButton] = []
    private var currentWatchTime: WatchTime?     // 현재 시각
    private var circleView: CircleView!
    private var secondTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawWatch()
        drawButtons()
        setWatchTime()
        
        // timer 1초
        self.secondTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                   target: self,
                                                   selector: #selector(tickPerSecond),
                                                   userInfo: nil,
                                                   repeats: true)
    }
    
    @objc func handleButtons(_ button: UIButton) {
        switch button.tag {
        // natural
        case 100:
            self.circleView.changeScan(.natural)
        // classic
        case 200:
            self.circleView.changeScan(.classic)
        // modern
        case 300:
            self.circleView.changeScan(.modern)
        default:
            break
        }
    }
    
    private func setWatchTime() {
        let timeArray: [String] = currentTime()
        
        guard let hour = NumberFormatter().number(from: timeArray[0]),
            let minute = NumberFormatter().number(from: timeArray[1]) else {
                return
        }
        
        self.currentWatchTime = WatchTime(hour: hour.intValue,
                                          minute: minute.intValue)
    }
    
    // 1초 ticking
    @objc func tickPerSecond() {
        let timeArray: [String] = currentTime()
        
        guard let hour = NumberFormatter().number(from: timeArray[0]),
            let minute = NumberFormatter().number(from: timeArray[1]) else {
                return
        }
        
        circleView.setDegrees(forView: circleView.secondHandView)
       
        self.tickPerMinute(Int(truncating: minute))
        self.tickPerHour(Int(truncating: hour))
    }
    
    // 1분 ticking
    func tickPerMinute(_ updatedMinute: Int) {
        guard let currentTime = self.currentWatchTime else {
            return
        }
        
        if updatedMinute != currentTime.minute {
            print("\n****** tickPerMinute : \(updatedMinute)분, 저장된 시간 : \(currentTime.minute)분 ********")
            circleView.setDegrees(forView: circleView.minuteHandView)
            self.currentWatchTime?.minute = updatedMinute
        } else {
            return
        }
    }

    // 1시간 ticking
    func tickPerHour(_ updatedHour: Int) {
        guard let currentTime = self.currentWatchTime else {
            return
        }
        
        if updatedHour != currentTime.hour {
            print("\n****** tickPer Hour : \(updatedHour)시, 저장된 시간 : \(currentTime.hour)시 ********")
            circleView.setDegrees(forView: circleView.hourHandView)
            self.currentWatchTime?.hour = updatedHour
        } else {
            return
        }
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

// MARK: - Draw UI
private extension ViewController {
    func drawWatch() {
        let leading: CGFloat = 50.0
        let bottomConstant: CGFloat = 30.0
        let circleViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 2)
        let diameter = circleViewFrame.width - leading * 2
        
        let rect = CGRect(x: self.view.frame.width - diameter - leading,
                          y: circleViewFrame.height - diameter - bottomConstant,
                          width: diameter, height: diameter)
        self.circleView = CircleView(frame: rect, scanLayout: self.scanLayout)
        circleView.scanLayout = self.scanLayout
        circleView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.view.addSubview(circleView)
    }
    
    func drawButtons() {
        self.buttons = Array.init(repeating: UIButton(), count: 3)
        
        let buttonWidth: CGFloat = (self.view.frame.width - 80) / CGFloat(buttons.count)
        let buttonHeight: CGFloat = 50.0
        let buttonFrameY: CGFloat = circleView.frame.maxY + 100
        
        buttons[0].tag = 100
        buttons[0].backgroundColor = .brown
        buttons[0].setTitle(ScanLayout.natural.stringValue(), for: .normal)
        buttons[0].frame = CGRect(x: -100,
                                  y: buttonFrameY,
                                  width: buttonWidth, height: buttonHeight)

        buttons[1].tag = 200
        buttons[1].backgroundColor = .orange
        buttons[1].setTitle(ScanLayout.classic.stringValue(), for: .normal)
        buttons[1].frame = CGRect(x: buttons[0].frame.maxX + 10, y: buttonFrameY,
                                  width: buttonWidth, height: buttonHeight)
        
        buttons[2].tag = 300
        buttons[2].backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        buttons[2].setTitle(ScanLayout.modern.stringValue(), for: .normal)
        buttons[2].frame = CGRect(x: buttons[1].frame.maxX + 10, y: buttonFrameY,
                                  width: buttonWidth, height: buttonHeight)
        
        buttons.forEach {
            $0.titleLabel?.textColor = .white
            $0.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside)
            self.view.addSubview($0)
        }
        
//        DispatchQueue.main.async {
//            self.
//        }
    }
}
