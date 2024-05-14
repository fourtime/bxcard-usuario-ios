//
//  Color.swift
//  BXCard
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import UIKit

extension UIColor {

    @nonobjc class var titleBarBackgroundColor: UIColor {
        return UIColor(red: 23.0 / 255.0, green: 71.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0)
    }
    
    // MARK: - Degrade Colors
    @nonobjc class var enabledDegradeDarkColor: UIColor {
        return UIColor(red: 23.0 / 255.0, green: 71.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var enabledDegradeLightColor: UIColor {
        return UIColor(red: 23.0 / 255.0, green: 71.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var disabledDegradeDarkColor: UIColor {
        return UIColor(red: 158.0 / 255.0, green: 158.0 / 255.0, blue: 158.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var disabledDegradeLightColor: UIColor {
        return UIColor(red: 158.0 / 255.0, green: 158.0 / 255.0, blue: 158.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var attentionDegradeDarkColor: UIColor {
        return UIColor(red: 213.0 / 255.0, green: 74.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var attentionDegradeLightColor: UIColor {
        return UIColor(red: 213.0 / 255.0, green: 74.0 / 255.0, blue: 71.0 / 255.0, alpha: 1.0)
    }
    
    
    // MARK: - Font Colors
    @nonobjc class var primaryFontColor: UIColor {
        return UIColor(red: 69.0 / 255.0, green: 72.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var primaryLightFontColor: UIColor {
        return UIColor(red: 117.0 / 255.0, green: 117.0 / 255.0, blue: 117.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var primaryDarkFontColor: UIColor {
        return UIColor(red: 33.0 / 255.0, green: 33.0 / 255.0, blue: 33.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var secondaryFontColor: UIColor {
        return UIColor(red: 94.0 / 255.0, green: 98.0 / 255.0, blue: 101.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var lightButtonFontColor: UIColor {
        return UIColor(red: 117.0 / 255.0, green: 117.0 / 255.0, blue: 117.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var highlightFontColor: UIColor {
        return UIColor(red: 94.0 / 255.0, green: 98.0 / 255.0, blue: 101.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var darkHighlightColor: UIColor {
        return UIColor(red: 1.0 / 255.0, green: 47.0 / 255.0, blue: 97.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var degradeTitleFontColor: UIColor {
        return UIColor.white
    }

    
    // MARK: - Border Colors
    @nonobjc class var defaultBorderColor: UIColor {
        return UIColor(red: 238.0 / 255.0, green: 238.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var separatorColor: UIColor {
        return UIColor(red: 245.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var separatorDarkColor: UIColor {
        return UIColor(red: 216.0 / 255.0, green: 216.0 / 255.0, blue: 216.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var closeButtonBorderColor: UIColor {
        return UIColor(red: 123.0 / 255.0, green: 171.0 / 255.0, blue: 57.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var lightBorderColor: UIColor {
        return UIColor(red: 123.0 / 255.0, green: 171.0 / 255.0, blue: 57.0 / 255.0, alpha: 0.2)
    }
    
    
    // MARK: - Button Colors
    @nonobjc class var cancelTransactionButtonColor: UIColor {
        return UIColor(red: 239.0 / 255.0, green: 83.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0)
    }
    
    
    // MARK: - Placeholders Colors
    @nonobjc class var primaryPlaceHolderColor: UIColor {
        return UIColor(red: 158.0 / 255.0, green: 158.0 / 255.0, blue: 158.0 / 255.0, alpha: 1.0)
    }
    
    
    // MARK: - Windows Colors
    @nonobjc class var windowBackground: UIColor {
        return UIColor(red: 250.0 / 255.0, green: 250.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var cardBackground: UIColor {
        return UIColor.white
    }
    
    @nonobjc class var highlightBackground: UIColor {
        return UIColor(red: 239.0 / 255.0, green: 243.0 / 255.0, blue: 234.0 / 255.0, alpha: 0.2)
    }
    
    @nonobjc class var extraLightHighlightBackground: UIColor {
        return UIColor(red: 123.0 / 255.0, green: 171.0 / 255.0, blue: 57.0 / 255.0, alpha: 0.03)
    }
    
    @nonobjc class var slideUpAlertBackground: UIColor {
        return UIColor.white
    }
    
    @nonobjc class var fieldBackgroundColor: UIColor {
        return UIColor.clear
    }
    
    @nonobjc class var pickerBackground: UIColor {
        return UIColor.white
    }
    
    @nonobjc class var defaultTableViewBackground: UIColor {
        return UIColor.clear
    }
    
    @nonobjc class var defaultTableViewCellBackground: UIColor {
        return UIColor.white
    }
    
    @nonobjc class var alertTransparentBackground: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.4)
    }
    
    @nonobjc class var photoBackground: UIColor {
        return UIColor(red: 224.0 / 255.0, green: 224.0 / 255.0, blue: 224.0 / 255.0, alpha: 1.0)
    }
    
    
    // MARK: - Errors
    @nonobjc class var errorBorderColor: UIColor {
        return UIColor(red: 229.0 / 255.0, green: 115.0 / 255.0, blue: 115.0 / 255.0, alpha: 0.5)
    }
    
    @nonobjc class var defaultErrorColor: UIColor {
        return UIColor(red: 239.0 / 255.0, green: 83.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var defaultErrorMessageColor: UIColor {
        return UIColor.white
    }
    
    
    // MARK: - PageControl
    @nonobjc class var defaultPageControlBackgroundColor: UIColor {
        return UIColor.clear
    }
    
    @nonobjc class var defaultPageControlTintColor: UIColor {
        return UIColor(red: 224.0 / 255.0, green: 224.0 / 255.0, blue: 224.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var defaultPageControlCurrentPageColor: UIColor {
        return UIColor(red: 189.0 / 255.0, green: 189.0 / 255.0, blue: 189.0 / 255.0, alpha: 1.0)
    }
    
}

extension UIColor {
    /// Creates an instance of UIColor based on an RGB value.
    ///
    /// - parameter rgbValue: The Integer representation of the RGB value: Example: 0xFF0000.
    /// - parameter alpha:    The desired alpha for the color.
    public convenience init?(rgbValue: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    public convenience init(hexValue: String) {
        self.init(hex: hexValue, alpha: 1.0)
    }
    
    public convenience init(hexValue: Int, alpha: Float = 1.0) {
        self.init(hex: "\(hexValue)", alpha: alpha)
    }
    
    public convenience init(hex: String, alpha: Float = 1.0) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var mAlpha: CGFloat = CGFloat(alpha)
        var minusLength = 0
        
        let scanner = Scanner(string: hex)
        
        if hex.hasPrefix("#") {
            scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
            minusLength = 1
        }
        if hex.hasPrefix("0x") {
            scanner.charactersToBeSkipped = CharacterSet(charactersIn: "0x")
            minusLength = 2
        }
        var hexValue: UInt64 = 0
        scanner.scanHexInt64(&hexValue)
        switch hex.count - minusLength {
        case 3:
            red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
            green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
            blue = CGFloat(hexValue & 0x00F) / 15.0
        case 4:
            red = CGFloat((hexValue & 0xF000) >> 12) / 15.0
            green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
            blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
            mAlpha = CGFloat(hexValue & 0x000F) / 15.0
        case 6:
            red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(hexValue & 0x0000FF) / 255.0
        case 8:
            red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
            green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
            mAlpha = CGFloat(hexValue & 0x000000FF) / 255.0
        default:
            break
        }
        self.init(red: red, green: green, blue: blue, alpha: mAlpha)
    }
    
    func hexValue() -> String {
       let components = self.cgColor.components
       let r: CGFloat = components?[0] ?? 0.0
       let g: CGFloat = components?[1] ?? 0.0
       let b: CGFloat = components?[2] ?? 0.0

       let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
       return hexString
    }
    
    /// Creates an UIImage from a color instance. This is useful for button backgrounds.
    ///
    /// - parameter width:  The desired width for the image.
    /// - parameter height: The desired height for the image.
    ///
    /// - returns: A UIImage containing only the instance color.
    func toImage(width: CGFloat = 2, height: CGFloat = 2) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)

        defer { UIGraphicsEndImageContext() }

        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(self.cgColor)
            context.fill(rect)
        }

        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }

}
