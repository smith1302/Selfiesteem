//
//  RatePhotoViewController.swift
//  Selfiesteem
//
//  Created by Eric Smith on 11/3/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class RatePhotoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    let ratingRange:Int = 10
    var inputBox:UIRatingTextField?
    var photo:Photo!
    @IBOutlet weak var imageView: CachedPFImageView!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var numberPicker: UIPickerView!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        // Either loads it or uses the cached version
        imageView.file = photo.photoFile
        imageView.loadInBackground()
        // Configure rater
        numberPicker.delegate = self
        numberPicker.dataSource = self
        numberPicker.selectRow(0, inComponent: 0, animated: true)
        rateButton.layer.cornerRadius = 8
        rateButton.layer.borderColor = UIColor.whiteColor().CGColor
        rateButton.layer.borderWidth = 3
        rateButton.backgroundColor = UIColor(white: 0.1, alpha: 0.75)
        rateButton.titleLabel?.textColor = UIColor.whiteColor()
        // Configure next button
        let image = UIImage(named: "Next-64.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        nextButton.setImage(image, forState: UIControlState.Normal)
        nextButton.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hideNumberPicker()
        // Configure exit button
        exitButton.titleLabel?.textAlignment = .Left
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: Picker View Delegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ratingRange
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rateButton.setTitle(String(row), forState: .Normal)
        hideNumberPicker()
    }
    
    // Mark: Text field delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Mark: Interactions
    
    @IBAction func exitClicked(sender: AnyObject) {
        leaveView()
    }
    
    @IBAction func didTapImageView(sender: AnyObject) {
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInView(self.view)
            self.showInputAtLocation(location)
        }
    }

    @IBAction func nextButtonClicked(sender: AnyObject) {
        submitRating()
        leaveView()
    }
    
    @IBAction func rateButtonClicked(sender: AnyObject) {
        numberPicker.userInteractionEnabled = true
        numberPicker.hidden = false
    }
    
    // Mark: Other
    
    func setUpWithPhoto(photo:Photo!) {
        self.photo = photo
    }
    
    func hideNumberPicker() {
        numberPicker.hidden = true
        numberPicker.userInteractionEnabled = false
    }
    
    func showInputAtLocation(location:CGPoint) {
        let textSize:CGFloat = 17
        let padding:CGFloat = 25
        if inputBox == nil {
            inputBox = UIRatingTextField(textSize: textSize, leftTextMargin: 12)
            inputBox?.delegate = self
            self.view.addSubview(inputBox!)
        }
        let boxHeight = textSize+padding
        inputBox?.frame = CGRectMake(0, location.y - boxHeight/2, self.view.frame.size.width, boxHeight)
        inputBox?.becomeFirstResponder()
    }
    
    func submitRating() {
        Rating.submitRating(getRatingValue(), comment: getRatingComment(), forPhoto: photo)
    }
    
    func getRatingValue() -> Int {
        let rateButtonText = rateButton.titleLabel!.text!
        return Int(rateButtonText)!
    }
    
    func getRatingComment() -> String? {
        return inputBox?.text
    }
    
    func leaveView() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
