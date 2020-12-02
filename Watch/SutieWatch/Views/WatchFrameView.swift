//
//  WatchFrameView.swift
//  SutieWatch
//
//  Created by SutieDev on 2020/12/02.
//  Copyright © 2020 developers. All rights reserved.
//

import UIKit

class WatchFrameView: UIView {
    
    var scanLayout: ScanLayout!     // 디자인 스캔 타입
    var centerPoint: CGPoint!        // 한 가운데 좌표
    var textSizeWidth: CGFloat!
    
    // 시침
    var hourHandView: UIView!
    // 분침
    var minuteHandView: UIView!
    // 초침
    var secondHandView: UIView!
    
    // 시계 배경 이미지뷰
    var imageView: UIImageView!
    
    init(frame: CGRect, scanLayout: ScanLayout, textSizeWidth: CGFloat) {
        super.init(frame: frame)
        let centerX = frame.width/2
        let centerY = frame.height/2
        
        self.centerPoint = CGPoint(x: centerX, y: centerY)
        self.textSizeWidth = textSizeWidth
        self.scanLayout = scanLayout
        
        createBackgroundView(scanLayout)
        createHandViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setTime()
    }
    
    private func createBackgroundView(_ scan: ScanLayout) {
        
        var image: UIImage?
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.backgroundColor = .clear
        
        switch scan {
        case .modern:
            image = nil
        case .classic:
            image = UIImage(named: "watch_skin01")!
            
//            guard let height = image?.size.height, let width = image?.size.width else {
//                return
//            }
//            self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: width, height: height)
        case .natural:
            self.imageView.image = nil
        }
        
        self.imageView.image = image
        self.addSubview(imageView)
    }
    
    private func createHandViews() {
        hourHandView = UIView()
        minuteHandView = UIView()
        let radius: CGFloat = centerPoint.x     // 세로로 긴 직사각형일수도 있어서
        
        let secondHandViewFrame = CGRect(x: 0, y: 0,
                                         width: 2.5, height: radius - textSizeWidth)
        secondHandView = UIView(frame: secondHandViewFrame)
        secondHandView.backgroundColor = .red
        secondHandView.center = CGPoint(x: radius - secondHandViewFrame.width/2,
                                        y: centerPoint.y)
        secondHandView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        self.addSubview(secondHandView)
        
        let minuteHandViewHeight = secondHandViewFrame.height - 15
        let minuteHandViewFrame = CGRect(x: 0, y: 0,
                                         width: secondHandViewFrame.width + 1, height: minuteHandViewHeight)
        minuteHandView = UIView(frame: minuteHandViewFrame)
        minuteHandView.center = CGPoint(x: radius - minuteHandViewFrame.width/2,
                                        y: centerPoint.y)
        minuteHandView.backgroundColor = .darkGray
        minuteHandView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        self.addSubview(minuteHandView)
        
        let hourHandViewHeight = minuteHandViewHeight - 20
        let hourHandViewFrame = CGRect(x: 0, y: 0,
                                       width: minuteHandViewFrame.width + 2.5,
                                       height: hourHandViewHeight)
        hourHandView = UIView(frame: hourHandViewFrame)
        hourHandView.center = CGPoint(x: radius - hourHandViewFrame.width/2,
                                      y: centerPoint.y)
        hourHandView.backgroundColor = .black
        hourHandView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        self.addSubview(hourHandView)
    }
    
    func setDegrees(forView: UIView) {
        let nextDegrees = self.nextDegrees(forView: forView)
        let transform = CGAffineTransform(rotationAngle: nextDegrees * .pi / 180.0)
        forView.transform = transform
    }
    
    func currentDegrees(forView view: UIView) -> CGFloat {
        let radians = atan2(view.transform.b, view.transform.a)
        var currentDegrees: CGFloat = radians * 180 / .pi
        
        if currentDegrees == 360.0 {
            currentDegrees = 0
        }
        return currentDegrees
    }
    
    func nextDegrees(forView view: UIView) -> CGFloat {
        let currentDegrees: CGFloat = self.currentDegrees(forView: view)
        var nextDegrees: CGFloat = 0.0
        
        switch view {
        case self.hourHandView:
            nextDegrees = currentDegrees + 30.0
            
        case self.minuteHandView:
            nextDegrees = currentDegrees + 6.0
            
        case self.secondHandView:
            nextDegrees = currentDegrees + 6.0
        default:
            break
        }
        
        return nextDegrees
    }
    
    // MARK: - 시간 설정
    func setTime() {
        let timeArray: [String] = currentTime()
        
        guard let hour = NumberFormatter().number(from: timeArray[0]),
            let minute = NumberFormatter().number(from: timeArray[1]),
            let second = NumberFormatter().number(from: timeArray[2]) else {
                return
        }
        
        // 1시간은 30도 + 1분당 6도씩 움직임
        let hourDegree = CGFloat(truncating: hour) * 30.0 + CGFloat(truncating: minute) * 0.5
        let hourRadian = hourDegree * .pi / 180.0
        let hourTransform = CGAffineTransform(rotationAngle: hourRadian)
        
        if hourHandView.transform != hourTransform {
            hourHandView.transform = hourTransform
        }
        
        let minuteRadian = CGFloat(truncating: minute) * 6.0 * .pi / 180.0
        let minuteTransform = CGAffineTransform(rotationAngle:minuteRadian)
        
        if minuteHandView.transform != minuteTransform {
            minuteHandView.transform = minuteTransform
        }
        
        let secondRadian = CGFloat(truncating: second) * 6.0 * .pi / 180.0
        let secondTransform = CGAffineTransform(rotationAngle: secondRadian)
        
        if secondHandView.transform != secondTransform {
            secondHandView.transform = secondTransform
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

