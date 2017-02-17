//
//  CustomTextView.swift
//  wirk
//
//  Created by Edward on 2/16/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

class UICustomTextView: UITextView, UITextViewDelegate {
    
    open var placeholder: String? {
        didSet {
            // In this function we will set the placeholder to be the text and change the color to immitate a placeholder
            text = placeholder
            textColor = UIColor(white: 0.4, alpha: 0.4)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Check if the color matches the color of the placeholder
        let placeholderColor = UIColor(white: 0.4, alpha: 0.4)
        if textView.textColor == placeholderColor {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // Checks if the textfield is empty
        if textView.text == "" {
            let placeholderColor = UIColor(white: 0.4, alpha: 0.4)
            textView.textColor = placeholderColor
            textView.text = placeholder
        }
        textView.resignFirstResponder()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
