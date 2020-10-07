/// Bym

import UIKit
import SkyFloatingLabelTextField

@IBDesignable
final class AHTextField: SkyFloatingLabelTextField {
    
    init(primaryText: String = "") {
        super.init(frame: .zero)
        lineHeight = 1
        selectedLineHeight = 1
        selectedTitleColor = .newRed
        
        textColor = .text
        selectedLineColor = .text
        placeholder = primaryText
        selectedTitle = primaryText
        placeholderColor = .subText
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
