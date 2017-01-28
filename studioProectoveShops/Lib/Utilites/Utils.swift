//
//  Utils.swift
//  studioProectoveShops
//
//  Created by Dmitriy Gaponenko on 09.09.16.
//  Copyright © 2016 Dmitriy Gaponenko. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

func base64StringFromImage(_ image: UIImage) -> String {
    var data: Data = Data()
    data = UIImageJPEGRepresentation(image, 0.1)!
    let base64String = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
    return base64String
}

func formatDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.medium
    let dateString = dateFormatter.string(from: date)
    return dateString
}

func router() -> RouterManager {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    return delegate.router!
}

func stringIsValidEmail(_ checkString: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: checkString)
}

func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return (isReachable && !needsConnection)
}


struct Converter {
    
    //Make Sring
    
    static func daySringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    static func sringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter.string(from: date)
    }
    
    static func prettySringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MMM dd"
        
        return dateFormatter.string(from: date)
    }
    
    static func fullHoursInDate(_ date: Date) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H"
        
        return Int(dateFormatter.string(from: date))
    }
    
    //Make date
    
    static func dateFromString(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: string)
    }
    
    static func dateFromDayString(_ string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string)
    }
    
    static func dateWithParams(_ hours: Int, minutes: Int, seconds: Int, byDay: Date) -> Date? {
        
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian);
        calendar.timeZone = (TimeZone.autoupdatingCurrent)
        
        let unitFlags: NSCalendar.Unit = [.day, .month, .year]
        
        var dateComponents = (calendar as NSCalendar?)?.components(unitFlags, from: Date());
        dateComponents?.hour = hours
        dateComponents?.minute = minutes
        dateComponents?.second = seconds
        
        //return date relative from date
        return calendar.date(from: dateComponents!)
    }
    
    static func convertToHeightUsingFeet(_ feet: Int, inches: Int) -> Int {
        return (feet * 12 + inches)
    }
    
    static func convertToFeetInchUseHeight(_ height: Int) -> (feet: Int, inches: Int) {
        if height > 0 {
            let feet = Int(height / 12)
            let inches = height % 12
            
            return (feet, inches)
        }
        return (0, 0)
    }
}
