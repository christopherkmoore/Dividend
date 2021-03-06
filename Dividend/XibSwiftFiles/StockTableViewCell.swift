//
//  StockTableViewCell.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/9/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import UIKit

class StockTableViewCell: UITableViewCell {
    
    public static let identifier = "StockTableViewCell"
    public static let nib = UINib(nibName: StockTableViewCell.identifier, bundle: nil)
    
    @IBOutlet weak var stockNameLabel: UILabel!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var todaysChangeLabel: UILabel!
    @IBOutlet weak var percentChangelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func set(using viewModel: PortofolioViewModel, at index: Int) {
        guard let stock = StockManager.shared.stock(at: index) else {
            print("Index out of bounds for stocks array at \(index)")
            return
        }
        // Change price to use more 
        if let priceSource = stock.quote?.latestSource, priceSource == "Close" {
            priceLabel.text = "$" + String(format: "%.2f", stock.quote?.close ?? 0)
        }
        
        priceLabel.text = "$" + String(format: "%.2f", stock.quote?.latestPrice ?? 0)

        stockNameLabel.text = stock.quote?.companyName
        tickerLabel.text = stock.quote?.symbol
        
        let todaysChange = viewModel.todaysChange(stock)
        
        if todaysChange.first == "-" {
            todaysChangeLabel.textColor = .red
            percentChangelabel.textColor = .red
        } else {
            todaysChangeLabel.textColor = .green
            percentChangelabel.textColor = .green
        }
        todaysChangeLabel.text = todaysChange
        percentChangelabel.text = viewModel.todaysChangePercent(stock)
    }
}
