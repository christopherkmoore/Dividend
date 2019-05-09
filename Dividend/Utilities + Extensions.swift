//
//  Utilities + Extensions.swift
//  DividendDaily
//
//  Created by Christopher Moore on 8/8/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import UIKit

extension DateFormatter {
    
    static var yyyyMMdd: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter
    }
    
    public static var mMddyyyDashFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.dateStyle = .short
        formatter.timeZone = .current
        formatter.timeStyle = .none
        
        return formatter
    }
}

extension UIColor {
    
    static var systemBlue: UIColor {
        return UIButton(type: .system).tintColor
    }
    
}

extension UIView {
    func addUnderlineView() {
        let view = UIView()
        view.frame = CGRect(x: self.frame.minX, y: self.frame.height, width: self.frame.width - 2 , height: 1)

        view.backgroundColor = .black
        self.addSubview(view)
    }
    
    func addUnderline() {
        let bottom = CALayer()
        bottom.frame = CGRect(x: self.frame.minX, y: self.frame.height, width: self.frame.width - 2 , height: 1)
        bottom.backgroundColor = UIColor.purple.cgColor
    
        self.layer.addSublayer(bottom)
        layer.needsLayout()
    }
}
