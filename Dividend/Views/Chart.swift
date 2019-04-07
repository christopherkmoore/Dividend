//
//  Chart.swift
//  DividendDaily
//
//  Created by Christopher Moore on 8/22/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import UIKit

protocol ChartToggleable {
    func chartWillUpdate(with duration: IEXApiClient.Duration)
    func chartWillDisplay(_ display: Chart.Display)
}

class Chart: UIView {
    
    public enum Display: String, CaseIterable {
        case dividend = "Dividend History"
        case stock = "Historical Averages"
    }
    
    private var chartPoints: [ChartPointOneYear]!

    
    required convenience init(frame: CGRect, with chartPoints: [ChartPointOneYear]) {
        self.init(frame: frame)
        self.chartPoints = chartPoints
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setup(with points: [ChartPointOneYear]) {
        self.chartPoints = points
    }
    
    // Begin drawing
    override func draw(_ rect: CGRect) {
        guard chartPoints != nil,
            !chartPoints.isEmpty else { return }
        
        let yLowyHigh = findYRange()
        let maxYOffset = rect.maxY - 15
        let graphPath = UIBezierPath()

        graphPath.move(to: CGPoint(x: 0,
                                   y: maxYOffset * (CGFloat((yLowyHigh.max - chartPoints.first!.close)) / CGFloat((yLowyHigh.max - yLowyHigh.min))) + 10 ))
        for i in 0..<chartPoints.count {
            
            let xOffset = (rect.maxX * (CGFloat(CGFloat(1)/CGFloat(chartPoints.count)))) / 2
            
            let point = chartPoints[i]
            let newPoint = CGPoint(
                x: rect.maxX * (CGFloat(CGFloat(i)/CGFloat(chartPoints.count))) + xOffset,
                y: maxYOffset * (CGFloat((yLowyHigh.max - point.close)) / CGFloat((yLowyHigh.max - yLowyHigh.min))) + 10)
            graphPath.addLine(to: newPoint)
        }
        UIColor.black.setStroke()
        graphPath.lineWidth = 1.0
        graphPath.stroke()
        
    }
    
    private func findYRange() -> (min: Double, max: Double) {
        var min: Double = 0
        var max: Double = 0
        
        let temp = chartPoints!
            .filter {
                $0.close != 0 || $0.open != 0
            }
            .sorted { (first, second) -> Bool in
                first.close < second.close
            }
        min = temp.first!.close
        max = temp.last!.close
        
        return (min, max)
    }
    
}
