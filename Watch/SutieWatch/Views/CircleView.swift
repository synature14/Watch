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
    
    var timer: Timer!
    
    init(frame: CGRect, scanLayout: ScanLayout) {
        self.scanLayout = scanLayout
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // 0. timer 1초
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                            target: self,
                                            selector: #selector(tick),
                                            userInfo: nil,
                                            repeats: true)
        
        // 1. 지름, 반지름 셋팅
        self.diameter = rect.width
        self.radius = diameter / 2
        
        self.backgroundColor = .orange
        
        // 2. 원 그리기
        UIColor.black.set()
        self.circle = UIBezierPath(ovalIn: CGRect(x: 3, y: 3, width: rect.width - 5, height: rect.height - 5))
        circle.stroke()

        // 3. 숫자 레이블 셋팅
        setTextLayer()
        
        guard let scanLayout = self.scanLayout else {
            return
        }
        setLabelDesign(layout: scanLayout)
        
        createHandViews()
    }
    

    func createHandViews() {
        hourHandView = UIView()
        minuteHandView = UIView()
        
        let secondHandViewFrame = CGRect(x: radius, y: radius/2, width: 5, height: radius - textLayers[0].frame.height)
        secondHandView = UIView(frame: secondHandViewFrame)
        secondHandView.backgroundColor = .red
        secondHandView.layer.anchorPoint = CGPoint(x: 0, y: 1)
        self.addSubview(secondHandView)
        
        guard let scanLayout = self.scanLayout else {
            return
        }
        setHandViewDesign(layout: scanLayout)
        
        print("\ncircle Path : \(circle.cgPath.currentPoint)\n")
    }
    
    @objc func tick() {
        let time = DateFormatter.localizedString(from: Date(),
                                                 dateStyle: .medium,
                                                 timeStyle: .medium)
        print("시간 : \(time)")
        let secondHandViewAnchor = secondHandView.layer.anchorPoint
        print("secondHandView Anchor = \(secondHandViewAnchor)")
        setAnchorPoint(anchorPoint: secondHandViewAnchor, forView: secondHandView)
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
        for i in 1...12 {
            let smallCircleRadius: Double = Double(radius) - 15
            let paddingX: Double = 5
            let paddingY: Double = 5
            
            //            let theta = 30 * Double(i) * 180 / .pi
            
            let theta = Double(i) * 30 / .pi * 2.0 * 2.0   // 360도를 12시 ~ 1시로 나눔
            //            let theta: Double = Double(i) / 12.0 * 2.0 * .pi
            let a = smallCircleRadius * cos(theta)
            let b = smallCircleRadius * sin(theta)
            let X = smallCircleRadius + b
            let Y = smallCircleRadius - a
            
            print("label point = (\(X), \(Y))")
            
            let textLayer = CATextLayer()
            textLayer.fontSize = 14
            textLayer.frame = CGRect(x: X + paddingX, y: Y + paddingY, width: 30, height: 20)
            textLayer.string = "\(i)"
            textLayer.alignmentMode = .center
            textLayer.foregroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).cgColor
            self.layer.addSublayer(textLayer)
            self.textLayers.append(textLayer)
        }
    }
    
    func changeScan(_ layout: ScanLayout) {
        
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
                $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
                $0.foregroundColor = UIColor.brown.cgColor
            }
            
        case .modern:
            print("modern")
            textLayers.forEach {
                $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
                $0.foregroundColor = UIColor.purple.cgColor
            }
            
        case .classic:
            print("classic")

            textLayers.forEach {
                $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
                $0.foregroundColor = UIColor.blue.cgColor
            }
        default:
            break
        }
    }
}
