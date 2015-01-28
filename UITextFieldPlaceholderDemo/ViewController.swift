//
//  ViewController.swift
//  UITextFieldPlaceholderDemo
//
//  Created by Christina Moulton on 2015-01-27.
//  Copyright (c) 2015 Teak Mobile Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

  var nameTextView: UITextView?
  let PLACEHOLDER_TEXT = "enter your name"
  
  // MARK: view lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // for comparison, let's add a UITextField with a placeholder
    let nameTextfield: UITextField? = UITextField(frame: CGRect(x: 20, y: 20, width: self.view.frame.size.width - 40, height: 40))
    nameTextfield?.placeholder = PLACEHOLDER_TEXT
    self.view.addSubview(nameTextfield!)
    
    // create the textView
    nameTextView = UITextView(frame: CGRect(x: 20, y: 80, width: self.view.frame.size.width - 40, height: 40))
    self.view.addSubview(nameTextView!)
    
    applyPlaceholderStyle(nameTextView!, placeholderText: PLACEHOLDER_TEXT)
    
    // set this class as the delegate so we can handle events from the textView
    nameTextView?.delegate = self
  }
  
  // MARK: helper functions
  
  func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String)
  {
    // make it look (initially) like a placeholder
    aTextview.textColor = UIColor.lightGrayColor()
    aTextview.text = placeholderText
  }
  
  func applyNonPlaceholderStyle(aTextview: UITextView)
  {
    // make it look like normal text instead of a placeholder
    aTextview.textColor = UIColor.darkTextColor()
    aTextview.alpha = 1.0
  }
  
  func moveCursorToStart(aTextView: UITextView)
  {
    dispatch_async(dispatch_get_main_queue(), {
      aTextView.selectedRange = NSMakeRange(0, 0);
    })
  }

  // MARK: UITextViewDelegate

  func textViewShouldBeginEditing(aTextView: UITextView) -> Bool
  {
    if aTextView == nameTextView && aTextView.text == PLACEHOLDER_TEXT
    {
      // move cursor to start
      moveCursorToStart(aTextView)
    }
    return true
  }
  
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    
    // remove the placeholder text when they start typing
    // first, see if the field is empty
    // if it's not empty, then the text should be black and not italic
    // BUT, we also need to remove the placeholder text if that's the only text
    // if it is empty, then the text should be the placeholder
    let newLength = textView.text.utf16Count + text.utf16Count - range.length
    if newLength > 0 // have text, so don't show the placeholder
    {
      // check if the only text is the placeholder and remove it if needed
      // unless they've hit the delete button with the placeholder displayed
      if textView == nameTextView && textView.text == PLACEHOLDER_TEXT
      {
        if text.utf16Count == 0 // they hit the back button
        {
          return false // ignore it
        }
        applyNonPlaceholderStyle(textView)
        textView.text = ""
      }
      return true
    }
    else  // no text, so show the placeholder
    {
      applyPlaceholderStyle(textView, placeholderText: PLACEHOLDER_TEXT)
      moveCursorToStart(textView)
      return false
    }
  }

}

