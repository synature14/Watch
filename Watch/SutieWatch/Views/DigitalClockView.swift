//
//  DigitalClockView.swift
//  SutieWatch
//
//  Created by SutieDev on 2020/12/02.
//  Copyright © 2020 developers. All rights reserved.
//

import UIKit
import Lottie

class DigitalClockView: UIView {
    let time: WatchTime!
    
    var numberViews: [AnimationView] = []       // 숫자 4개 필요

    let hourDigit_1 = AnimationView()
    let hourDigit_2 = AnimationView()
    let minuteDigit_1 = AnimationView()
    let minuteDigit_2 = AnimationView()
    
    init(frame: CGRect, time: WatchTime) {
        self.time = time
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        setup()
    }
    

    func setup() {
        let hour = String(time.hour)
        print("[DigitalClockView] hour = \(hour)")
        
        if hour.count > 1 {     // ex) 10시, 11시, 12시
            hourDigit_1.animation = Animation.named("jiggly-\(hour.first!)")
        } else {
            hourDigit_1.animation = Animation.named("jiggly-0")
        }
        
        hourDigit_2.animation = Animation.named("jiggly-\(hour.last!)")
        
        let spacing: CGFloat = 5.0
        hourDigit_1.frame = CGRect(x: 0, y: 0, width: self.bounds.width/2 - spacing, height: self.bounds.height/2)
        hourDigit_2.frame = CGRect(x: hourDigit_1.frame.maxX, y: hourDigit_1.frame.minY, width: hourDigit_1.frame.width, height: hourDigit_1.frame.height)
        
        
        let minute = String(time.minute)
        print("[DigitalClockView] minute = \(minute)")
        if minute.count > 1 {
            minuteDigit_1.animation = Animation.named("jiggly-\(minute.first!)")
        } else {
            minuteDigit_1.animation = Animation.named("jiggly-0")
        }
        minuteDigit_2.animation = Animation.named("jiggly-\(minute.last!)")
        
        numberViews = [hourDigit_1, hourDigit_2, minuteDigit_1, minuteDigit_2]
        numberViews.forEach {
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .playOnce
            $0.play()
            self.addSubview($0)
        }
        
        minuteDigit_1.frame = CGRect(x: hourDigit_1.frame.minX, y: hourDigit_1.frame.maxY + 10,
                                     width: hourDigit_1.frame.width, height: hourDigit_1.frame.height)
        
        minuteDigit_2.frame = CGRect(x: hourDigit_2.frame.minX, y: minuteDigit_1.frame.minY,
                                     width: hourDigit_1.frame.width, height: hourDigit_1.frame.height)
    }
}
