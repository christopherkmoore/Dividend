
import Foundation
import UIKit

class MetricsTableViewCell: UITableViewCell {
    
    public static let identifier = "MetricsTableViewCell"
    public static let nib = UINib(nibName: MetricsTableViewCell.identifier, bundle: nil)
    
    @IBOutlet weak var stackView: UIStackView!
    
    public private(set) var displaying: Chart.Display = .stock
    weak var stock: Stock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func stockMetrics(using stock: Stock) {
        self.stock = stock
        self.stackView.subviews.forEach { $0.removeFromSuperview() }
        
//        String(format: "%.2f", dividend.increase)
        let open: String = String(format: "%.2f", stock.quote?.open ?? 0)
        let volume = String(format: "%.2f", stock.quote?.latestVolume ?? 0)
        let high = String(format: "%.2f", stock.quote?.high ?? 0)
        let avgVol = String(describing: stock.quote?.avgTotalVolume ?? 0)
        let low = String(describing: stock.quote?.low ?? 0)
        let marketCap = String(describing: stock.quote?.marketCap ?? 0 )
        let week52High = String(describing: stock.quote?.week52High ?? 0)
        let peRatio = String(describing: stock.quote?.peRatio ?? 0)
        let week52Low = String(describing: stock.quote?.week52Low ?? 0)
        // TODO: For now dis gunn be a dirty hack, but I need a way of determining average.
        // for now, assume all stocks pay quarterly.
        let yearlyDividend = (stock.dividend?.firstObject as! Dividend).amount * 4
        let currentPrice = stock.quote?.latestPrice ?? Double(0)
        let currentYield = String(format: "%.4f", (yearlyDividend / currentPrice))
        
        stackView.addArrangedSubview(createLabels(using: "Open", and: open, "Volume", volume))
        stackView.addArrangedSubview(createLabels(using: "High", and: high, "Avg Vol", avgVol))
        stackView.addArrangedSubview(createLabels(using: "Low", and: low, "Mkt Cap", marketCap))
        stackView.addArrangedSubview(createLabels(using: "52 High", and: week52High, "P/E", peRatio))
        stackView.addArrangedSubview(createLabels(using: "52 Low", and: week52Low, "Div %", currentYield))
        
        stackView.layoutSubviews()

    }
    
    public func dividendMetrics(using stock: Stock) {
        self.stock = stock
        self.stackView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        stackView.subviews.forEach { $0.addUnderlineView() }
        stackView.arrangedSubviews.forEach { $0.addUnderline() }
    }
    
    func createLabels(using key: String, and value: String, _ key2: String, _ value2: String) -> UIStackView {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = 5

        let paragraph = NSMutableParagraphStyle()
        paragraph.tabStops = [
            NSTextTab(textAlignment: .right, location: 190, options: [:]),
        ]
        
        let str = key + "\t" + value
        let str2 = key2 + "\t" + value2
        
        let attributed = NSAttributedString(string: str, attributes: [NSAttributedString.Key.paragraphStyle: paragraph])
       let attributed2 = NSAttributedString(string: str2, attributes: [NSAttributedString.Key.paragraphStyle: paragraph])
        
        let label1 = UILabel()
        label1.attributedText = attributed
        
        let label2 = UILabel()
        label2.attributedText = attributed2
        
        horizontalStackView.addArrangedSubview(label1)
        horizontalStackView.addArrangedSubview(label2)
        
        return horizontalStackView
    }
}

extension MetricsTableViewCell: MetricsUpdates {
    func metricsShouldShowStockMetrics() {
        guard displaying == .dividend else { return }
        
        stockMetrics(using: stock!)
        self.displaying = .stock
    }
    
    func metricsShouldShowDividendMetrics() {
        guard displaying == .stock else { return }
        
        dividendMetrics(using: stock!)
        self.displaying = .dividend
    }
    
    
}
