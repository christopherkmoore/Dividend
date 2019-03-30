//
//  HistoryViewController.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/30/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewController: UIViewController {
    
    enum DividendHistorySections: Int,  CaseIterable {
        case upcoming, history
    }
    
    @IBOutlet weak var historyTableView: UITableView!
    
    let dataSource = DividendHistoryDataSource()
    weak var stockDelegate: StockManagerDelegate!
    
    @IBAction func addStock(_ sender: Any) {
        let alert = UIAlertController(title: "add new stock", message: "What would you like to add?", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let text = alert.textFields?.first?.text else { return }
            search(with: text)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(add)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
        func search(with text: String) {
            let ticker = text.uppercased()
            
            IEXApiClient.shared.getStock(ticker) { (success, result, error) in
                guard success else {
                    print(error?.localizedDescription)
                    return
                }
                if let stock = result {
//                    stock.dateAddedToPortfolio = Date()
                    // for debugging dividend history filters
                    stock.dateAddedToPortfolio = ISO8601DateFormatter().date(from: "2016-04-14T10:44:00+0000") ?? Date()
                    StockManager.shared.add(stock)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if stockDelegate == nil {
            self.stockDelegate = self
            StockManager.shared.addDelegate(stockDelegate)
        }
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        historyTableView.register(HistoryTableViewCell.nib, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        historyTableView.rowHeight = UITableView.automaticDimension
    }
}

extension HistoryViewController: StockManagerDelegate {
    func stocksDidUpdate() {
        dataSource.reload()
        DispatchQueue.main.async {
            self.historyTableView.reloadData()
        }  
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return DividendHistorySections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch DividendHistorySections(rawValue: section) {
        case .upcoming?: return "Upcoming Payments"
        case .history?: return "Previous Payments"
        default: return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return dataSource.upcoming.count
        case 1: return dataSource.history.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier) as! HistoryTableViewCell
        
        let indexPathPosition = indexPath.row
        let isUpcoming = indexPath.section == DividendHistorySections.upcoming.rawValue
        
        let dividend = isUpcoming ? dataSource.upcoming[indexPath.row] : dataSource.history[indexPath.row]
        
        if isUpcoming {
            cell.setPayment(using: dividend)
        } else {
            cell.setHistory(using: dividend)
        }
        
        return cell
    }
}
