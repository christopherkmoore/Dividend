
import Foundation
import UIKit

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
        dividendButton.layer.borderColor = UIColor.lightGray.cgColor
        dividendButton.layer.borderWidth = 0.5

        stackView.addArrangedSubview(dividendButton)
        
        let stockButton = UIButton(type: .system)
        stockButton.setTitle(Chart.Display.stock.rawValue, for: .normal)
        stockButton.layer.borderColor = UIColor.lightGray.cgColor
        stockButton.layer.borderWidth = 0.5

        stockButton.addTarget(self, action: #selector(updateChart(sender:)), for: .touchUpInside)
    
        stackView.addArrangedSubview(stockButton)
        
    }
    @objc func updateChart(sender: UIButton) {
        
        stackView.subviews.forEach { view in
            if let button = view as? UIButton {
                button.backgroundColor = .white
                button.tintColor = .systemBlue
            }
        }
        
        if let text = sender.titleLabel?.text,
            let display = Chart.Display(rawValue: text) {
            sender.tintColor = .lightGray
            sender.backgroundColor = .systemBlue
            delegate?.chartWillDisplay(display)
        }
    }
}
