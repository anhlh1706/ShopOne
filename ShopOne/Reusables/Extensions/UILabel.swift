/// Bym

import UIKit.UILabel

extension Label {
    convenience init(text: String = "", fontSize: CGFloat = 17, color: UIColor = .text, textAlignment: NSTextAlignment = .left) {
        self.init()
        self.text = text
        font = .systemFont(ofSize: fontSize)
        textColor = color
        self.textAlignment = textAlignment
    }
}
