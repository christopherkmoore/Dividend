//
//  StockDetailViewController.swift
//  DividendDaily
//
//  Created by Christopher Moore on 8/18/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import UIKit

class StockDetailViewController: UIViewController {
    
    private enum Sections: Int, CaseIterable {
        case title
        case banner
        case timeChangers
        case metricChangers
        case metrics
        case modifyShares
    }
    
    @IBOutlet weak var tableView: UITableView!
    weak var stockDelegate: StockManagerDelegate!
    var viewModel: StockDetailViewModel!
    var stock: Stock! {
        didSet {
            // wait for API call to finish to load the chart
            if stock.chartPointsOneYear != nil,
                tableView != nil {
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [IndexPath(row: Sections.banner.rawValue, section: 0)], with: .automatic)
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
        
        registerCells()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func getChartData(for stock: Stock) {
        IEXApiClient.shared.getChartDataOneYear(for: stock) { (success, stock, error) in
            guard
                let stock = stock,
                let chartPoints = stock.chartPointsOneYear
                else { return }
            StockManager.shared.update(stock, using: chartPoints)
            self.stock = stock
        }
    }
}

extension StockDetailViewController: StockManagerDelegate {
    func stocksDidUpdate() {
        //TODO: Refresh views
    }
}

extension StockDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func registerCells() {
        tableView.register(BannerTitleTableViewCell.nib, forCellReuseIdentifier: BannerTitleTableViewCell.identifier)
        tableView.register(BannerTableViewCell.nib, forCellReuseIdentifier: BannerTableViewCell.identifier)
        tableView.register(TimeChangersTableViewCell.nib, forCellReuseIdentifier: TimeChangersTableViewCell.identifier)
        tableView.register(MetricsChangerTableViewCell.nib, forCellReuseIdentifier: MetricsChangerTableViewCell.identifier)
        tableView.register(MetricsTableViewCell.nib, forCellReuseIdentifier:
            MetricsTableViewCell.identifier)
        tableView.register(ModifySharesTableViewCell.nib, forCellReuseIdentifier: ModifySharesTableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let titleCell = tableView.dequeueReusableCell(withIdentifier: BannerTitleTableViewCell.identifier, for: IndexPath(row: Sections.title.rawValue, section: 0)) as! BannerTitleTableViewCell
        let bannerCell = tableView.dequeueReusableCell(withIdentifier: BannerTableViewCell.identifier, for: IndexPath(row: Sections.banner.rawValue, section: 0)) as! BannerTableViewCell
        let timeChangersCell = tableView.dequeueReusableCell(withIdentifier: TimeChangersTableViewCell.identifier, for: IndexPath(row: Sections.timeChangers.rawValue, section: 0)) as! TimeChangersTableViewCell
        let metricsChangersCell = tableView.dequeueReusableCell(withIdentifier: MetricsChangerTableViewCell.identifier, for: IndexPath(row: Sections.metricChangers.rawValue, section: 0)) as! MetricsChangerTableViewCell
        let metricsCell = tableView.dequeueReusableCell(withIdentifier: MetricsTableViewCell.identifier, for: IndexPath(row: Sections.metrics.rawValue, section: 0)) as! MetricsTableViewCell
        let modifySharesCell = tableView.dequeueReusableCell(withIdentifier: ModifySharesTableViewCell.identifier, for: IndexPath(row: Sections.modifyShares.rawValue, section: 0)) as! ModifySharesTableViewCell
        
        DispatchQueue.main.async {
            bannerCell.set(using: self.stock)
            titleCell.set(using: self.stock)
        }
        
        guard let section = Sections(rawValue: indexPath.row) else { return UITableViewCell() }

        switch section {
        case .title: return titleCell
        case .banner: return bannerCell
        case .timeChangers: return timeChangersCell
        case .metricChangers: return metricsChangersCell
        case .metrics: return metricsCell
        case .modifyShares: return modifySharesCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Sections(rawValue: indexPath.row) else { return CGFloat(0) }

        switch section {
        case .title: return CGFloat(50)
        case .banner: return UIScreen.main.bounds.height / 3
        case .timeChangers: CGFloat(50)
        case .metricChangers: CGFloat(50)
        case .metrics: return CGFloat(100)
        case .modifyShares: return CGFloat(100)
        default: return CGFloat(0)
        }
        return CGFloat(0)
    }
}
