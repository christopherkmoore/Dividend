
import Foundation
import CoreData
import UIKit

protocol DividendHistoryDelegate {
    
    func loadRows() 
}

class DividendHistoryDataSource {
    
    public private(set) lazy var upcoming = [Dividend]()
    public private(set) lazy var history = [Dividend]()
    
    init() {
        let dividends = loadPayment()
        self.upcoming = dividends.upcoming
        self.history = dividends.history
    }
    
    public func reload() {
        let dividends = loadPayment()
        self.upcoming = dividends.upcoming
        self.history = dividends.history
    }
    
    public func loadPayment() -> (upcoming: [Dividend], history: [Dividend]) {
        var dividendsToShow: [Dividend] = [Dividend]()
        StockManager.shared.stocks.forEach { stock in
            let divs = stock.dividend?
                .map { $0 as? Dividend }
            
            guard let dividends = divs else { return }
            let dividendsSincePurchase = dividends
                .filter { dividend in
                    guard let cutoff = dividend?.paymentDate.date() else {
                        print("error parsing date \(dividend?.paymentDate)")
                        return true
                    }
                    return cutoff > stock.dateAddedToPortfolio
                    
                }
            dividendsSincePurchase.forEach {
                if let final = $0 {
                    dividendsToShow.append(final)
                }
            }
        }
        let upcoming = lookUpcomingPayments(for: dividendsToShow)
        let history = dividendsToShow
            .filter { !upcoming.contains($0) }
            .sorted { (first, second) -> Bool in
                return first.exDate.date()! > second.exDate.date()!
        }
        
        return (upcoming, history)
    }
    
    func lookUpcomingPayments(for dividends: [Dividend]) -> [Dividend] {

        let upcomingPayments = dividends.filter {
            // is todays date > the recorded date && before the payout date
            let today = Date()
            guard let recorded = $0.recordDate.date() else { return true }
            guard let payoutDate = $0.paymentDate.date() else { return true }
            if today > recorded  && payoutDate > today {
                return true
            }
            return false
        }
        return upcomingPayments
    }
    
    // munge things
    
    // present things
}

extension String {
    
    func date() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter.date(from: self)
    }
}

extension Date {
    
}
