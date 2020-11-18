//
//  ViewController.swift
//  SampleProject
//
//  Created by SutieDev on 2020/11/17.
//  Copyright © 2020 developers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributedString = NSMutableAttributedString(string: "공동인증 로그인\n(구)공인인증서")
        print("attributedString.length = \(attributedString.length)")
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        
        let smallFont = UIFont.systemFont(ofSize: 14)
        attributedString.addAttribute(NSAttributedString.Key.font, value: smallFont,
                                      range: NSRange(location: 9, length: attributedString.length - 9))
        button.setAttributedTitle(attributedString, for: .normal)
    }
}

