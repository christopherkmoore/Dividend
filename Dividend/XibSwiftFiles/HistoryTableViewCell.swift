
import Foundation
import UIKit
import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    public static let identifier = "HistoryTableViewCell"
    public static let nib = UINib(nibName: HistoryTableViewCell.identifier, bundle: nil)
    
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var datePaid: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var changeSinceLast: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func set(using dividend: Dividend) {
        guard let ticker = dividend.stock?.ticker else { return }
        
        companyName.text = ticker
        datePaid.text = dividend.paymentDate
        amount.text = String(format: "%.2f", dividend.amount)
        
        changeSinceLast.text = dividend.increase != 0 ? String(format: "%.2f", dividend.increase) : ""
        if dividend.increase > 0 {
            changeSinceLast.text? = "+" + (changeSinceLast.text ?? "")
        }
        changeSinceLast.textColor = dividend.increase > 0 ? .green : .red
    }
}
