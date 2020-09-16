/// Bym

import UIKit
import Anchorage
import RealmSwift

private let stackWidth = UIScreen.main.bounds.width - 180
private let imageSize = CGSize(width: stackWidth, height: stackWidth)

final class DataControlViewController: UIViewController, UINavigationControllerDelegate {
    enum Action {
        case edit(product: Storage), add
    }
    
    // MARK: - UI Elements
    private let profileImageView = UIImageView(image: R.Image.placeholder.scaled(toSize: imageSize))
    
    private let nameField = AHTextField(primaryText: R.String.name)
    
    private let quantityField = AHTextField(primaryText: R.String.quantity)
    
    private let priceField = AHTextField(primaryText: R.String.price)
    
    private let categoryField = AHTextField(primaryText: R.String.category)
    
    private let actionButton = UIButton()
    
    private let editCategoryButton = UIButton()
    
    private lazy var fields = [nameField, quantityField, priceField, categoryField]
    
    // MARK: - Properties
    let presenter: DataControlPresenter
    
    let currentAction: Action
    
    init(presenter: DataControlPresenter, action: Action = .add) {
        self.presenter = presenter
        self.currentAction = action
        super.init(nibName: nil, bundle: nil)
        presenter.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addKeyBoardObserver()
        presentationController?.delegate = self
    }
}

private extension DataControlViewController {
    
    func setupView() {
        // MARK: - Position
        let stackView = UIStackView(arrangedSubviews: [profileImageView, nameField, priceField, quantityField, categoryField])
        stackView.axis = .vertical
        stackView.spacing = 12
        
        let imvSize = CGSize(width: view.bounds.width - 180, height: view.bounds.width - 180)
        profileImageView.sizeAnchors == imvSize
        
        view.addSubview(stackView)
        stackView.horizontalAnchors == view.horizontalAnchors + 90
        
        let topSpacing: CGFloat = UIDevice.isIphone320Width || UIDevice.isIphone375Width ? 30 : 50
        stackView.topAnchor == view.safeAreaLayoutGuide.topAnchor + topSpacing
        
        view.addSubview(actionButton)
        actionButton.topAnchor == stackView.bottomAnchor + 15
        actionButton.trailingAnchor == stackView.trailingAnchor
        
        view.addSubview(editCategoryButton)
        editCategoryButton.bottomAnchor == stackView.bottomAnchor
        editCategoryButton.sizeAnchors == CGSize(width: 35, height: 35)
        editCategoryButton.leadingAnchor == stackView.trailingAnchor + 5
        
        // MARK: - Properties
        view.backgroundColor = .background
        
        profileImageView.isUserInteractionEnabled = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.masksToBounds = true
        
        nameField.delegate = self
        nameField.autocapitalizationType = .words
        nameField.autocorrectionType = .no
        
        quantityField.delegate = self
        quantityField.keyboardType = .numberPad
        
        editCategoryButton.setImage(UIImage(systemName: "eyedropper"), for: .normal)
        editCategoryButton.tintColor = UIColor.newBlue.withAlphaComponent(0.8)
        editCategoryButton.addTarget(self, action: #selector(toEditCategory), for: .touchUpInside)
        
        priceField.delegate = self
        priceField.keyboardType = .numberPad
        
        categoryField.inputView = presenter.pickerView
        categoryField.inputAccessoryView = presenter.toolBar
        
        switch currentAction {
        case .add:
            actionButton.setTitle(R.String.add, for: .normal)
            actionButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        case .edit(let product):
            profileImageView.image = product.image.scaleToFit(size: imageSize)
            nameField.text = product.name
            quantityField.text = product.quantityStr
            priceField.text = product.priceStr
            categoryField.text = product.ofCategory.first?.title
            
            presenter.editingProduct = product
            presenter.currentCategory = product.ofCategory.first
            actionButton.setTitle(R.String.edit, for: .normal)
            actionButton.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        }
        
        actionButton.setTitleColor(.newRed, for: .normal)
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPhoto)))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: .endEditing))
        isModalInPresentation = false
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func addKeyBoardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if view.frame.origin.y != 0 || keyboardSize.height == 0 {
            return
        }
        
        let padding: CGFloat = 10
        let spacing = view.frame.size.height - actionButton.frame.maxY - keyboardSize.height - padding
        if spacing < 0 {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = spacing
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    // MARK: - Action
    @objc func selectPhoto() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(title: R.String.fromLibrary) {
            self.showPicker(sourceType: .photoLibrary)
        }
        
        alert.addAction(title: R.String.takeNewPhoto) {
            self.showPicker(sourceType: .camera)
        }
        
        alert.addCancelAction()
        
        present(alert, animated: true, completion: nil)
    }
    
    func showPicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func getProductFromFields() -> Storage? {
        
        guard
            let name = nameField.text,
            let price = Int(priceField.text!.replacingOccurrences(of: ",", with: "")),
            let quantity = Int(quantityField.text!.replacingOccurrences(of: ",", with: "")),
            presenter.currentCategory != nil else {
                AlertService.show(in: self, msg: R.String.invalidInput)
                return nil
        }
        
        let id = presenter.editingProduct?.id ?? 0
        return Storage(id: id, name: name, price: price, quantity: quantity, image: profileImageView.image!)
    }
    
    func refreshView() {
        view.endEditing(true)
        
        fields.forEach { $0.text = "" }
        profileImageView.image = R.Image.placeholder.scaled(toSize: CGSize(width: stackWidth, height: stackWidth))
    }
    
    @objc
    func addAction() {
        guard let addingProduct = getProductFromFields() else {
            return
        }
        presenter.addProduct(addingProduct)
    }
    
    @objc
    func editAction() {
        guard let editingProduct = getProductFromFields() else {
            return
        }
        presenter.editProduct(editingProduct)
    }
    
    @objc
    func toEditCategory() {
        let categoryVC = CategoryViewController(categories: presenter.categories, realmService: presenter.realmService)
        present(UINavigationController(rootViewController: categoryVC), animated: true, completion: nil)
    }
}

// MARK: - ViewModel Delegate
extension DataControlViewController: DataControlDelegate {
    func didAddProduct() {
        AlertService.showSuccess(in: self)
        refreshView()
    }
    
    func didEditProduct() {
        AlertService.showSuccess(in: self)
        refreshView()
    }
    
    func didSelectCategory() {
        view.endEditing(true)
        categoryField.text = presenter.currentCategory?.title
    }
}

// MARK: - UIPickerControllerDelegate
extension DataControlViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            let imageSize = CGSize(width: 250, height: 250)
            profileImageView.image = pickedImage.scaleToFit(size: imageSize)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - TextField Delegate
extension DataControlViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == nameField || (string.isBackspace && textField.text!.count == 1) {
            return true
        }
        
        let newValueString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                                                          .replacingOccurrences(of: ",", with: "")
        if let newInt = Int(newValueString), newValueString.count < 9 {
            textField.text = newInt.addedSeparator()
        }
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameField:
            priceField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
}

// MARK: - Presentation Delegate
extension DataControlViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return fields.allSatisfy { $0.text == "" }
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: nil, message: R.String.closeWithoutSaving, preferredStyle: .actionSheet)
        alert.addAction(title: R.String.continue) {
            self.dismiss(animated: true, completion: nil)
        }
        alert.addCancelAction()
        present(alert, animated: true, completion: nil)
    }
    
}
