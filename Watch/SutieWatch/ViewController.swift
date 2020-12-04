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
    var second: Int
    var AMPM: String
}

enum WatchFrameType {
    case circle
    case rectangle
    case digital
}

class ViewController: UIViewController {
    var scanLayout: ScanLayout = .classic {
        didSet {
            self.rectangleView?.changeScan(scanLayout)
            self.circleView?.changeScan(scanLayout)
        }
    }
    
    private var watchFrameTypes: [WatchFrameType] = [.digital, .circle, .rectangle]
    private var currentFrameType: WatchFrameType! = .digital {
        didSet {
            removeAllWatchViews()
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else {
                    return
                }
                self.drawWatch(type: self.currentFrameType)
            }
        }
    }
    private var buttons: [UIButton] = []
    private var currentWatchTime: WatchTime?     // 현재 시각
    private var circleView: CircleView?
    private var rectangleView: RectangleView?
    private var digitalClockView: DigitalClockView?
    private var secondTimer: Timer!
    
    private var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. 현재 시간
        setWatchTime()
        
        // 2. UI 그리기
        drawWatch(type: self.currentFrameType)
//        drawButtons()
        
        // timer 1초
        self.secondTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                   target: self,
                                                   selector: #selector(tickPerSecond),
                                                   userInfo: nil,
                                                   repeats: true)
        
        // 5. tap 제스처 추가
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToChangeSkin))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            let value = UIDeviceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        case .landscapeRight:
            let value = UIDeviceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        case .portrait:
            let value = UIDeviceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        default:
            break
        }
    }
    
    private func removeAllWatchViews() {
        self.circleView?.removeFromSuperview()
        self.rectangleView?.removeFromSuperview()
        self.digitalClockView?.removeFromSuperview()
    }
    
    @objc func tapToChangeSkin() {
        let randomNextSkin = watchFrameTypes.filter { $0 != currentFrameType }.first
        self.currentFrameType = randomNextSkin
    }
    
    @objc func handleButtons(_ button: UIButton) {
        switch button.tag {
        // natural
        case 100:
            self.circleView?.changeScan(.natural)
        // classic
        case 200:
            self.circleView?.changeScan(.classic)
        // modern
        case 300:
            self.circleView?.changeScan(.modern)
        default:
            break
        }
    }
    
    private func setWatchTime() {
        let timeArray: [String] = currentTime()
        
        guard let hour = NumberFormatter().number(from: timeArray[0]),
              let minute = NumberFormatter().number(from: timeArray[1]),
              let second = NumberFormatter().number(from: timeArray[2]) else {
                return
        }
        
        self.currentWatchTime = WatchTime(hour: hour.intValue,
                                          minute: minute.intValue,
                                          second: second.intValue,
                                          AMPM: timeArray.last ?? "")
    }
    
    // 1초 ticking
    @objc func tickPerSecond() {
        let timeArray: [String] = currentTime()
        
        guard let hour = NumberFormatter().number(from: timeArray[0]),
            let minute = NumberFormatter().number(from: timeArray[1]),
            let second = NumberFormatter().number(from: timeArray[2]) else {
                return
        }
        
        guard let currentTime = self.currentWatchTime else {
            return
        }
        
        switch self.currentFrameType {
        case .circle:
            guard let circleView = self.circleView else {
                return
            }
            circleView.setDegrees(forView: circleView.secondHandView)
            
        case .rectangle:
            guard let rectangleView = self.rectangleView else {
                return
            }
            rectangleView.setDegrees(forView: rectangleView.secondHandView)
            
        case .digital:
            print("--------- [디지털시계] \(Int(truncating: second))초 ---------")
        case .none:
            break
        }
       
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
            
            switch self.currentFrameType {
            case .circle:
                guard let circleView = self.circleView else {
                    return
                }
                circleView.setDegrees(forView: circleView.minuteHandView)
                
            case .rectangle:
                guard let rectangleView = self.rectangleView else {
                    return
                }
                rectangleView.setDegrees(forView: rectangleView.minuteHandView)
                
            case .digital:
                digitalClockView?.setMinute(updatedMinute)
                digitalClockView?.playAnimationMinute()
            case .none:
                break
            }
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
            
            switch self.currentFrameType {
            case .circle:
                circleView!.setDegrees(forView: circleView!.hourHandView)
            case .rectangle:
                rectangleView!.setDegrees(forView: rectangleView!.hourHandView)
            case .digital:
                digitalClockView?.setHour(updatedHour)
                digitalClockView?.playAnimationHour()
            case .none:
                break
            }
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
        guard let AMPM = dateArray.popLast() else {
            return []
        }
        
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
        return [hourStr, minuteStr, secondStr, String(AMPM)]
    }
}

// MARK: - Draw UI
private extension ViewController {
    func drawWatch(type: WatchFrameType) {
        switch type {
        case .circle:
            let leading: CGFloat = 50.0
            let topConstant: CGFloat = 80.0
            let diameter = self.view.frame.width - leading * 2
            let rect = CGRect(x: leading, y: self.view.safeAreaInsets.top + topConstant, width: diameter, height: diameter)
            self.circleView = CircleView(frame: rect, scanLayout: self.scanLayout, textSizeWidth: 20)
            circleView!.scanLayout = self.scanLayout
            circleView!.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            self.view.addSubview(circleView!)
            
        case .rectangle:
            let leading: CGFloat = 80.0
            let topConstant: CGFloat = 100.0
            let width = self.view.frame.width - leading * 2
            let rect = CGRect(x: leading, y: self.view.safeAreaInsets.top + topConstant, width: width, height: width*1.4)
            
            self.rectangleView = RectangleView(frame: rect, scanLayout: self.scanLayout, textSizeWidth: 20)
            rectangleView!.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.view.addSubview(rectangleView!)
            
        case .digital:
            let width: CGFloat = 100.0
            let leading: CGFloat = (self.view.frame.width - width) / 2
            let topConstant: CGFloat = 150.0
            
            let rect = CGRect(x: leading, y: self.view.safeAreaInsets.top + topConstant, width: width, height: width*1.2)
            self.digitalClockView = DigitalClockView(frame: rect, time: self.currentWatchTime!)
            self.view.addSubview(self.digitalClockView!)
        }
    }
    
    func drawButtons() {
        self.buttons = Array.init(repeating: UIButton(), count: 3)
        
        let buttonWidth: CGFloat = (self.view.frame.width - 80) / CGFloat(buttons.count)
        let buttonHeight: CGFloat = 50.0
        let buttonFrameY: CGFloat = circleView!.frame.maxY + 100
        
        buttons[0].tag = 100
        buttons[0].backgroundColor = .brown
        buttons[0].setTitle(ScanLayout.natural.stringValue(), for: .normal)
        buttons[0].frame = CGRect(x: -200,
                                  y: buttonFrameY,
                                  width: buttonWidth, height: buttonHeight)
        self.view.addSubview(buttons[0])

        buttons[1].tag = 200
        buttons[1].backgroundColor = .orange
        buttons[1].setTitle(ScanLayout.classic.stringValue(), for: .normal)
        buttons[1].frame = CGRect(x: 150, y: buttonFrameY,
                                  width: buttonWidth, height: buttonHeight)
        self.view.addSubview(buttons[1])
        
        buttons[2].tag = 300
        buttons[2].backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        buttons[2].setTitle(ScanLayout.modern.stringValue(), for: .normal)
        buttons[2].frame = CGRect(x: 0, y: buttonFrameY,
                                  width: buttonWidth, height: buttonHeight)
        self.view.addSubview(buttons[2])
        
        buttons.forEach {
            $0.titleLabel?.textColor = .white
            $0.addTarget(self, action: #selector(handleButtons(_:)), for: .touchUpInside)
//            self.view.addSubview($0)
        }
    }
}
