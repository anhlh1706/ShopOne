/// Bym

import UIKit

class StorageSectionHeaderView: UICollectionReusableView {

    let title = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let separator = UIView(frame: .zero)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .quaternaryLabel

        title.textColor = .label
        title.font = UIFontMetrics.default.scaledFont(for: UIFont.systemFont(ofSize: 22, weight: .bold))

        let stackView = UIStackView(arrangedSubviews: [separator, title])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        addSubview(stackView)

        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])

        stackView.setCustomSpacing(10, after: separator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Stop trying to make storyboards happen.")
    }
}
