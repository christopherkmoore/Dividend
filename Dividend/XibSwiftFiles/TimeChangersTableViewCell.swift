
import Foundation
import UIKit

class TimeChangersTableViewCell: UITableViewCell {
    
    public static let identifier = "TimeChangersTableViewCell"
    public static let nib = UINib(nibName: TimeChangersTableViewCell.identifier, bundle: nil)

    weak var delegate: StockDetailViewController?
    
    @IBOutlet weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func set() {
        for duration in IEXApiClient.Duration.allCases {
            let button = UIButton(type: .system)
            button.setTitle(duration.rawValue, for: .normal)
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.borderWidth = 0.5
            button.addTarget(self, action: #selector(updateChart(sender:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }
    @objc func updateChart(sender: UIButton) {
        
        stackView.subviews.forEach { view in
            if let button = view as? UIButton {
                button.backgroundColor = .white
                button.tintColor = .systemBlue
            }
        }
        
        if let text = sender.titleLabel?.text,
            let duration = IEXApiClient.Duration(rawValue: text) {
            // highlight button
            sender.tintColor = .lightGray
            sender.backgroundColor = .systemBlue
            delegate?.chartWillUpdate(with: duration)
        }
    }
}
