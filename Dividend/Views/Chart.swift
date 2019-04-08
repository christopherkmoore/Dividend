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
        
        let numberOfLines = 3
        
        let yLowyHigh = findYRange()
        let volumeYRange = findVolumeYRange()
        
        // These two properties are used to leave room on the top and side margins
        let chartHeight = rect.maxY - 15
        let chartWidth = rect.maxX - 15
        
        let graphPath = UIBezierPath()
        let volumePath = UIBezierPath()
        let horizontalLines = UIBezierPath()

        graphPath.move(to: CGPoint(x: 0,
                                   y: chartHeight * (CGFloat((yLowyHigh.max - chartPoints.first!.close)) / CGFloat((yLowyHigh.max - yLowyHigh.min))) + 10 ))
        for i in 0..<chartPoints.count {
            
            let xOffset = (chartWidth * (CGFloat(CGFloat(1) / CGFloat(chartPoints.count)))) / 2
            
            let point = chartPoints[i]
            let x = chartWidth * (CGFloat(CGFloat(i)/CGFloat(chartPoints.count))) + xOffset
            let y = chartHeight * (CGFloat((yLowyHigh.max - point.close)) / CGFloat((yLowyHigh.max - yLowyHigh.min))) + 10
            let newPoint = CGPoint(x: x, y: y)
            graphPath.addLine(to: newPoint)
            
            // sketch volume
            let volumeMoveTo = CGPoint(x: x, y: rect.maxY)
            
            // divide volume by the distribution between max and min
            //to see **proportionally* how big the volume line should be
            let yScaler = CGFloat(point.volume) / CGFloat((volumeYRange.max - volumeYRange.min))
            
            // 15 is around the height we want for the highest volume point
            let volumeSketch = CGPoint(x: x, y: rect.maxY - (15 * yScaler ))
            volumePath.move(to: volumeMoveTo)
            
            volumePath.addLine(to: volumeSketch)
            map[x] = point
        }
        
        for i in 0...numberOfLines {
            let y = chartHeight * (CGFloat(i) / CGFloat(numberOfLines))
            
            horizontalLines.move(to: CGPoint(x: 0, y: y))
            horizontalLines.addLine(to: CGPoint(x: frame.maxX, y: y))
        }
        horizontalLines.move(to: CGPoint(x: 0, y: 5))
        horizontalLines.addLine(to: CGPoint(x: frame.maxX, y: 5))
        
        UIColor.black.setStroke()
        graphPath.lineWidth = 1.0
        graphPath.stroke()
        
        UIColor.lightGray.setStroke()
        volumePath.lineWidth = 1.0
        volumePath.stroke()
        
        UIColor.lightGray.setStroke()
        horizontalLines.lineWidth = 0.5
        horizontalLines.stroke()
        
    }
    
    private func findVolumeYRange() -> (min: Int64, max: Int64) {
        let sorted = chartPoints.sorted { (one, two) -> Bool in
            return one.volume > two.volume
        }
        
        let max = sorted.first!.volume
        let min = sorted.last!.volume
        
        return (min, max)
        
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
//        print(value)
        return value
    }
}
