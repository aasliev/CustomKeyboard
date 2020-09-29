//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Asliddin Asliev on 9/28/20.
//  Copyright © 2020 Asliddin Asliev. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    
    var width: CGFloat = 375
    var height: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let numberRow = ["1", "2", "3", "4" , "5", "6", "7", "8", "9", "0"]
        let row1 = ["Q", "W", "E", "R" , "T", "Y", "U", "I", "O", "P"]
        let row2 = ["A", "S", "D", "F" , "G", "H", "J", "K", "L"]
        let row3 = ["SHIFT","Z", "X", "C", "V" , "B", "N", "M", "BS"]
        let row4 = ["123", "GLB", "SPACE", "RETURN"]
        
        let numberRowView = createRowOfButtons(buttonTitles: numberRow)
        let row1View = createRowOfButtons(buttonTitles: row1)
        let row2View = createRowOfButtons(buttonTitles: row2)
        let row3View = createRowOfButtons(buttonTitles: row3)
        let row4View = createRowOfButtons(buttonTitles: row4)
        
        
        self.view.addSubview(numberRowView)
        self.view.addSubview(row1View)
        self.view.addSubview(row2View)
        self.view.addSubview(row3View)
        self.view.addSubview(row4View)

        numberRowView.translatesAutoresizingMaskIntoConstraints = false
        row1View.translatesAutoresizingMaskIntoConstraints = false
        row2View.translatesAutoresizingMaskIntoConstraints = false
        row3View.translatesAutoresizingMaskIntoConstraints = false
        row4View.translatesAutoresizingMaskIntoConstraints = false

        addRowViewConstraint(inputView: self.view, rowViews: [numberRowView, row1View, row2View, row3View, row4View])
        self.view.autoresizingMask = []
    }
    
    
    
    func createRowOfButtons(buttonTitles: [String]) -> UIView {
        var buttons = [UIButton]()
        // self.view.frame.width
        //let keyboardRowView = UIView(frame: CGRect(x: 0, y: 0, width: , height: 50))
        let keyboardRowView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        for buttonTitle in buttonTitles{
            let button = createButtonWithTitle(title: buttonTitle)
            buttons.append(button)
            
            keyboardRowView.addSubview(button)
        }
        
        addButtonConstraints(buttons: buttons, mainView: keyboardRowView)
        return keyboardRowView
        
    }
    
    func createButtonWithTitle(title: String) -> UIButton{
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.sizeToFit()
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        button.setTitleColor(UIColor.darkGray, for: .normal)


        if (title == "SHIFT"){
//        button.setTitle(title, for: .normal)
//            button.image(for: .normal)
            button.setImage(UIImage(systemName: "shift"), for: .normal)
        } else {
            button.setTitle(title, for: .normal)

        }
        button.setTitleColor(UIColor.darkGray, for: .normal)

        //add target
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
        
    }
    
    @objc func didTapButton(sender: AnyObject?){
        let button = sender as! UIButton
        let proxy = textDocumentProxy
        
        let title = button.title(for: .normal)
        //print(title)
        proxy.insertText(title!)
    }
    
    // add constraints
    
    func addButtonConstraints(buttons: [UIButton], mainView: UIView){
        
        for (index,button) in buttons.enumerated(){
            let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1.0, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            // for the left and right constraint we have to first find out if the button is the last one or the first one
            let leftConstraint : NSLayoutConstraint!
            let rightConstraint : NSLayoutConstraint!
            
            // if the button is the last button
            if index == buttons.count - 1{
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: mainView, attribute: .right, multiplier: 1.0, constant: 0)
            } else {
                let nextButton = buttons[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: nextButton, attribute: .left, multiplier: 1.0, constant: 0)
            }
            
            // if it is the first button
            
            if index == 0 {
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: mainView, attribute: .left, multiplier: 1.0, constant: 0)
            } else {
                // calculate pre button
                let prevButton = buttons[index - 1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: prevButton, attribute: .right, multiplier: 1.0, constant: 0)
                
                let firstButton = buttons[0]
                
                let widthConstraint = NSLayoutConstraint(item: firstButton, attribute: .width, relatedBy: .equal, toItem: button, attribute: .width, multiplier: 1.0, constant: 0)
                
                widthConstraint.priority = UILayoutPriority(rawValue: 800)
                mainView.addConstraint(widthConstraint)
                
            }
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
            
        }
    }
    
    func addRowViewConstraint(inputView: UIView, rowViews: [UIView]){
        
        for (index, rowView) in rowViews.enumerated(){
            let rightConstraint = NSLayoutConstraint(item: rowView, attribute: .right, relatedBy: .equal, toItem: inputView, attribute: .right, multiplier: 1.0, constant: 0)
            
            let leftConstraint = NSLayoutConstraint(item: rowView, attribute: .left, relatedBy: .equal, toItem: inputView, attribute: .left, multiplier: 1.0, constant: 0)
            
            let topConstraint: NSLayoutConstraint
            let bottomConstraint: NSLayoutConstraint
            
            if index == 0 {
                topConstraint = NSLayoutConstraint(item: rowView, attribute: .top, relatedBy: .equal, toItem: inputView, attribute: .top, multiplier: 1.0, constant: 0)
            } else {
                let prevRow = rowViews[index - 1]
                topConstraint = NSLayoutConstraint(item: rowView, attribute: .top, relatedBy: .equal, toItem: prevRow, attribute: .bottom, multiplier: 1.0, constant: 0)
                
                let firstRow = rowViews[0]
                let heightConstraint = NSLayoutConstraint(item: firstRow, attribute: .height, relatedBy: .equal, toItem: rowView, attribute: .height, multiplier: 1.0, constant: 0)
                heightConstraint.priority = UILayoutPriority(rawValue: 800)
                inputView.addConstraint(heightConstraint)
            }
            
            if index == rowViews.count - 1 {
                bottomConstraint = NSLayoutConstraint(item: rowView, attribute: .bottom, relatedBy: .equal, toItem: inputView, attribute: .bottom, multiplier: 1.0, constant: 0)
            } else {
                let nextRow = rowViews[index + 1]
                bottomConstraint = NSLayoutConstraint(item: rowView, attribute: .bottom, relatedBy: .equal, toItem: nextRow, attribute: .top, multiplier: 1.0, constant: 0)
            }
            inputView.addConstraints([rightConstraint, leftConstraint, topConstraint, bottomConstraint])
            
        }
        
    }
    

    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
    }

}
