
import Foundation
import UIKit

protocol ChartInformationToggleable {
    
    func chartShouldChange()
}

class MetricsChangerTableViewCell: UITableViewCell {
    
    public static let identifier = "MetricsChangerTableViewCell"
    public static let nib = UINib(nibName: MetricsChangerTableViewCell.identifier, bundle: nil)
    
    @IBOutlet weak var stackView: UIStackView!
    weak var delegate: StockDetailViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func set() {
        
        let dividendButton = UIButton(type: .system)
        dividendButton.setTitle(Chart.Display.dividend.rawValue, for: .normal)
        dividendButton.addTarget(self, action: #selector(updateChart(sender:)), for: .touchUpInside)
        
        stackView.addArrangedSubview(dividendButton)
        
        let stockButton = UIButton(type: .system)
        stockButton.setTitle(Chart.Display.stock.rawValue, for: .normal)
        stockButton.addTarget(self, action: #selector(updateChart(sender:)), for: .touchUpInside)
    
        stackView.addArrangedSubview(stockButton)
        
    }
    @objc func updateChart(sender: UIButton) {
        if let text = sender.titleLabel?.text,
            let display = Chart.Display(rawValue: text) {
            delegate?.chartWillDisplay(display)
        }
    }
}
