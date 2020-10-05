/// Bym

import UIKit
import RealmSwift
import Anchorage

fileprivate let closeCellHeight: CGFloat = 168

final class TransactionHistoryViewController: UITableViewController {
    
    private lazy var noDataView = NoDataView(text: R.String.nothingHappened)
    
    var selectedRows = [Int]()
    
    var displayDays = [String]()
    
    var transactions: Results<Transaction>!
    
    var productsByDay = [String: [Transaction]]()
    
    let realmService = RealmService.shared
    
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        transactions = realmService.realm.objects(Transaction.self)
        
        fadeIn()
        updateTableView()
        setupView()
        addObserver()
    }
    
    func fadeIn() {
        tableView.translateAndFade(as: .transitionIn,
                                   animationStyle: UIViewAnimationStyle.transitionAnimationStyle,
                                   percentageEndPoint: 0.4,
                                   translate: .init(x: 0, y: 72))
        
        tableView.visibleCells.enumerated().forEach { (index, cell) in
            cell.translateAndFade(as: .transitionIn,
                                  animationStyle: UIViewAnimationStyle.transitionAnimationStyle,
                                  percentageEndPoint: 0.4,
                                  translate: .init(x: 0, y: CGFloat(index) * 16))
        }
    }
    
    func addObserver() {
        notificationToken = transactions.observe { [unowned self] changes in
            switch changes {
            case .initial, .update:
                self.updateTableView()
            case .error(let error):
                AlertService.show(in: UIApplication.shared.visibleViewController, msg: error.localizedDescription)
            }
        }
    }
    
    func setupView() {
        
        title = R.String.transactionTitle
        view.backgroundColor = .background
        
        tableView.estimatedRowHeight = closeCellHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        tableView.tableFooterView = UIView()
        tableView.register(cell: TransactionCell.self)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        /// Unselect all row
        while !selectedRows.isEmpty {
            let cell = tableView.cellForRow(at: IndexPath(row: selectedRows.removeFirst(), section: 0)) as! TransactionCell
            cell.endAnimation()
        }
        tableView.reloadData()
    }
    
    /// Get data
    /// Show NoDataView if needed
    /// Split sections by days
    /// Reload tableView
    @objc func updateTableView() {
        
        displayDays = Set(transactions.map { $0.sellDateStr.prefix(maxLength: 10) }).sorted(by: >)
        
        if transactions.isEmpty {
            view.addSubview(noDataView)
            noDataView.edgeAnchors == view.safeAreaLayoutGuide.edgeAnchors
            tableView.isScrollEnabled = false
        } else {
            var noDataView = view.subviews.first(where: { $0 == self.noDataView })
            noDataView?.removeFromSuperview()
            noDataView = nil
            tableView.isScrollEnabled = true
        }
        
        for day in displayDays {
            productsByDay[day] = transactions.filter { $0.sellDateStr.prefix(maxLength: 10) == day }
        }
        
        selectedRows.removeAll()
        tableView.reloadData()
    }
    
    func showDetail(transactions: [Transaction]?) {
        let pr = DetailTransactionPresenter()
        pr.transactions = transactions
        let detailVC = DetailTransactionViewController(presenter: pr)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension TransactionHistoryViewController {
    
    // MARK: - UITableViewDatasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cell: TransactionCell.self, indexPath: indexPath)
        cell.configure(withTransactions: productsByDay[displayDays[indexPath.row]]!, forIndex: indexPath.row)
        cell.showMore = showDetail(transactions:)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayDays.count
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !selectedRows.contains(indexPath.row) {
            return closeCellHeight
        }
        
        let productsShow = min(Set<Transaction>(productsByDay[displayDays[indexPath.row]]!).count, 4)
        
        return 110 + CGFloat(productsShow * 92)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let cell = tableView.cellForRow(at: indexPath) as! TransactionCell
        
        var duration = 0.0
        
        if let index = selectedRows.firstIndex(of: indexPath.row) {
            
            selectedRows.remove(at: index)
            
            duration = Double(cell.itemsCount) * 0.22
            cell.endAnimation()
            
        } else {
            selectedRows.append(indexPath.row)
            
            duration = Double(cell.itemsCount) * 0.12
            cell.startAnimation()
        }

        UIView.animate(withDuration: duration) {
            tableView.beginUpdates()
            tableView.endUpdates()
        }

    }
    
}
