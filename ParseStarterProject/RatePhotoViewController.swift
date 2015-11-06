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

class RatePhotoViewController: UIViewController {
    
    var fileToLoad:PFFile!
    @IBOutlet weak var imageView: CachedPFImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var popOverSliderRating: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        // Either loads it or uses the cached version
        imageView.file = fileToLoad
        imageView.loadInBackground()
        // Configure slider
        slider.continuous = true
        slider.minimumValue = 1.0
        slider.maximumValue = 10.0
        slider.setValue(5, animated: true)
        slider.layer.cornerRadius = 8
        popOverSliderRating.hidden = true
        popOverSliderRating.layer.cornerRadius = 8
        popOverSliderRating.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpWithFile(file:PFFile!) {
        self.fileToLoad = file
    }
    
    @IBAction func didTapImageView(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func sliderValueChanged(sender: AnyObject) {
        let newStep = round(slider.value)
        slider.value = newStep
        print("\(slider.value)")
        updatePopOverSliderRatingForValue(newStep)
    }

    @IBAction func sliderDidTouchDown(sender: AnyObject) {
        popOverSliderRating.hidden = false
    }

    
    @IBAction func sliderDidEndEditing(sender: AnyObject) {
        popOverSliderRating.hidden = true
    }
    
    func updatePopOverSliderRatingForValue(newStep:Float) {
        let trackRect = slider.trackRectForBounds(slider.bounds)
        let thumbRect = slider.thumbRectForBounds(slider.bounds, trackRect: trackRect, value: newStep)
        popOverSliderRating.center = CGPointMake(thumbRect.origin.x+slider.frame.origin.x+popOverSliderRating.frame.size.width/2 - 5, popOverSliderRating.center.y)
        popOverSliderRating.text = String(Int(newStep))
    }
}
