//
//  Helper.swift
//  Counter
//
//  Created by Nick Nguyen on 2/3/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    static let eventCellId = "EventCell123"
    static let addButtonSegue = "AddEventSegue"
    static let clickCellSegue = "ClickCellSegue"
    static let clickSettingSegue = "ClickSettingSegue"
    static let swipeLeftSegue = "SwipeLeftSegue"
    
    
   static func createDateFormatter(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = .current
        return formatter
    }
    
    // MARK: - Open Twitter
    static func openTwitter() {

        let twitterUrl = URL(string: "twitter://user?screen_name=tonic4000")!
           let twitterUrlWeb = URL(string: "https://www.twitter.com/tonic4000")!
           if UIApplication.shared.canOpenURL(twitterUrl) {
              UIApplication.shared.open(twitterUrl, options: [:],completionHandler: nil)
           } else {
              UIApplication.shared.open(twitterUrlWeb, options: [:], completionHandler: nil)
           }
    }
    
    
}
