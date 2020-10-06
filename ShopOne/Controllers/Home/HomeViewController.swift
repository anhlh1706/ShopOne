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
    
    override func bindData() {
        // MARK: - Binding
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
        
        // MARK: - UITableViewDataSource
        presenter.cartItems.asObservable().bind(to: cartTableView.rx.items(cellIdentifier: CartCell.cellId, cellType: CartCell.self)) { (_, element, cell) in
            cell.configure(product: element)
        }.disposed(by: rx.disposeBag)
        
        cartTableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
            let alert = UIAlertController(title: nil, message: R.String.removeCartMsg, preferredStyle: .alert)
            
            alert.addCancelAction()
            alert.addOkAction {
                self?.presenter.removeCartItem(at: indexPath.row)
            }
            
            self?.present(alert, animated: true, completion: nil)
        }).disposed(by: rx.disposeBag)
    }
}

// MARK: - ViewModel Delegate
extension HomeViewController: HomeDelegate {
    func didAddItemToCart(success: Bool, reloadIndex: Int?) {
        guard success else {
            showErrorMessage(R.String.pickProductFirst)
            return
        }
        cartTableView.reloadData()
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
