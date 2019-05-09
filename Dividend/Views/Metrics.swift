
import Foundation
import UIKit

protocol MetricsUpdates {
    func metricsShouldShowStockMetrics()
    func metricsShouldShowDividendMetrics()
}

class Metrics: UIStackView {
    
    weak var stock: Stock?
    
    required convenience init(frame: CGRect, stock: Stock, _ displayType: Chart.Display) {
        self.init(frame: frame)
        
        self.stock = stock
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .top
        
        self.addArrangedSubview(createLabels(using: "something", and: "value"))
        self.addArrangedSubview(createLabels(using: "something", and: "value"))
        self.addArrangedSubview(createLabels(using: "something", and: "value"))
    }
    
    func createLabels(using key: String, and value: String) -> UIStackView {
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fillEqually
        
        let hostView = UIView(frame: verticalStackView.frame)
        
        let keyLabel = UILabel()
        keyLabel.textAlignment = .left
        keyLabel.text = key
        hostView.addSubview(keyLabel)
        
        let valueLabel = UILabel()
        valueLabel.textAlignment = .right
        valueLabel.text = value
        hostView.addSubview(valueLabel)
        
        verticalStackView.addArrangedSubview(hostView)
        
        return verticalStackView
    }
    
}
