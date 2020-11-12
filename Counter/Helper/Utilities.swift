//
//  Helper.swift
//  Counter
//
//  Created by Nick Nguyen on 2/3/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation
import UIKit

struct Utilities {

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

        let twitterUrl = URL(string: "twitter://user?screen_name=NickNguyen_14")!
        let twitterUrlWeb = URL(string: "https://www.twitter.com/NickNguyen_14")!
        if UIApplication.shared.canOpenURL(twitterUrl) {
            UIApplication.shared.open(twitterUrl, options: [:],completionHandler: nil)
        } else {
            UIApplication.shared.open(twitterUrlWeb, options: [:], completionHandler: nil)
        }
    }
}
