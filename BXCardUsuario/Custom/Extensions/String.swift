//
//  String.swift
//  BXCard
//
//  Created by Daive Simões on 11/01/19.
//  Copyright © 2019 Fourtime Informática Ltda. All rights reserved.
//

import Foundation

// MARK: - String
extension String {
 
    // MARK: - Case
    var camelized: String {
        guard !isEmpty else {
            return ""
        }
        
        let parts = self.components(separatedBy: CharacterSet.alphanumerics.inverted)
        
        let first = String(describing: parts.first!).lowercasingFirst
        let rest = parts.dropFirst().map({String($0).uppercasingFirst})
        
        return ([first] + rest).joined(separator: "")
    }
    
    var lowercasingFirst: String {
        return prefix(1).lowercased() + dropFirst()
    }
    
    var uppercasingFirst: String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    // MARK: - Utils
    func charAt(index: Int) -> String {
        if index < self.count {
            let index = self.index(self.startIndex, offsetBy: index)
            return String(self[index])
        }
        
        return ""
    }
    
    func onlyNumbers() -> String {
        return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }

    // MARK: - Validation
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: Constants.REGEX._EMAIL_VALIDATE_REGEX, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidPassword() -> Bool {
        let regex = try! NSRegularExpression(pattern: Constants.REGEX._PASSWORD_VALIDATE_REGEX, options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    // MARK: - Converters
    func toDate(withInFormat inFormat: String = Constants.MASKS._DEFAULT_DATE_TIME) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = inFormat
        return formatter.date(from: self)
    }
    
    func decodeToImage() -> UIImage? {
        if let decData = Data(base64Encoded: self, options: .ignoreUnknownCharacters), decData.count > 0, let image = UIImage(data: decData) {
            return image
        }
        
        return nil
    }

}


// MARK: - StringProtocol
extension StringProtocol {
    
    func paddingToLeft(upTo length: Int, using element: Element) -> String {
        return String(repeatElement(element, count: Swift.max(0, length - count))) + suffix(Swift.max(count, count - length))
    }
    
}
