/// Bym

import UIKit
import Anchorage
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    
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
    
    private lazy var notification = UINotificationFeedbackGenerator()
    
    // MARK: Properties
    
    // MARK: View lyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

private extension HomeViewController {
    
    func setupView() {
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
        view.backgroundColor = .background
        
        cartTableView.dataSource = presenter
        cartTableView.register(cell: CartCell.self)
        
        topOrderView.selectButton.addTarget(self, action: #selector(showSelectView), for: .touchUpInside)
        topOrderView.addButton.addTarget(self, action: #selector(addToCartAction), for: .touchUpInside)
        
        topOrderView.quantityField.delegate = self
        
        disablePayButton()
        payButton.addTarget(self, action: #selector(payAction), for: .touchUpInside)
        
        totalAmountLabel.text = "\(R.String.totalAmount): 0"
        totalAmountLabel.textAlignment = .right
        totalAmountLabel.textColor = .text
        
        scrollView.keyboardDismissMode = .onDrag
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: .endEditing))
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func disablePayButton() {
        payButton.isUserInteractionEnabled = false
        payButton.alpha = 0.6
    }
    
    func enablePayButton() {
        payButton.isUserInteractionEnabled = true
        payButton.alpha = 1
    }
    
    func updateTotalAmount() {
        totalAmountLabel.text = R.String.totalAmount + ": " + presenter.totalAmountStr()
    }
    
    // MARK: Actions
    @objc
    func addToCartAction() {
        view.endEditing(false)
        
        guard let quantity = Int(topOrderView.quantityField.text!.replacingOccurrences(of: ",", with: "")) else {
            AlertService.show(in: self, msg: R.String.invalidInput)
            return
        }
        presenter.onHandProduct?.quantity = quantity
        presenter.addProductToCart()
    }
    
    @objc
    func payAction() {
        view.endEditing(false)
        presenter.pay()
    }
    
    @objc
    func showSelectView() {
        let selectVC = HomeSelectViewController(products: presenter.storageItems.sorted { $0.name < $1.name })
        selectVC.didSelectProduct = presenter.take
        present(selectVC, animated: true, completion: nil)
    }
    
}

// MARK: - ViewModel Delegate
extension HomeViewController: HomeDelegate {
    func didAddItemToCart(success: Bool, reloadIndex: Int?) {
        guard success else {
            AlertService.show(in: self, msg: R.String.pickProductFirst)
            return
        }
        
        if !presenter.cartItems.isEmpty {
            enablePayButton()
        }
        
        if let reloadIndex = reloadIndex {
            cartTableView.reloadRows(at: [IndexPath(row: reloadIndex, section: 0)], with: .automatic)
        } else {
            cartTableView.beginUpdates()
            cartTableView.insertRows(at: [IndexPath(row: presenter.cartItems.count - 1, section: 0)], with: .bottom)
            cartTableView.endUpdates()
        }
        updateTotalAmount()
        notification.notificationOccurred(.success)
    }
    
    func didSelectAProduct() {
        topOrderView.nameField.text = presenter.onHandProduct?.name
        topOrderView.quantityField.text = presenter.onHandProduct?.quantityStr
        topOrderView.priceField.text = presenter.onHandProduct?.priceStr
    }
    
    func didUnselectAProduct() {
        topOrderView.nameField.text = ""
        topOrderView.quantityField.text = ""
        topOrderView.priceField.text = ""
    }
    
    func didPay() {
        cartTableView.reloadData()
        
        disablePayButton()
        updateTotalAmount()
        
        AlertService.showSuccess(in: self)
        notification.notificationOccurred(.success)
    }
    
    func didRemoveACardItem() {
        if presenter.cartItems.isEmpty {
            disablePayButton()
        }
        updateTotalAmount()
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
