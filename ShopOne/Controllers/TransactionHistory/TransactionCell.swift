/// Bym

import UIKit
import Anchorage
import RealmSwift

final class TransactionHistoryBarView: UIView {
    
    private let axis: NSLayoutConstraint.Axis
    private let indexLabel = Label(color: .white, textAlignment: .center)
    private let dateLabel = Label(color: .white, textAlignment: .center)
    private let totalAmountLabel = Label(color: .white, textAlignment: .center)
    
    init(axis: NSLayoutConstraint.Axis) {
        self.axis = axis
        super.init(frame: .zero)
        
        let labelStack = UIStackView(arrangedSubviews: [indexLabel, dateLabel, totalAmountLabel])
        
        switch axis {
        case .horizontal:
            labelStack.axis = .horizontal
            dateLabel.centerXAnchor == labelStack.centerXAnchor
            
            indexLabel.widthAnchor == 80
            totalAmountLabel.widthAnchor == indexLabel.widthAnchor
        case .vertical:
            labelStack.axis = .vertical
            indexLabel.font = .systemFont(ofSize: 20)
            dateLabel.font = .systemFont(ofSize: 15)
            totalAmountLabel.font = .systemFont(ofSize: 15)
            
            dateLabel.numberOfLines = 2
            
            indexLabel.heightAnchor == 30
            totalAmountLabel.heightAnchor == indexLabel.heightAnchor
        @unknown default:
            break
        }
        
        addSubview(labelStack)
        labelStack.edgeAnchors == edgeAnchors + UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        backgroundColor = .newRed
    }
    
    func configure(_ products: [Transaction], index: Int) {
        
        indexLabel.text = "#\(index)"
        totalAmountLabel.text = products.reduce(0) { $0 + $1.billing }.vndFormat()
        
        let fullDate = products[0].sellDateStr.prefix(maxLength: 10)
        
        let dateMonth = fullDate.suffix(maxLength: 5)
        let year = fullDate.prefix(maxLength: 4)
        if axis == .vertical {
            dateLabel.text = dateMonth + "\n" + year
        } else {
            dateLabel.text = fullDate
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class TransactionCell: UITableViewCell {
    
    private let topView = UIView(backgroundColor: .subBackground)
    private let detailView = UIView(backgroundColor: .subBackground)
    
    private let rowBarView = TransactionHistoryBarView(axis: .vertical)
    private let detailBarView = TransactionHistoryBarView(axis: .horizontal)
    
    private let topProductLabel = Label(fontSize: 20, textAlignment: .right)
    private let topProductDetailView = TransactionDetailItemView()
    
    private let detailItemStackView = UIStackView()
    
    private let viewDetailButton = UIButton()
    
    private var transactions: [Transaction]?
    
    private lazy var detailHeight = detailView.heightAnchor.constraint(equalToConstant: 0)
    
    private var animationViews = UIView()
    
    private var firstImageView = UIImageView()
    private var secondImageView = UIImageView()
    private var secondImagebgView = UIImageView()
    private var thirdImageView = [UIImageView]()
    private var fourthImageView = UIImageView()
    private var firstViewBg = UIImageView()
    private var thirdViewBg = [UIImageView]()
    private var thirdViewNumber = 0
    
    private var animation1 = CABasicAnimation()
    private var animation2 = CABasicAnimation()
    private var animation3 = CABasicAnimation()
    private var backAnimation = CABasicAnimation()
    private var backAnimation1 = CABasicAnimation()
    private var backAnimation2 = CABasicAnimation()
    
    private var animationTransform = CATransform3DIdentity
    
    var itemsCount = 0
    
    var showMore: (([Transaction]?) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setAnimation()
        hiddenView()
        
        animationTransform.m34 = -2.5 / 2000
        
        topView.cornerRadius = 10
        topView.masksToBounds = true
        detailView.cornerRadius = 10
        detailView.masksToBounds = true
        
        viewDetailButton.setTitle(R.String.moreDetail, for: .normal)
        viewDetailButton.setTitleColor(.newRed, for: .normal)
        viewDetailButton.addTarget(self, action: #selector(showMoreDetail), for: .touchUpInside)
        
        detailView.alpha = 0
        topView.alpha = 1
        
        contentView.addSubview(topView)
        topView.topAnchor == topAnchor + 8
        topView.horizontalAnchors == horizontalAnchors + 10
        topView.heightAnchor == 160
        
        contentView.addSubview(detailView)
        detailView.topAnchor == topView.topAnchor
        detailView.horizontalAnchors == horizontalAnchors + 10
        
        topView.addSubview(topProductLabel)
        topProductLabel.topAnchor == topView.topAnchor + 25
        topProductLabel.horizontalAnchors == topView.horizontalAnchors + 10
        
        topView.addSubview(rowBarView)
        rowBarView.verticalAnchors == topView.verticalAnchors
        rowBarView.leadingAnchor == topView.leadingAnchor
        rowBarView.widthAnchor == 80
        
        topView.addSubview(topProductDetailView)
        topProductDetailView.bottomAnchor == topView.bottomAnchor - 10
        topProductDetailView.leadingAnchor == rowBarView.trailingAnchor
        topProductDetailView.trailingAnchor == topView.trailingAnchor
        
        detailView.addSubview(detailBarView)
        detailBarView.horizontalAnchors == detailView.horizontalAnchors
        detailBarView.topAnchor == detailView.topAnchor
        detailBarView.heightAnchor == 55
        
        detailItemStackView.axis = .vertical
        detailItemStackView.spacing = 10
        
        detailView.addSubview(detailItemStackView)
        detailItemStackView.topAnchor == detailView.topAnchor + 55
        detailItemStackView.horizontalAnchors == detailView.horizontalAnchors
        
        detailView.addSubview(viewDetailButton)
        viewDetailButton.topAnchor == detailItemStackView.bottomAnchor + 10
        viewDetailButton.centerXAnchor == detailView.centerXAnchor
        viewDetailButton.sizeAnchors == CGSize(width: 200, height: 40)
        viewDetailButton.bottomAnchor == detailView.bottomAnchor - 5
    }
    
    @objc func showMoreDetail() {
        showMore?(transactions)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withTransactions transactions: [Transaction], forIndex index: Int) {
        self.transactions = transactions
        
        itemsCount = min(Set(transactions.map { $0.id }).count, 4)
        
        detailHeight.constant = 100 + CGFloat(itemsCount * 92)
        
        let totalAmountOfDay = transactions.reduce(0) { $0 + $1.billing }
        let productsGrouped = grouping(transactions: transactions)
        
        let topProduct = productsGrouped[0]
        let topPercent = Double(topProduct.billing) * 100 / Double(totalAmountOfDay)
        
        topProductLabel.text = R.String.topSell + ": " + topProduct.name
        
        topProductDetailView.configure(index: -1, product: topProduct, percent: Int(topPercent.rounded()))
        
        rowBarView.configure(productsGrouped, index: index)
        detailBarView.configure(productsGrouped, index: index)
        
        detailItemStackView.removeAllArrangedSubviews()
        
        for (index, product) in productsGrouped.prefix(4).enumerated() {
            
            let percent = Double(product.billing) * 100 / Double(totalAmountOfDay)
            
            let detailItemView = TransactionDetailItemView()
            detailItemView.configure(index: index, product: product, percent: Int(percent.rounded()))

            detailItemStackView.addArrangedSubview(detailItemView)
            
            detailItemView.widthAnchor == detailItemStackView.widthAnchor
        }
        
    }
    
    /// Group given transactions by product to get sum of quantity that product sold.
    /// - Parameter transactions: List of transaction to group
    func grouping(transactions: [Transaction]) -> [Transaction] {
        
        let productIds = Array(Set(transactions.map { $0.id }))
        
        return productIds.map { id -> Transaction in
            
            let totalQuantity = transactions.filter({ $0.id == id }).reduce(0) { $0 + $1.quantity }
            
            let product = transactions.first(where: { $0.id == id })!
            
            return Transaction(id: product.id,
                               name: product.name,
                               price: product.price,
                               quantity: totalQuantity,
                               categoryName: product.categoryName,
                               image: product.image,
                               transactionId: product.transactionId,
                               sellDate: product.sellDate)
        }.sorted { $0.billing > $1.billing }
    }
    
    func creatAnimationView() {
        
        detailView.alpha = 1
        
        if itemsCount > 3 {
            thirdViewBg = [UIImageView](repeatElement(UIImageView(), count: itemsCount - 3))
            thirdImageView = [UIImageView](repeatElement(UIImageView(), count: itemsCount - 3))
        }
        
        animationViews = UIView(frame: CGRect(x: topView.frame.minX,
                                              y: topView.frame.minY,
                                              width: detailView.frame.width,
                                              height: detailView.frame.height))
        
        let firstImage = detailView.selfCapture(frame: CGRect(x: detailView.bounds.minX,
                                                              y: detailView.bounds.minY,
                                                              width: topView.frame.width,
                                                              height: topView.frame.height))
        
        firstViewBg = UIImageView(image: firstImage)
        firstViewBg.frame = CGRect(x: detailView.bounds.minX,
                                   y: detailView.bounds.minY,
                                   width: topView.frame.width,
                                   height: topView.frame.height)
        firstViewBg.alpha = 0
        firstViewBg.layer.cornerRadius = 10
        firstViewBg.layer.masksToBounds = true
        
        animationViews.addSubview(firstViewBg)
        
        let forgroundViewImage = topView.selfCapture(frame: topView.bounds)
        firstImageView = UIImageView(image: forgroundViewImage)
        firstImageView.frame = topView.bounds
        firstImageView.layer.cornerRadius = 10
        firstImageView.layer.masksToBounds = true
        firstImageView.layer.transform = animationTransform
        
        animationViews.addSubview(firstImageView)
        
        var imageFrame = firstImageView.frame
        firstImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        firstImageView.frame = imageFrame
        
        let secondImage = detailView.selfCapture(frame: CGRect(x: 0,
                                                               y: topView.bounds.height,
                                                               width: topView.frame.width,
                                                               height: topView.frame.height))
        
        secondImageView = UIImageView(image: secondImage)
        secondImageView.frame = CGRect(x: 0,
                                       y: topView.bounds.height,
                                       width: topView.frame.width,
                                       height: topView.frame.height)
        
        secondImageView.layer.transform = animationTransform
        animationViews.addSubview(secondImageView)
        firstImageView.alpha = 0
        
        imageFrame = secondImageView.frame
        secondImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        secondImageView.frame = imageFrame
        secondImageView.alpha = 0
        
        let itemHeight = (detailView.frame.height - topView.frame.height * 2) / CGFloat(itemsCount - 2)
        
        if itemHeight > 0 && itemsCount > 2 {
            
            for i in 0..<thirdViewBg.count {
                let thirdImage = detailView.selfCapture(frame: CGRect(x: 0,
                                                                      y: topView.bounds.height * 2.0 + CGFloat(i) * itemHeight,
                                                                      width: topView.frame.width,
                                                                      height: itemHeight))
                thirdViewBg[i] = UIImageView(image: thirdImage)
                thirdViewBg[i].frame = CGRect(x: 0,
                                              y: topView.bounds.height * 2.0 + CGFloat(i) * itemHeight,
                                              width: topView.frame.width,
                                              height: itemHeight)
                thirdViewBg[i].alpha = 0
                animationViews.addSubview(thirdViewBg[i])
                
                thirdImageView[i].backgroundColor = .subBackground
                thirdImageView[i].frame = thirdViewBg[i].frame
                thirdImageView[i].layer.transform = animationTransform
                animationViews.addSubview(thirdImageView[i])
                
                imageFrame = thirdViewBg[i].frame
                thirdImageView[i].layer.anchorPoint = CGPoint(x: 0.5, y: 1)
                thirdImageView[i].frame = imageFrame
                thirdImageView[i].alpha = 0
            }
            
            secondImagebgView.backgroundColor = .subBackground
            secondImagebgView.frame = CGRect(x: 0,
                                             y: secondImageView.frame.height - itemHeight,
                                             width: detailView.frame.width,
                                             height: itemHeight)
            
            imageFrame = secondImagebgView.frame
            secondImagebgView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            secondImagebgView.frame = imageFrame
            secondImagebgView.layer.transform = animationTransform
            secondImageView.addSubview(secondImagebgView)
            
            let fifthImage = detailView.selfCapture(frame: CGRect(x: 0,
                                                                  y: detailView.bounds.height - itemHeight,
                                                                  width: topView.frame.width,
                                                                  height: itemHeight))
            fourthImageView = UIImageView(image: fifthImage)
            fourthImageView.frame = CGRect(x: 0,
                                           y: detailView.bounds.height - itemHeight,
                                           width: topView.frame.width,
                                           height: itemHeight)
            
            fourthImageView.layer.transform = animationTransform
            fourthImageView.layer.cornerRadius = 10
            animationViews.addSubview(fourthImageView)
            
            imageFrame = fourthImageView.frame
            fourthImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            fourthImageView.frame = imageFrame
            fourthImageView.alpha = 0
            fourthImageView.layer.transform = animationTransform
        }
        
        contentView.addSubview(animationViews)
        contentView.bringSubviewToFront(animationViews)
        detailView.alpha = 0
    }
    
    func startAnimation() {
        creatAnimationView()
        topView.alpha = 0
        animationViews.alpha = 1
        firstViewBg.alpha = 1
        firstImageView.alpha = 1
        firstViewBg.layer.shouldRasterize = true
        if itemsCount > 1 {
            firstImageView.layer.add(animation1, forKey: "firstImageView")
        } else {
            animationViews.alpha = 0
            detailView.alpha = 1
        }
    }
    
    func endAnimation() {
        detailView.alpha = 0
        animationViews.alpha = 1
        topView.alpha = 1
        if itemsCount > 1 {
            fourthImageView.layer.add(backAnimation, forKey: "backAnimation")
        } else {
            animationViews.alpha = 0
        }
    }
    
    func hiddenView() {
        firstImageView.layer.removeAllAnimations()
        secondImageView.layer.removeAllAnimations()
        secondImagebgView.layer.removeAllAnimations()
        for i in 0..<thirdImageView.count {
            thirdImageView[i].layer.removeAllAnimations()
        }
        fourthImageView.layer.removeAllAnimations()
        
        detailView.alpha = 0
        topView.alpha = 1
        animationViews.alpha = 0
        firstImageView.alpha = 0
        secondImageView.alpha = 0
        secondImagebgView.alpha = 0
        for i in 0..<thirdViewBg.count {
            thirdViewBg[i].alpha = 0
            
        }
        fourthImageView.alpha = 0
        thirdViewNumber = 0
        animationViews.removeFromSuperview()
    }
    
    func setAnimation() {
        let duration = 0.2
        
        animation1 = CABasicAnimation(keyPath: "transform.rotation.x")
        animation1.fromValue = 0
        animation1.toValue = -CGFloat.pi / 2.0
        animation1.duration = 0.13
        animation1.isRemovedOnCompletion = false
        animation1.fillMode = .forwards
        animation1.delegate = self
        
        animation2 = CABasicAnimation(keyPath: "transform.rotation.x")
        animation2.fromValue = CGFloat.pi / 2.0
        animation2.toValue = 0
        animation2.duration = 0.13
        animation2.isRemovedOnCompletion = false
        animation2.fillMode = .forwards
        animation2.delegate = self
        
        animation3 = CABasicAnimation(keyPath: "transform.rotation.x")
        animation3.fromValue = 0
        animation3.toValue = -CGFloat.pi
        animation3.duration = duration
        animation3.isRemovedOnCompletion = false
        animation3.fillMode = .forwards
        animation3.delegate = self
        
        backAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
        backAnimation.fromValue = 0
        backAnimation.toValue = CGFloat.pi / 2.0
        backAnimation.duration = duration / 2.0
        backAnimation.isRemovedOnCompletion = false
        backAnimation.fillMode = .forwards
        backAnimation.delegate = self
        
        backAnimation1 = CABasicAnimation(keyPath: "transform.rotation.x")
        backAnimation1.fromValue = CGFloat.pi / 2.0 * 3.0
        backAnimation1.toValue = CGFloat.pi * 2.0
        backAnimation1.duration = duration / 2.0
        backAnimation1.isRemovedOnCompletion = false
        backAnimation1.fillMode = .forwards
        backAnimation1.delegate = self
        
        backAnimation2 = CABasicAnimation(keyPath: "transform.rotation.x")
        backAnimation2.fromValue = -CGFloat.pi
        backAnimation2.toValue = 0
        backAnimation2.duration = duration
        backAnimation2.isRemovedOnCompletion = false
        backAnimation2.fillMode = .forwards
        backAnimation2.delegate = self
    }
    
}

// MARK: - CAAnimationDelegate
extension TransactionCell: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {//swiftlint:disable:this cyclomatic_complexity
        //start animation
        if anim == firstImageView.layer.animation(forKey: "firstImageView") {
            firstImageView.alpha = 0
            secondImageView.alpha = 1
            secondImagebgView.alpha = 1
            firstViewBg.layer.masksToBounds = false
            secondImageView.layer.add(animation2, forKey: "secondImageView")
        }
        
        if anim == secondImageView.layer.animation(forKey: "secondImageView") {
            if itemsCount > 2 {
                secondImageView.alpha = 1
                if thirdImageView.count > 0 {
                    secondImagebgView.alpha = 0
                    thirdImageView[0].alpha = 1
                    thirdImageView[0].frame = CGRect(x: 0, y: topView.frame.height * 2 - secondImagebgView.frame.height, width: detailView.frame.width, height: secondImagebgView.frame.height)
                    thirdImageView[0].layer.add(animation3, forKey: "animation")
                } else if itemsCount == 3 {
                    secondImagebgView.layer.add(animation1, forKey: "secondImagebgView")
                }
            } else if itemsCount == 2 {
                detailView.alpha = 1
                animationViews.alpha = 0
            }
        }
        
        if !thirdImageView.isEmpty {
            if anim == thirdImageView[thirdViewNumber].layer.animation(forKey: "animation") {
                thirdViewBg[thirdViewNumber].alpha = 1
                thirdImageView[thirdViewNumber].frame = thirdViewBg[thirdViewNumber].frame
                if thirdViewNumber == thirdViewBg.count - 1 {
                    thirdImageView[thirdViewNumber].layer.add(animation1, forKey: "thirdImageView")
                } else {
                    thirdViewNumber += 1
                    thirdImageView[thirdViewNumber].layer.add(animation3, forKey: "animation")
                }
            }
            
            if anim == thirdImageView[thirdImageView.count - 1].layer.animation(forKey: "thirdImageView") {
                fourthImageView.alpha = 1
                thirdImageView[thirdImageView.count - 1].alpha = 0
                fourthImageView.layer.add(animation2, forKey: "fourthImageView")
            }
        }
        
        if anim == secondImagebgView.layer.animation(forKey: "secondImagebgView") {
            secondImagebgView.alpha = 0
            fourthImageView.alpha = 1
            fourthImageView.layer.add(animation2, forKey: "fourthImageView")
        }
        
        if anim == fourthImageView.layer.animation(forKey: "fourthImageView") {
            fourthImageView.alpha = 1
            detailView.alpha = 1
            animationViews.alpha = 0
        }
        
        //end animation
        if anim == fourthImageView.layer.animation(forKey: "backAnimation") {
            if itemsCount > 2 {
                fourthImageView.alpha = 0
                if thirdImageView.count > 0 {
                    thirdImageView[thirdViewNumber].frame = thirdViewBg[thirdViewNumber].frame
                    thirdImageView[thirdViewNumber].alpha = 1
                    thirdImageView[thirdViewNumber].layer.add(backAnimation1, forKey: "backAnimation1")
                } else if itemsCount == 3 {
                    secondImagebgView.alpha = 1
                    secondImagebgView.layer.add(backAnimation1, forKey: "backAnimation1")
                }
            } else if itemsCount == 2 {
                secondImageView.layer.add(backAnimation, forKey: "backAnimation")
            }
        }
        
        if !thirdImageView.isEmpty {
            if anim == thirdImageView[thirdViewNumber].layer.animation(forKey: "backAnimation1") {
                thirdViewBg[thirdViewNumber].alpha = 0
                if thirdViewNumber != 0 {
                    thirdViewNumber -= 1
                    thirdImageView[thirdViewNumber].frame = thirdViewBg[thirdViewNumber].frame
                    thirdImageView[thirdViewNumber].layer.add(backAnimation2, forKey: "backAnimation1")
                } else {
                    thirdImageView[thirdViewNumber].frame = CGRect(x: 0, y: topView.frame.height * 2 - secondImagebgView.frame.height, width: detailView.frame.width, height: secondImagebgView.frame.height)
                    thirdImageView[thirdViewNumber].layer.add(backAnimation2, forKey: "backAnimation2")
                }
            }
            
            if anim == thirdImageView[0].layer.animation(forKey: "backAnimation2") {
                thirdImageView[0].alpha = 0
                secondImagebgView.alpha = 1
                secondImageView.layer.add(backAnimation, forKey: "backAnimation")
            }
        }
        
        if anim == secondImagebgView.layer.animation(forKey: "backAnimation1") {
            secondImageView.layer.add(backAnimation, forKey: "backAnimation")
        }
        
        if anim == secondImageView.layer.animation(forKey: "backAnimation") {
            secondImageView.alpha = 0
            firstImageView.alpha = 1
            firstViewBg.layer.masksToBounds = true
            firstImageView.layer.add(backAnimation1, forKey: "backAnimation1")
        }
        
        if anim == firstImageView.layer.animation(forKey: "backAnimation1") {
            firstViewBg.alpha = 0
            hiddenView()
        }
    }
}
