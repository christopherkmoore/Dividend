//
//  HistoryTableViewCell.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/30/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import UIKit
import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    public static let identifier = "HistoryTableViewCell"
    public static let nib = UINib(nibName: HistoryTableViewCell.identifier, bundle: nil)
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setPayment(using dividend: Dividend) {
        
        guard let ticker = dividend.stock?.ticker else { return }
        
        let description = "\(ticker) is paying on \(dividend.paymentDate)"
        let amount = "\(dividend.amount)"
        
        rightTextLabel.text = description
        leftLabel.text = amount
    }
    
    public func setHistory(using dividend: Dividend) {
        
        guard let ticker = dividend.stock?.ticker else { return }
        
        let description = "\(ticker) paid \(dividend.paymentDate)"
        let amount = "\(dividend.amount)"
        
        rightTextLabel.text = description
        leftLabel.text = amount

    }
    
    
}

