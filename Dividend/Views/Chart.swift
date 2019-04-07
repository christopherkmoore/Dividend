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

protocol Touchable {
    func didTouchDownAtPoint(_ point: CGFloat) -> ChartPointOneYear?
    func didFinishTouching()
}

class Chart: UIView {
    
    public enum Display: String, CaseIterable {
        case dividend = "Dividend History"
        case stock = "Historical Averages"
    }
    
    private var chartPoints: [ChartPointOneYear]!
    private var map = [CGFloat: ChartPointOneYear]()
    
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
            let x = rect.maxX * (CGFloat(CGFloat(i)/CGFloat(chartPoints.count))) + xOffset
            let y = maxYOffset * (CGFloat((yLowyHigh.max - point.close)) / CGFloat((yLowyHigh.max - yLowyHigh.min))) + 10
            let newPoint = CGPoint(x: x, y: y)
            graphPath.addLine(to: newPoint)
            
            map[x] = point
        }
        UIColor.black.setStroke()
        graphPath.lineWidth = 1.0
        graphPath.stroke()
        
    }
    
    private func addDateLabels() {
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
    
    func drawXLine(at point: CGFloat) {
        
        let lineLayer = CAShapeLayer()
        let graphLine = UIBezierPath()
        
        graphLine.move(to: CGPoint(x: point, y: 0))
        graphLine.addLine(to: CGPoint(x: point, y: self.frame.maxY))
        graphLine.close()

        lineLayer.path = graphLine.cgPath
        lineLayer.lineWidth = 0.5
        lineLayer.strokeColor = UIColor.lightGray.cgColor
        
        if let lastLayer = self.layer.sublayers?.first {
            self.layer.replaceSublayer(lastLayer, with: lineLayer)
        } else {
            self.layer.addSublayer(lineLayer)
        }
    }
}

extension Chart: Touchable {
    func didFinishTouching() {
        self.layer.sublayers = nil
    }
    
    public func didTouchDownAtPoint(_ point: CGFloat) -> ChartPointOneYear? {
        var closeKeys = [CGFloat]()
        for key in map.keys {
            // we only need a few close keys, break iteration to save cycles after that
            if closeKeys.count > 3 { break }
            // if the points x minus the keys x absolute value is around 1, let's take that key.
            var margin = point - key
            
            // a kind of shitty way of determining the absolute value
            margin = margin < 0 ? margin * -1 : margin
            
            
            if margin <= 1 { closeKeys.append(key)}
        }
        
        var closestKey: CGFloat?
        for key in closeKeys {
            
            if closestKey == nil {
                closestKey = key
                continue
            }
            
            if (point - key) < closestKey ?? 10 {
                closestKey = key
            }
        }
        guard let key = closestKey else { return nil }
        guard let value = map[key] else { return nil }
        drawXLine(at: key)
        return value
    }
}
