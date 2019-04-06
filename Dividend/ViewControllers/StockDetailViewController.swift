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
    weak var stockDelegate: StockManagerDelegate?
    var stock: Stock!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if stockDelegate == nil {
            self.stockDelegate = self
            StockManager.shared.addDelegate(self)
        }
        
        registerCells()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateChart(using: .y1)
    }
    
    public func getChartData(for stock: Stock, using duration: IEXApiClient.Duration, completion: @escaping (([ChartPointOneYear]?) -> Void)) {
        
        IEXApiClient.shared.getChartData(for: stock, with: duration) { result in
            guard case let .success(points) = result else {
                if case let .failure(error) = result {
                    let alert = UIAlertController(title: "Unable to get information", message: error.localizedDescription, preferredStyle: .alert)
                    let dismiss = UIAlertAction(title: "Dismiss", style: .cancel)
                    alert.addAction(dismiss)
                    
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                return
            }
            completion(points)
        }
    }
    
    private func updateChart(using duration: IEXApiClient.Duration) {
        let indexPath = IndexPath(row: Sections.banner.rawValue, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! BannerTableViewCell
        getChartData(for: stock, using: duration) { points in
            guard let points = points else { return }
            
            DispatchQueue.main.async {
                cell.set(using: points)
            }
        }
    }
}

extension StockDetailViewController: StockManagerDelegate {
    func stocksDidUpdate() {
        //TODO: Refresh views
    }
}

extension StockDetailViewController: ChartToggleable {
    
    func chartWillDisplay(_ display: Chart.Display) {
        //
    }
    
    func chartWillUpdate(with duration: IEXApiClient.Duration) {
        updateChart(using: duration)
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
        
        timeChangersCell.delegate = self
        metricsChangersCell.delegate = self

        DispatchQueue.main.async {
            titleCell.set(using: self.stock)
            timeChangersCell.set()
            metricsChangersCell.set()
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
        case .title: return UIScreen.main.bounds.height / 17
        case .banner: return UIScreen.main.bounds.height / 3
        case .timeChangers: return UIScreen.main.bounds.height / 17
        case .metricChangers: return UIScreen.main.bounds.height / 17
        case .metrics: return UIScreen.main.bounds.height / 9
        case .modifyShares: return UIScreen.main.bounds.height / 9
        }
    }
}
