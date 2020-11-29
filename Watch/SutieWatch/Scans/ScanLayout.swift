//
//  ScanLayout.swift
//  SutieWatch
//
//  Created by SutieDev on 2020/11/18.
//  Copyright © 2020 developers. All rights reserved.
//

import Foundation

enum ScanLayout {
    case natural
    case modern
    case classic
    
    func stringValue() -> String {
        switch self {
        case .modern:
            return "modern"
        case .natural:
            return "natural"
        case .classic:
            return "classic"
        }
    }
}
