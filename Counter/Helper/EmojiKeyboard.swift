//
//  TextView.swift
//  Counter
//
//  Created by Nick Nguyen on 2/5/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation
import UIKit

class EmojiKeyboard: UITextView {
  
  // required for iOS 13
  override var textInputContextIdentifier: String? { "" } // return non-nil to show the Emoji keyboard ¯\_(ツ)_/¯
  
  override var textInputMode: UITextInputMode? {
    for mode in UITextInputMode.activeInputModes {
      if mode.primaryLanguage == "emoji" {
        return mode
      }
    }
    return nil
  }
}
