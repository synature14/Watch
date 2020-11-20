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
    var labels: [UILabel]!
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
        self.labels = Array.init(repeating: UILabel(), count: 12)
        setLables()
        
        guard let scanLayout = self.scanLayout else {
            return
        }
        setLabelDesign(layout: scanLayout)
        
        createHandViews()
        
        let testView = UIView(frame: CGRect(x: 100, y: 100, width: 70, height: 70))
        testView.backgroundColor = .red
        self.addSubview(testView)
    }
    

    func createHandViews() {
        hourHandView = UIView()
        minuteHandView = UIView()
        
        secondHandView = UIView(frame: CGRect(x: circle.cgPath.boundingBox.minX + radius, y: circle.cgPath.boundingBox.maxY - radius, width: 5, height: radius - 10))
        secondHandView.backgroundColor = .red
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
        let degrees: CGFloat = 300.0
        let transform = CGAffineTransform(translationX: 0, y: 0)
            .rotated(by: degrees * .pi / 180.0)
            .translatedBy(x: -anchorPoint.x, y: -anchorPoint.y)
//        let transform = CGAffineTransform(translationX: anchorPoint.x, y: anchorPoint.y)
//            .rotated(by: degrees * .pi / 180.0 )
//            .translatedBy(x: -anchorPoint.x, y: -anchorPoint.y)
        
        UIView.animate(withDuration: 5) {
            view.transform = transform
        }
    }
    
    
    func setLables() {
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
            
            let textLayer: CATextLayer = CATextLayer()
            textLayer.fontSize = 14
            textLayer.frame = CGRect(x: X + paddingX, y: Y + paddingY, width: 30, height: 20)
            textLayer.string = "\(i)"
            textLayer.alignmentMode = .center
            textLayer.foregroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).cgColor
            self.layer.addSublayer(textLayer)
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
            labels.forEach {
                $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
                $0.textColor = .brown
            }
            
        case .modern:
            print("modern")
            labels.forEach {
                $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
                $0.textColor = .purple
            }
            
        case .classic:
            print("classic")

            labels.forEach {
                $0.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
                $0.textColor = .blue
            }
        default:
            break
        }
    }
}
