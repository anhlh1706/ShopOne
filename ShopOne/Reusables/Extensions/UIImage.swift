/// Bym

import UIKit.UIImage

extension UIImage {
    
    convenience init(color: UIColor) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let cgImage = img?.cgImage!
        self.init(cgImage: cgImage!)
    }
    
    convenience init(barcode: String) {
        let data = barcode.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                self.init(ciImage: output)
                return
            }
        }
        self.init()
    }
    
    func scaled(toSize size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    func scaleToFit(size: CGSize) -> UIImage {
        let aspect = self.size.width / self.size.height
        if size.width / aspect <= size.height {
            return scaled(toSize: CGSize(width: size.width, height: size.width / aspect))
        } else {
            return scaled(toSize: CGSize(width: size.height * aspect, height: size.height))
        }
    }
    
}
