//
//  CircleView.swift
//  SutieWatch
//
//  Created by SutieDev on 2020/11/18.
//  Copyright © 2020 developers. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    var scanLayout: ScanLayout?
    var textLayers: [CATextLayer]! = []
    var circle: UIBezierPath!   // 원
    var diameter: CGFloat!      // 지름
    var radius: CGFloat!        // 반지름
    var smallCircleRadius: CGFloat!  // textLayer 그릴 원
    
    // 시침
    var hourHandView: UIView!
    // 분침
    var minuteHandView: UIView!
    // 초침
    var secondHandView: UIView!
    
    init(frame: CGRect, scanLayout: ScanLayout) {
        self.scanLayout = scanLayout
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        self.layer.sublayers?.removeAll()
        
        // 1. 지름, 반지름
        self.diameter = rect.width
        self.radius = diameter / 2
        self.smallCircleRadius = radius - 10
        
        // 2. 원 그리기
        UIColor.black.set()
        self.circle = UIBezierPath(ovalIn: CGRect(x: 1, y: 1, width: rect.width - 4, height: rect.height - 4))
        circle.stroke()

        // 3. 숫자 레이블 셋팅
        setTextLayer()
        
        guard let scanLayout = self.scanLayout else {
            return
        }
        DispatchQueue.main.async {
            self.setLabelDesign(layout: scanLayout)
        }
        
        createHandViews()
        setCenterPoint()
        setTime()
    }
    

    func createHandViews() {
        hourHandView = UIView()
        minuteHandView = UIView()
        
        let secondHandViewFrame = CGRect(x: 0, y: 0,
                                         width: 2.5, height: radius - textLayers[0].frame.height)
        secondHandView = UIView(frame: secondHandViewFrame)
        secondHandView.backgroundColor = .red
        secondHandView.center = CGPoint(x: radius + secondHandViewFrame.width/2,
                                        y: radius - secondHandViewFrame.width/2)
        secondHandView.layer.anchorPoint = CGPoint(x: 0, y: 1)
        self.addSubview(secondHandView)
        
        let minuteHandViewHeight = secondHandViewFrame.height - 15
        let minuteHandViewFrame = CGRect(x: radius + textLayers[0].frame.width/2, y: radius, width: secondHandViewFrame.width + 1, height: minuteHandViewHeight)
        minuteHandView = UIView(frame: minuteHandViewFrame)
        minuteHandView.center = CGPoint(x: radius + minuteHandViewFrame.width/2, y: radius - 2)
        minuteHandView.backgroundColor = .darkGray
        minuteHandView.layer.anchorPoint = CGPoint(x: 0, y: 1)
        self.addSubview(minuteHandView)
        
        let hourHandViewHeight = minuteHandViewHeight - 20
        let hourHandViewFrame = CGRect(x: 0, y: 0,
                                       width: minuteHandViewFrame.width + 2.5,
                                       height: hourHandViewHeight)
        hourHandView = UIView(frame: hourHandViewFrame)
        hourHandView.center = CGPoint(x: radius - hourHandViewFrame.width / 2, y: radius)
        hourHandView.backgroundColor = .black
        hourHandView.layer.anchorPoint = CGPoint(x: 0, y: 1)
        self.addSubview(hourHandView)
        
        guard let scanLayout = self.scanLayout else {
            return
        }
        setHandViewDesign(layout: scanLayout)
    }
    
    func setCenterPoint() {
        let smallCenterCircleRadius: CGFloat = 5.0
        let centerCircleView = UIView(frame: CGRect(x: radius - smallCenterCircleRadius, y: radius - smallCenterCircleRadius*2,
                                                    width: smallCenterCircleRadius*2, height: smallCenterCircleRadius*2))
        centerCircleView.layer.cornerRadius = smallCenterCircleRadius
        centerCircleView.backgroundColor = .darkGray
        self.addSubview(centerCircleView)
    }
    
    private func nextDegrees(forView view: UIView) -> CGFloat {
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
    
    func currentDegrees(forView view: UIView) -> CGFloat {
        let radians = atan2(view.transform.b, view.transform.a)
        var currentDegrees: CGFloat = radians * 180 / .pi
        
        if currentDegrees == 360.0 {
            currentDegrees = 0
        }
        return currentDegrees
    }
    
    func setDegrees(forView: UIView) {
        let nextDegrees = self.nextDegrees(forView: forView)
        let transform = CGAffineTransform(rotationAngle: nextDegrees * .pi / 180.0)
        forView.transform = transform
    }
    
    
    func setTextLayer() {
        let paddingX: CGFloat = 2
        let paddingY: CGFloat = 2
        let textLayerFullWidth: CGFloat = 20.0
        let textLayerHalfWidth = textLayerFullWidth / 2.0
        
        // '12시', '6시' 먼저 한가운데에 정렬
        let textLayerHour = CATextLayer()
        textLayerHour.frame = CGRect(x: radius - textLayerHalfWidth, y: paddingY,
                                     width: textLayerFullWidth, height: 25)
        textLayerHour.string = "12"
        textLayerHour.fontSize = 14
        textLayerHour.alignmentMode = .center
        self.layer.addSublayer(textLayerHour)
        self.textLayers.append(textLayerHour)
        
        let textLayer6 = CATextLayer()
        textLayer6.frame = CGRect(x: radius - textLayerHalfWidth, y: smallCircleRadius*2 - paddingY,
                                  width: textLayerFullWidth, height: 25)
        textLayer6.string = "6"
        textLayer6.fontSize = 14
        textLayer6.alignmentMode = .center
        self.layer.addSublayer(textLayer6)
        self.textLayers.append(textLayer6)
        
        // '3시', '9시' 좌우 정렬
        let textLayer3 = CATextLayer()
        textLayer3.frame = CGRect(x: diameter - paddingX - textLayerFullWidth, y: smallCircleRadius,
                                  width: textLayerFullWidth, height: 25)
        textLayer3.string = "3"
        textLayer3.fontSize = 14
        textLayer3.alignmentMode = .center
        self.layer.addSublayer(textLayer3)
        self.textLayers.append(textLayer3)
        
        let textLayer9 = CATextLayer()
        textLayer9.frame = CGRect(x: paddingX, y: textLayer3.frame.minY,
                                  width: textLayerFullWidth, height: 25)
        textLayer9.string = "9"
        textLayer9.fontSize = 14
        textLayer9.alignmentMode = .center
        self.layer.addSublayer(textLayer9)
        self.textLayers.append(textLayer9)

        var currentDegree: Double = 0.0
        for i in 1...11 {
            if i == 3 {
                currentDegree = 90
                continue
            } else if i == 6 {
                currentDegree = 180
                continue
            } else if i == 9 {
                currentDegree = 270
                continue
            } else {
                currentDegree += 30
            }
            
            let theta: Double = currentDegree * .pi / 180.0  // 360도를 12시 ~ 1시로 나눔
            let a = Double(smallCircleRadius) * cos(theta)
            let b = Double(smallCircleRadius) * sin(theta)
            let X: CGFloat = smallCircleRadius + CGFloat(b)
            let Y: CGFloat = smallCircleRadius - CGFloat(a)
            
            let textLayer = CATextLayer()
            var textLayerFrameY: CGFloat = 0.0
            if i > 3 && i < 6 {
                textLayerFrameY = Y - paddingY
            } else {
                textLayerFrameY = Y + paddingY
            }
            textLayer.frame = CGRect(x:  X + paddingX, y: textLayerFrameY,
                                     width: textLayerFullWidth, height: 25)
            textLayer.string = "\(i)"
            self.layer.addSublayer(textLayer)
            self.textLayers.append(textLayer)
        }
    }
    
    // MARK: - 스캔 변경
    func changeScan(_ layout: ScanLayout) {
        if self.scanLayout == layout {
            return
        }
        
        self.scanLayout = layout
        self.setLabelDesign(layout: layout)
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

// MARK: - Scan 적용
private extension CircleView {
    func setHandViewDesign(layout: ScanLayout) {
        
    }
    
    func setLabelDesign(layout: ScanLayout) {
        switch layout {
        case .natural:
            print("natural")
            DispatchQueue.main.async {
                self.textLayers.forEach {
                    $0.fontSize = 14
                    $0.foregroundColor = UIColor.brown.cgColor
                    $0.alignmentMode = .center
                }
            }
            
        case .modern:
            print("modern")
            self.textLayers.forEach {
                $0.fontSize = 15
                $0.foregroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).cgColor
                $0.alignmentMode = .center
            }
                        
        case .classic:
            print("classic")

            DispatchQueue.main.async {
                self.textLayers.forEach {
                    $0.fontSize = 14
                    $0.foregroundColor = #colorLiteral(red: 0.01090764254, green: 0.2051729858, blue: 0.005126291886, alpha: 1).cgColor
                    $0.alignmentMode = .center
                }
            }
        }
    }
}
