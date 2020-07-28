/// Bym

import UIKit
import Anchorage

fileprivate let leftRightPadding: CGFloat = 20
fileprivate let midPadding: CGFloat = 15

final class HomeSelectViewController: UIViewController {
    
    private let headView = UIView(backgroundColor: .newRed)
    private let noDataView = NoDataView(text: R.String.noStorageItemMsg)
    
    var collectionView: UICollectionView!
    
    let products: [Storage]
    
    var didSelectProduct: ((Storage) -> Void)?
    
    init(products: [Storage]) {
        self.products = products
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = R.String.homeSelectTitle
        
        headView.sizeAnchors == CGSize(width: view.bounds.width, height: 110)
        
        let titleLabel = Label(text: R.String.select, color: .white)
        titleLabel.font = .boldSystemFont(ofSize: 30)
        
        headView.addSubview(titleLabel)
        titleLabel.bottomAnchor == headView.bottomAnchor - 15
        titleLabel.leadingAnchor == headView.leadingAnchor + 15
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .background
        
        let stack = UIStackView(arrangedSubviews: [headView, collectionView])
        stack.axis = .vertical
        view.addSubview(stack)
        stack.edgeAnchors == view.edgeAnchors
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cell: HomeSelectCell.self)
    }
    
}

extension HomeSelectViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cell: HomeSelectCell.self, indexPath: indexPath)
        cell.configure(withProduct: products[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectProduct?(products[indexPath.item])
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: leftRightPadding, bottom: 15, right: leftRightPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width2Items = (UIScreen.main.bounds.width - 2 * leftRightPadding - midPadding) / 2
        let width3Items = (UIScreen.main.bounds.width - 2 * leftRightPadding - 2 * midPadding) / 3
        
        let size2Items = CGSize(width: width2Items, height: width2Items + 50)
        let size3Items = CGSize(width: width3Items, height: width3Items + 50)
        
        return UIDevice.isIphone320Width || UIDevice.isIphone375Width ? size2Items : size3Items
    }
}
