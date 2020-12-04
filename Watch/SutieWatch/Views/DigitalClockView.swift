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
    

    private func setup() {
        print("[DigitalClockView] hour = \(time.hour)")
        setHour(time.hour)
        let spacing: CGFloat = 5.0
        hourDigit_1.frame = CGRect(x: 0, y: 0, width: self.bounds.width/2 - spacing, height: self.bounds.height/2)
        hourDigit_2.frame = CGRect(x: hourDigit_1.frame.maxX, y: hourDigit_1.frame.minY, width: hourDigit_1.frame.width, height: hourDigit_1.frame.height)
        
        print("[DigitalClockView] minute = \(time.minute)")
        setMinute(time.minute)
        
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
        playAnimationHour()
        playAnimationMinute()
    }
    
    func setMinute(_ minute: Int) {
        let minuteStr = String(minute)
        print("[DigitalClockView] minute = \(minute)")
        if minuteStr.count > 1 {
            minuteDigit_1.animation = Animation.named("jiggly-\(minuteStr.first!)")
            minuteDigit_2.animation = Animation.named("jiggly-\(minuteStr.last!)")
        } else {
            minuteDigit_1.animation = Animation.named("jiggly-0")
            minuteDigit_2.animation = Animation.named("jiggly-\(minuteStr)")
        }
    }
    
    func setHour(_ hour: Int) {
        print("[DigitalClockView] hour = \(hour)")
        let hourStr = String(hour)
        if hourStr.count > 1 {
            hourDigit_1.animation = Animation.named("jiggly-\(hourStr.first!)")
            hourDigit_2.animation = Animation.named("jiggly-\(hourStr.last!)")
        } else {
            hourDigit_1.animation = Animation.named("jiggly-0")
            hourDigit_2.animation = Animation.named("jiggly-\(hourStr)")
        }
    }
    
    func playAnimationHour() {
        hourDigit_1.play()
        hourDigit_2.play()
    }
    
    func playAnimationMinute() {
        minuteDigit_1.play()
        minuteDigit_2.play()
    }
}
