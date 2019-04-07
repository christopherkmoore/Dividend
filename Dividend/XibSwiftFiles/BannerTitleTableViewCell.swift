
import Foundation
import UIKit

class BannerTitleTableViewCell: UITableViewCell {
    
    public static let identifier = "BannerTitleTableViewCell"
    public static let nib = UINib(nibName: BannerTitleTableViewCell.identifier, bundle: nil)
    
    
    @IBOutlet weak var ticker: UILabel!
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var change: UILabel!
    
    weak var stock: Stock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func set(using stock: Stock) {

        if let open = stock.quote?.open,
            let latest = stock.quote?.latestPrice {
            
            let todaysChange = open - latest
            let rounded = String(format: "%.2f", todaysChange)
            
            if rounded.first == "-" {
                change.textColor = .red
            } else {
                change.textColor = .green
            }
            self.change.text = rounded
        }
        
        self.ticker.text = stock.ticker
        self.stockName.text = stock.quote?.companyName ?? ""
        self.price.text = String(format: "%.2f", stock.quote?.latestPrice ?? 0)
        self.center = self.contentView.center
        self.stock = stock
    }
}

extension BannerTitleTableViewCell: BannerTitleUpdates {
    func bannerTitleShouldFinish() {
        if let stock = self.stock {
            set(using: stock)
        }
    }
    
    func bannerTitleShouldUpdate(with point: ChartPointOneYear) {
        
        self.price.text = String(format: "%.2f", point.close)
        let priceDifference = point.close - (stock?.quote?.latestPrice ?? 0) 
        self.change.text = String(format: "%.2f", priceDifference)
        self.stockName.text = point.date
        
        if priceDifference < 0 {
            change.textColor = .red
        } else {
            change.textColor = .green
        }
    }
}
