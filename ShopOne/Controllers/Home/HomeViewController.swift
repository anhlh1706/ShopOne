/// Bym

import UIKit
import Anchorage
import RxSwift
import RxCocoa

final class HomeViewController: ViewController {
    
    let presenter: HomePresenter
    
    init(presenter: HomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        presenter.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Elements
    private let topOrderView = TopOrderView()
    private let cartTableView = AutoResizeTableView()
    private let totalAmountLabel = UILabel()
    private let payButton = PrimaryButton(title: R.String.pay, type: .rounder(6))
    
    private var isPayButtonEnabled = BehaviorRelay<Bool>(value: false)
    
    private lazy var notification = UINotificationFeedbackGenerator()
    
    // MARK: Properties
    
    // MARK: View lyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    override func setupView() {
        let scrollView = UIScrollView()
        
        // MARK: UI Position
        view.addSubview(scrollView)
        scrollView.edgeAnchors == view.safeAreaLayoutGuide.edgeAnchors
        
        scrollView.addSubviews([topOrderView, cartTableView, totalAmountLabel, payButton])
        
        topOrderView.topAnchor == scrollView.topAnchor
        topOrderView.horizontalAnchors == view.horizontalAnchors
        topOrderView.heightAnchor == 200
        
        cartTableView.topAnchor == topOrderView.bottomAnchor + 10
        cartTableView.horizontalAnchors == view.horizontalAnchors + 15
        
        totalAmountLabel.topAnchor == cartTableView.bottomAnchor + 10
        totalAmountLabel.horizontalAnchors == view.horizontalAnchors + 15
        
        payButton.topAnchor == totalAmountLabel.bottomAnchor + 15
        payButton.horizontalAnchors == view.horizontalAnchors + 15
        payButton.heightAnchor == 50
        payButton.bottomAnchor == scrollView.bottomAnchor - 10
        
        // MARK: UI Properties Setup
        
        title = R.String.homeTitle
        
        cartTableView.dataSource = self
        cartTableView.register(cell: CartCell.self)
        
        topOrderView.quantityField.delegate = self
        
        totalAmountLabel.textAlignment = .right
        totalAmountLabel.textColor = .text
        
        scrollView.keyboardDismissMode = .onDrag
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: .endEditing))
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - Interaction
    override func setupInteraction() {
        topOrderView.selectButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let selectVC = HomeSelectViewController(products: self.presenter.storageItems.sorted { $0.name < $1.name })
            selectVC.didSelectProduct = self.presenter.take
            self.present(selectVC, animated: true, completion: nil)
        }).disposed(by: rx.disposeBag)

        topOrderView.addButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.view.endEditing(false)
            
            guard let quantity = Int(self.topOrderView.quantityField.text!.replacingOccurrences(of: ",", with: "")) else {
                self.showErrorMessage(R.String.invalidInput)
                return
            }
            
            let current = self.presenter.onHandProduct.value
            current?.quantity = quantity
            
            self.presenter.onHandProduct.accept(current)
            self.presenter.addProductToCart()
        }).disposed(by: rx.disposeBag)
        
        payButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.view.endEditing(false)
            self?.presenter.pay()
        }).disposed(by: rx.disposeBag)
    }
    
    func bindData() {
        presenter.cartItems.asObservable().subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            self.totalAmountLabel.text = R.String.totalAmount + ": " + self.presenter.totalAmountStr()
            self.isPayButtonEnabled.accept(!value.isEmpty)
        }).disposed(by: rx.disposeBag)
        
        isPayButtonEnabled.asObservable().subscribe(onNext: { [weak self] value in
            self?.payButton.isUserInteractionEnabled = value
            self?.payButton.alpha = value ? 1 : 0.6
        }).disposed(by: rx.disposeBag)
        
        presenter.onHandProduct.asObservable().subscribe(onNext: { [weak self] value in
            self?.topOrderView.nameField.text = value?.name ?? ""
            self?.topOrderView.quantityField.text = value?.quantityStr ?? ""
            self?.topOrderView.priceField.text = value?.priceStr ?? ""
        }).disposed(by: rx.disposeBag)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.cartItems.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cell: CartCell.self, indexPath: indexPath)
        cell.configure(product: presenter.cartItems.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let alert = UIAlertController(title: nil, message: R.String.removeCartMsg, preferredStyle: .alert)
        
        alert.addCancelAction()
        alert.addOkAction { [self] in
            presenter.removeCartItem(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .top)
            tableView.endUpdates()
        }
        
        UIApplication.shared.visibleViewController.present(alert, animated: true, completion: nil)
    }
}

// MARK: - ViewModel Delegate
extension HomeViewController: HomeDelegate {
    func didAddItemToCart(success: Bool, reloadIndex: Int?) {
        guard success else {
            showErrorMessage(R.String.pickProductFirst)
            return
        }
        
        if let reloadIndex = reloadIndex {
            cartTableView.reloadRows(at: [IndexPath(row: reloadIndex, section: 0)], with: .automatic)
        } else {
            cartTableView.beginUpdates()
            cartTableView.insertRows(at: [IndexPath(row: presenter.cartItems.value.count - 1, section: 0)], with: .bottom)
            cartTableView.endUpdates()
        }
        notification.notificationOccurred(.success)
    }
    
    func didPay() {
        cartTableView.reloadData()
        
        AlertService.showSuccess(in: self)
        notification.notificationOccurred(.success)
    }
}

// MARK: - UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newValueString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            .replacingOccurrences(of: ",", with: "")
        if let newInt = Int(newValueString), newValueString.count < 6 {
            textField.text = newInt.addedSeparator()
        }
        
        return false
    }
}
