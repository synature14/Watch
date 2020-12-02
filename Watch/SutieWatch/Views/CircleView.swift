//
//  CircleView.swift
//  SutieWatch
//
//  Created by SutieDev on 2020/11/18.
//  Copyright © 2020 developers. All rights reserved.
//

import UIKit

class CircleView: WatchFrameView {
    
    var textLayers: [CATextLayer]! = []
    var circle: UIBezierPath!   // 원
    var diameter: CGFloat!      // 지름
    var radius: CGFloat!        // 반지름
    var smallCircleRadius: CGFloat!  // textLayer 그릴 원
    var centerCircleRadius: CGFloat = 6.0
    
    override func draw(_ rect: CGRect) {
        self.layer.sublayers?.removeAll()
        
        // 1. 지름, 반지름
        self.diameter = rect.width
        self.radius = diameter / 2
        self.smallCircleRadius = radius - 10
        
        print("radius = \(radius)")
        
        // 2. 원 그리기
        UIColor.black.set()
        let circlePadding: CGFloat = 3.0
        self.circle = UIBezierPath(ovalIn: CGRect(x: circlePadding, y: circlePadding, width: rect.width - circlePadding*2, height: rect.height - circlePadding*2))
        circle.stroke()

        // 3. 숫자 레이블 셋팅
        setTextLayer()
        
        guard let scanLayout = self.scanLayout else {
            return
        }
        
        self.setLabelDesign(layout: scanLayout)
        
        setCenterPoint()
        setTime()
    }
    
    func setCenterPoint() {
        let centerCircleView = UIView(frame: CGRect(x: radius - centerCircleRadius, y: radius - centerCircleRadius,
                                                    width: centerCircleRadius*2, height: centerCircleRadius*2))
        centerCircleView.layer.cornerRadius = centerCircleRadius
        centerCircleView.backgroundColor = .darkGray
        self.addSubview(centerCircleView)
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
}

// MARK: - Scan 적용
private extension CircleView {
    func setHandViewDesign(layout: ScanLayout) {
        
    }
    
    func setLabelDesign(layout: ScanLayout) {
        switch layout {
        case .natural:
            print("natural")
            self.textLayers.forEach {
                $0.fontSize = 14
                $0.foregroundColor = UIColor.brown.cgColor
                $0.alignmentMode = .center
            }
            
        case .modern:
            print("modern")
//            let image = UIImage(named: "minuteHand_modern")!
//            let imageView = UIImageView(frame:  CGRect(x: 0, y: 0,
//                                                       width: minuteHandView.frame.width, height: minuteHandView.frame.height))
//            imageView.image = image
//            minuteHandView.addSubview(imageView)
            
            self.textLayers.forEach {
                $0.fontSize = 15
                $0.foregroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).cgColor
                $0.alignmentMode = .center
            }
                        
        case .classic:
            print("classic")
            self.textLayers.forEach {
                $0.fontSize = 14
                $0.foregroundColor = #colorLiteral(red: 0.01090764254, green: 0.2051729858, blue: 0.005126291886, alpha: 1).cgColor
                $0.alignmentMode = .center
            }
        }
    }
}
