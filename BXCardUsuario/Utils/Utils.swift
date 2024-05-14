//
//  Utils.swift
//  VittaCard
//
//  Created by Daive Simões on 14/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation
import InputMask
import SafariServices

class Utils {
    
    static func createOverlay(frame: CGRect, xOffset: CGFloat, yOffset: CGFloat, radius: CGFloat) -> UIView {
        // Step 1
        let overlayView = UIView(frame: frame)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        // Step 2
        let path = CGMutablePath()
        path.addRect(CGRect(x: frame.midX - (radius / 2.0), y: frame.midY - (radius / 2.0), width: radius, height: radius))
        //        path.addArc(center: CGPoint(x: xOffset, y: yOffset), radius: radius, startAngle: 0.0, endAngle: 2.0 * .pi, clockwise: false)
        path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))
        
        // Step 3
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        
        // Step 4
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        
        return overlayView
    }
    
    static func formatCurrency(value: Double, _ symbol: String? = nil) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        if let symbol = symbol {
            formatter.currencySymbol = symbol
        }
        
        return formatter.string(from: NSNumber(value: value)) ?? "\(String(describing: formatter.currencySymbol))0,00"
    }
    
    static func formatDate(date: Date, withOutFormat outFormat: String = Constants.MASKS._DEFAULT_DATE_TIME) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = outFormat
        return formatter.string(from: date)
    }
    
    static func formatDate(string: String, withInFormat inFormat: String = Constants.MASKS._DEFAULT_DATE_TIME, andOutFormat outFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = inFormat
        if let date = formatter.date(from: string) {
            formatter.dateFormat = outFormat
            return formatter.string(from: date)
        }
        
        return ""
    }
    
    static func getDayName(fromDate date: Date?, withLocaleIdentifier localeId: String = "pt-BR") -> String {
        if let date = date {
            var calendar = Calendar(identifier: .gregorian)
            calendar.locale = Locale(identifier: localeId)
            let dayDate = calendar.component(.weekday, from: date)
            return calendar.weekdaySymbols[dayDate - 1]
        }
        
        return ""
    }
    
    static func getMonthName(fromDate date: Date?, withLocaleIdentifier localeId: String = "pt-BR") -> String {
        if let date = date {
            var calendar = Calendar(identifier: .gregorian)
            calendar.locale = Locale(identifier: localeId)
            let monthDate = calendar.component(.month, from: date)
            return calendar.monthSymbols[monthDate - 1]
        }
        
        return ""
    }
    
    static func getSafariController(withURL url: String) -> SFSafariViewController? {
        if let url = URL(string: url) {
            let safariVC = SFSafariViewController(url: url)
            return safariVC
        }
        
        return nil
    }
    
    static func mask(text: String?, withMask mask: String) -> String {
        if let text = text {
            let mask: Mask = try! Mask(format: mask)
            let result: Mask.Result = mask.apply(
                toText: CaretString(
                    string: text,
                    caretPosition: text.endIndex,
                    caretGravity: .forward(autocomplete: false)
                )
            )
            
            return result.formattedText.string
            
        } else {
            return ""
        }
    }
    
    static func makeCall(toPhoneNumber phoneNumber: String, withCompletion completion: ((Bool) -> ())?) {
        if let url = URL(string: "tel://\(phoneNumber.onlyNumbers())"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:]) { (ended) in
                    completion?(ended)
                }
            } else {
                UIApplication.shared.openURL(url)
                completion?(true)
            }
        }
    }
    
    static func openAppSettings(withCompletion completion: ((Bool) -> ())?) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
        }
    }
    
    static func openURLOnSafari(forController vc: UIViewController, withUrl url: String) {
        if let safariVC = Utils.getSafariController(withURL: url) {
            safariVC.delegate = vc as? SFSafariViewControllerDelegate
            vc.present(safariVC, animated: true, completion: nil)
        }
    }
    
}
