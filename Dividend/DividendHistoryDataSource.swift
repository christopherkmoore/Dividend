//
//  DividendHistoryDataSource.swift
//  Dividend
//
//  Created by Christopher Moore on 2/23/19.
//  Copyright © 2019 Christopher Moore. All rights reserved.
//

import Foundation

protocol DividendHistoryDelegate {
    
    func loadRows() 
}

public class DividendHistoryDataSource {
    
    // get things
    
    func loadEx() {
        var dividendsToShow: [Dividend] = [Dividend]()
        StockManager.shared.stocks.forEach { stock in
            let divs = stock.dividend?
                .map { $0 as? Dividend }
            
            guard var dividends = divs else { return }
            let dividendsSincePurchase = dividends
                .filter { dividend in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MM/dd/yyyy"
                    guard let cutoff = formatter.date(from: dividend?.exDate ?? "") else { return true ; print("error parsing date \(dividend?.exDate)")}
                    return cutoff > stock.dateAddedToPortfolio
                    
                }
            dividendsSincePurchase.forEach {
                if let final = $0 {
                    dividendsToShow.append(final)
                }
            }
        }
            
    }
    
    // munge things
    
    // present things
}
extension Date {
    
}
