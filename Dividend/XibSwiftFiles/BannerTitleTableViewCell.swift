
import Foundation
import UIKit

class BannerTitleTableViewCell: UITableViewCell {
    
    public static let identifier = "BannerTitleTableViewCell"
    public static let nib = UINib(nibName: BannerTitleTableViewCell.identifier, bundle: nil)
    
    
    @IBOutlet weak var ticker: UILabel!
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var change: UILabel!
    
    
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
                change.textColor = .red
            } else {
                change.textColor = .green
                change.textColor = .green
            }
            self.change.text = rounded
        }
        
        self.ticker.text = stock.ticker
        self.stockName.text = stock.quote?.companyName ?? ""
        self.price.text = String(format: "%.2f", stock.quote?.latestPrice ?? 0)
        self.center = self.contentView.center
    }
}
