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
        
        // 1. 지름, 반지름 셋팅
        self.diameter = rect.width
        self.radius = diameter / 2
        
        // 2. 원 그리기
        UIColor.black.set()
        self.circle = UIBezierPath(ovalIn: CGRect(x: 3, y: 3, width: rect.width - 5, height: rect.height - 5))
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
        setTime()
    }
    

    func createHandViews() {
        hourHandView = UIView()
        minuteHandView = UIView()
        
        let secondHandViewFrame = CGRect(x: radius + textLayers[0].frame.width/2, y: radius/2, width: 2.5, height: radius - textLayers[0].frame.height)
        secondHandView = UIView(frame: secondHandViewFrame)
        secondHandView.backgroundColor = .red
        secondHandView.center = CGPoint(x: radius + textLayers[0].frame.width/2, y: radius)
        secondHandView.layer.anchorPoint = CGPoint(x: 0, y: 1)
        self.addSubview(secondHandView)
        
        let minuteHandViewHeight = secondHandViewFrame.height - 15
        let minuteHandViewFrame = CGRect(x: radius + textLayers[0].frame.width/2, y: radius, width: secondHandViewFrame.width + 1, height: minuteHandViewHeight)
        minuteHandView = UIView(frame: minuteHandViewFrame)
        minuteHandView.center = CGPoint(x: radius + textLayers[0].frame.width/2, y: radius)
        minuteHandView.backgroundColor = .darkGray
        minuteHandView.layer.anchorPoint = CGPoint(x: 0, y: 1)
        self.addSubview(minuteHandView)
        
        let hourHandViewHeight = minuteHandViewHeight - 20
        let hourHandViewFrame = CGRect(x: radius + textLayers[0].frame.width/2, y: radius, width: minuteHandViewFrame.width + 2.5, height: hourHandViewHeight)
        hourHandView = UIView(frame: hourHandViewFrame)
        hourHandView.center = CGPoint(x: radius + textLayers[0].frame.width/2, y: radius)
        hourHandView.backgroundColor = .black
        hourHandView.layer.anchorPoint = CGPoint(x: 0, y: 1)
        self.addSubview(hourHandView)
        
        
        guard let scanLayout = self.scanLayout else {
            return
        }
        setHandViewDesign(layout: scanLayout)
        
        print("\ncircle Path : \(circle.cgPath.currentPoint)\n")
    }
    
    
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        let radians = atan2(view.transform.b, view.transform.a)
        var currentDegrees: CGFloat = radians * 180 / .pi
        
        if currentDegrees == 360.0 {
            currentDegrees = 0
        }
        
        var nextDegrees: CGFloat = 0.0
        let duration: TimeInterval = 1.0
        
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
        print("nextDegrees = \(nextDegrees)")
        
        let transform = CGAffineTransform(rotationAngle: nextDegrees * .pi / 180.0)
        view.transform = transform
    }
    
    
    func setTextLayer() {
        let smallCircleRadius: CGFloat = radius - 9
        let paddingX: CGFloat = 2
        let paddingY: CGFloat = 2
        
        // '12시', '6시' 먼저 한가운데에 정렬
        let textLayerHour = CATextLayer()
        textLayerHour.frame = CGRect(x: radius, y: paddingY, width: 15, height: 20)
        textLayerHour.string = "12"
        textLayerHour.fontSize = 14
        textLayerHour.alignmentMode = .center
        self.layer.addSublayer(textLayerHour)
        self.textLayers.append(textLayerHour)
        
        let textLayer6 = CATextLayer()
        textLayer6.frame = CGRect(x: radius, y: smallCircleRadius*2 - paddingY, width: 15, height: 30)
        textLayer6.string = "6"
        textLayer6.fontSize = 14
        textLayer6.alignmentMode = .center
        self.layer.addSublayer(textLayer6)
        self.textLayers.append(textLayer6)
        
        
        let textLayer3 = CATextLayer()
        textLayer3.frame = CGRect(x: smallCircleRadius*2, y: smallCircleRadius - paddingY, width: 15, height: 30)
        textLayer3.string = "3"
        textLayer3.fontSize = 14
        textLayer3.alignmentMode = .center
        self.layer.addSublayer(textLayer3)
        self.textLayers.append(textLayer3)
        
        let textLayer9 = CATextLayer()
        textLayer9.frame = CGRect(x: paddingX, y: textLayer3.frame.minY, width: 15, height: 30)
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
            
            print("label point = (\(X), \(Y))")
            
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: X + paddingX, y: Y + paddingY, width: 15, height: 20)
            textLayer.string = "\(i)"
            self.layer.addSublayer(textLayer)
            self.textLayers.append(textLayer)
        }
    }
    
    func changeScan(_ layout: ScanLayout) {
        
    }
    
    // MARK: - 시간 설정
    func setTime() {
        let date = DateFormatter.localizedString(from: Date(),
                                                 dateStyle: .medium,
                                                 timeStyle: .medium)
        
        var dateArray = date.split(separator: " ")
        let AMPM = dateArray.dropLast().first!
        print("\(AMPM)")
        var timeArray = dateArray.popLast()
        let time = timeArray?.split(separator: ":").first!
        print("\(time)시 \(time?[1])분 \(time[2])초")
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
            textLayers.forEach {
                $0.fontSize = 14
                $0.foregroundColor = UIColor.brown.cgColor
                $0.alignmentMode = .center
            }
            
        case .modern:
            print("modern")
            textLayers.forEach {
                $0.fontSize = 14
                $0.foregroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).cgColor
                $0.alignmentMode = .center
            }
            
        case .classic:
            print("classic")

            textLayers.forEach {
                $0.fontSize = 14
                $0.foregroundColor = UIColor.blue.cgColor
                $0.alignmentMode = .center
            }
        default:
            break
        }
    }
}
