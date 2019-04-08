//
//  BannerTableViewCell.swift
//  DividendDaily
//
//  Created by Christopher Moore on 8/20/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import UIKit

protocol BannerTitleUpdates {
    func bannerTitleShouldUpdate(with point: ChartPointOneYear)
    func bannerTitleShouldFinish()
}

class BannerTableViewCell: UITableViewCell {
    
    public static let identifier = "BannerTableViewCell"
    public static let nib = UINib(nibName: BannerTableViewCell.identifier, bundle: nil)
    
    weak var chart: Chart?
    
    weak var titleDelegate: BannerTitleTableViewCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let tableView = superview as? UITableView else { return }
        tableView.isScrollEnabled = false
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        let pointAdjustedForMargins = point.x - (Margins.width / 2)
        if pointAdjustedForMargins > self.contentView.bounds.width { return }
        
        let chartPoint = chart?.didTouchDownAtPoint(pointAdjustedForMargins)
        guard let final = chartPoint else { return }
        titleDelegate?.bannerTitleShouldUpdate(with: final)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let tableView = superview as? UITableView else { return }
        tableView.isScrollEnabled = true
        
        titleDelegate?.bannerTitleShouldFinish()
        chart?.didFinishTouching()
    }
    
    /// rough estimates for layout margins of a Chart
    /// This is the larger chart shown in the details view
    private struct Margins {
        static let width: CGFloat = 30
        static let height: CGFloat = 30
    }
    
    public func set(using chartPoints: [ChartPointOneYear]) {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width - Margins.width, height: self.frame.height - Margins.height)
        
        let chart = Chart(frame: frame, with: chartPoints)
        chart.backgroundColor = .white
        chart.center = self.contentView.center
        chart.accessibilityIdentifier = "chart"
        self.chart = chart
        self.addSubview(chart)
    }
    
    public func removeChart() {
        self.chart = nil
        for view in subviews {
            if view.accessibilityIdentifier == "chart" {
                view.removeFromSuperview()
            }
        }
    }
}
