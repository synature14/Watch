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
        
        for i in 1...12 {
            labels[i-1].frame = CGRect(x: 100, y: 100, width: 10, height: 10)
            labels[i-1].text = "\(i)"
            self.addSubview(labels[i-1])
        }
        
        guard let scanLayout = self.scanLayout else {
            return
        }
        setLabelDesign(layout: scanLayout)
        
        createHandViews()
    }
    

    func createHandViews() {
        print("center = \(center)")
        hourHandView = UIView(frame: CGRect(x: circle.cgPath.boundingBox.minX + radius, y: circle.cgPath.boundingBox.maxY - radius, width: 5, height: radius - 10))
        hourHandView.backgroundColor = .red
        self.addSubview(hourHandView)
        
        guard let scanLayout = self.scanLayout else {
            return
        }
        setHandViewDesign(layout: scanLayout)
    }
    
    @objc func tick() {
        let time = DateFormatter.localizedString(from: Date(),
                                                 dateStyle: .medium,
                                                 timeStyle: .medium)
        print("시간 : \(time)")
        let newAnchorPoint = CGPoint(x: hourHandView.layer.anchorPoint.x + 0.3, y: hourHandView.layer.anchorPoint.y + 0.3)
        print("newAnchorPoint = \(newAnchorPoint)")
        setAnchorPoint(anchorPoint: newAnchorPoint, forView: hourHandView)
    }
    
    
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x,
                               y: view.bounds.size.height * anchorPoint.y)
        
        
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x,
                               y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
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
                $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
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
                $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
                $0.textColor = .blue
            }
        default:
            break
        }
    }
}
