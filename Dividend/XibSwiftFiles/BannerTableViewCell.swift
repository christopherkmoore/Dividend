//
//  BannerTableViewCell.swift
//  DividendDaily
//
//  Created by Christopher Moore on 8/20/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import UIKit

class BannerTableViewCell: UITableViewCell {
    
    public static let identifier = "BannerTableViewCell"
    public static let nib = UINib(nibName: BannerTableViewCell.identifier, bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// rough estimates for layout margins of a Chart
    /// This is the larger chart shown in the details view
    private struct Margins {
        static let width: CGFloat = 30
        static let height: CGFloat = 30
    }
    
    public func set(using chartPoints: [ChartPointOneYear]) {
        
        for view in subviews {
            if view.accessibilityIdentifier == "chart" {
                view.removeFromSuperview()
            }
        }
        
        let frame = CGRect(x: 0, y: 0, width: self.frame.width - Margins.width, height: self.frame.height - Margins.height)
        
        let chart = Chart(frame: frame, with: chartPoints)
        chart.backgroundColor = .white
        chart.center = self.contentView.center
        chart.accessibilityIdentifier = "chart"
        self.addSubview(chart)
    }
}
