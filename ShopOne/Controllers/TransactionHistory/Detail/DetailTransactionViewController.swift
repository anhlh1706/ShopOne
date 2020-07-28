/// Bym

import UIKit

final class DetailTransactionViewController: UITableViewController {
    
    let presenter: DetailTransactionPresenter
    
    init(presenter: DetailTransactionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = presenter.transactions?.first?.sellDateStr.prefix(maxLength: 10)
        tableView.register(cell: IconTableViewCell.self)
    }  
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cell: IconTableViewCell.self, indexPath: indexPath)
        if let item = presenter.transactions?[indexPath.row] {
            cell.config(transaction: item)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.transactions?.count ?? 0
    }
}
