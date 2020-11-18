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
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = .orange
        
        UIColor.black.set()
        let circle = UIBezierPath(ovalIn: CGRect(x: 3, y: 3, width: rect.width - 5, height: rect.height - 5))
        circle.stroke()

        
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
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6, execute: {
            UIView.animate(withDuration: 5.0) {
                let rotate = CGAffineTransform(rotationAngle: .pi * 2)
                
            }
        })
        
    }
    

    
    func changeScan(_ layout: ScanLayout) {
        
    }
}

private extension CircleView {
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
