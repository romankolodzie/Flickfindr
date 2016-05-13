//
//  SearchViewController.swift
//  Flickfindr
//
//  Created by Roman Kolodzie on 5/5/16.
//  Copyright © 2016 Roman Kolodzie. All rights reserved.
//



// TODO
//        finish app
//        gradient the search bar
//
//        *optional*
//        bezier animation


import UIKit

class SearchViewController: UIViewController {
    
    
            // PROPERTIES
    
    var keyboardOnScreen = false
    
    @IBOutlet weak var flickfindrLabel: UILabel!
    @IBOutlet weak var photoTitleLabel: UILabel!
    
    private var searchButton = UIButton(type: UIButtonType.Custom) as UIButton
    private var cancelButton = UIButton(type: UIButtonType.Custom) as UIButton
    let searchButtonImage = UIImage(named: "Search") as UIImage?
    let cancelButtonImage = UIImage(named: "Cancel") as UIImage?
    
    private var searchField = UITextField()
    private var latitudeTextField = UITextField()
    private var longitudeTextField = UITextField()
    private let searchBarShapeLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    
    var CGPointSearchBarInitial: CGPoint!
    var CGPointSearchBarFinal: CGPoint!
    var CGPointButtonRight: CGPoint!
    var CGPointButtonLeft: CGPoint!
    
    private let minHeight: CGFloat = 73.0
    var searchByPhraseBool = true
    var searchBarOut = false
    
    let blue = UIColor(red: 63/255.0, green: 169/255.0, blue: 245/255.0, alpha: 1.0)
    let lightBlue = UIColor(red: 118/255.0, green: 214/255.0, blue: 255.0, alpha: 1.0)
    let transWhite = UIColor(red: 255, green: 255, blue: 255, alpha: 0.7)
    
    
            // LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        flickfindrLabel.hidden = false
        
        searchField.delegate = self
        
//        subscribeToNotification(UIKeyboardWillShowNotification, selector: Constants.Selectors.KeyboardWillShow)
//        subscribeToNotification(UIKeyboardWillHideNotification, selector: Constants.Selectors.KeyboardWillHide)
//        subscribeToNotification(UIKeyboardDidShowNotification, selector: Constants.Selectors.KeyboardDidShow)
//        subscribeToNotification(UIKeyboardDidHideNotification, selector: Constants.Selectors.KeyboardDidHide)
        
        setup()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
            // SEARCHBAR FUNCTIONS
    
    func setup() {
        
        CGPointSearchBarInitial = CGPointMake(view.bounds.width-80.0, 0)
        CGPointSearchBarFinal = CGPointMake(0.0, 0.0)
        CGPointButtonRight = CGPointMake(view.bounds.width-60.0, 26.0)
        CGPointButtonLeft = CGPointMake(20.0, 26.0)
        
        //Search Bar shape layer
        searchBarShapeLayer.frame = CGRectMake(CGPointSearchBarInitial.x, 0.0, view.bounds.width, minHeight)
        searchBarShapeLayer.backgroundColor = UIColor.clearColor().CGColor
        
        //Gradient for Searchbar
        gradientLayer.frame = searchBarShapeLayer.frame
        gradientLayer.colors = [blue.CGColor, lightBlue.CGColor]
        gradientLayer.startPoint = CGPointMake(0.5, 0.5)
        gradientLayer.endPoint = CGPointMake(0.0, 0.5)
        searchBarShapeLayer.addSublayer(gradientLayer)
        view.layer.addSublayer(gradientLayer)
        
        //Search Button
        searchButton.frame = CGRectMake(CGPointButtonRight.x, CGPointButtonRight.y, 40.0, 40.0)
        searchButton.setImage(searchButtonImage, forState: .Normal)
        searchButton.addTarget(self, action: #selector(SearchViewController.searchButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(searchButton)
        
        // Cancel Button
        cancelButton.frame = CGRectMake(CGPointButtonRight.x + view.bounds.width, CGPointButtonRight.y, 40.0, 40.0)
        cancelButton.setImage(cancelButtonImage, forState: .Normal)
        cancelButton.addTarget(self, action: #selector(SearchViewController.cancelButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(cancelButton)
        
        // Search Text Field
        searchField.enabled = false
        searchField.hidden = true
        searchField.frame = CGRect(x: 80, y: 34, width: view.bounds.width - 160.0, height: 26)
        searchField.attributedPlaceholder = NSAttributedString(string: "Search FLICKFINDR..", attributes: [NSForegroundColorAttributeName : transWhite])
        stylizeTextField(searchField)
        
        // Lat Text Field
        latitudeTextField.enabled = false
        latitudeTextField.hidden = true
        latitudeTextField.frame = CGRect(x: 70, y: 34, width: 130, height: 26)
        latitudeTextField.attributedPlaceholder = NSAttributedString(string: "Latitude..", attributes: [NSForegroundColorAttributeName : transWhite])
        stylizeTextField(latitudeTextField)
        
        // Lon Text Field
        longitudeTextField.enabled = false
        longitudeTextField.hidden = true
        longitudeTextField.frame = CGRect(x: 210, y: 34, width: 130, height: 26)
        longitudeTextField.attributedPlaceholder = NSAttributedString(string: "Longitude..", attributes: [NSForegroundColorAttributeName : transWhite])
        stylizeTextField(longitudeTextField)
    }
    
    
    func stylizeTextField(textField: UITextField){
        let border = CALayer()
        border.borderColor = (UIColor.whiteColor()).CGColor
        border.frame = CGRectMake(0, textField.frame.size.height - 2, textField.frame.size.width, textField.frame.size.height);
        border.borderWidth = 2;
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        textField.textColor = UIColor.whiteColor()
        textField.textAlignment = .Center
        self.view.addSubview(textField)
    }
    
    
    @IBAction func segmentSelector(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex{
        case 0:
            searchByPhraseBool = true
            if searchBarOut{
                longitudeTextField.hidden = true
                latitudeTextField.hidden = true
                searchField.hidden = false
                longitudeTextField.enabled = false
                latitudeTextField.enabled = false
                searchField.enabled = true
            }
        case 1:
            searchByPhraseBool = false
            if searchBarOut{
                longitudeTextField.hidden = false
                latitudeTextField.hidden = false
                searchField.hidden = true
                longitudeTextField.enabled = true
                latitudeTextField.enabled = true
                searchField.enabled = false
            }
        default:
            break
        }
    }
    
    
    func searchButtonPressed(sender: AnyObject) {
        flickfindrLabel.hidden = true
        searchButton.enabled = false
        searchBarOut = true
        
        if searchByPhraseBool{
            searchField.hidden = false
            searchField.enabled = true
        } else {
            latitudeTextField.hidden = false
            longitudeTextField.hidden = false
            latitudeTextField.enabled = true
            longitudeTextField.enabled = true
        }
        
        // Button animations
        
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: [], animations: {
                self.searchButton.frame = CGRectMake(self.CGPointButtonLeft.x, self.CGPointButtonLeft.y, 40.0, 40.0)
                // How can I make the Search button rotate while moving, but end up in the same orientation?
                self.cancelButton.frame = CGRectMake(self.CGPointButtonRight.x, self.CGPointButtonRight.y, 40.0, 40.0)
                self.searchBarShapeLayer.frame = CGRectMake(self.CGPointSearchBarFinal.x, self.CGPointSearchBarFinal.y, self.view.bounds.width, self.minHeight)
                self.gradientLayer.frame = CGRectMake(self.CGPointSearchBarFinal.x, self.CGPointSearchBarFinal.y, self.view.bounds.width, self.minHeight)
            }, completion: nil)
    }
    
    
    func cancelButtonPressed(sender:AnyObject) {
        searchField.hidden = true
        latitudeTextField.hidden = true
        longitudeTextField.hidden = true
        searchField.enabled = false
        latitudeTextField.enabled = false
        longitudeTextField.enabled = false
        searchButton.enabled = true
        searchBarOut = false
        
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: [], animations: {
            self.searchButton.frame = CGRectMake(self.CGPointButtonRight.x, self.CGPointButtonRight.y, 40.0, 40.0)
            self.cancelButton.frame = CGRectMake(self.CGPointButtonRight.x + self.view.bounds.width, self.CGPointButtonRight.y, 40.0, 40.0)
            self.searchBarShapeLayer.frame = CGRectMake(self.CGPointSearchBarInitial.x, self.CGPointSearchBarInitial.y, self.view.bounds.width, self.minHeight)
            self.gradientLayer.frame = CGRectMake(self.CGPointSearchBarInitial.x, self.CGPointSearchBarInitial.y, self.view.bounds.width, self.minHeight)
        }, completion: nil)
        

        searchField.text = ""
        latitudeTextField.text = ""
        longitudeTextField.text = ""
        flickfindrLabel.hidden = false
    }
    
    
            // OTHER FUNCTIONS
    
    func searchByPhrase(phraseToSearch: String){
        
    }
    
    
    func searchByLatLon(Lat: String, Lon: String){
        
    }
    
    // MARK: Flickr API
    
    private func displayImageFromFlickrBySearch(methodParameters: [String:AnyObject]) {
        
        print(flickrURLFromParameters(methodParameters))
        
        // TODO: Make request to Flickr!
    }

    // MARK: Helper for Creating a URL from Parameters
    
    private func flickrURLFromParameters(parameters: [String:AnyObject]) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.Flickr.APIScheme
        components.host = Constants.Flickr.APIHost
        components.path = Constants.Flickr.APIPath
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
}


extension SearchViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        if searchByPhraseBool{
//            searchByPhrase(textField.text!)
//        } else {
//            searchByLatLon(<#T##Lat: String##String#>, Lon: <#T##String#>)
//        }
        return true
    }
    
    // MARK: Show/Hide Keyboard
//    func keyboardWillShow(notification: NSNotification) {
//        if !keyboardOnScreen {
//            view.frame.origin.y -= keyboardHeight(notification)
//        }
//    }
//    
//    func keyboardWillHide(notification: NSNotification) {
//        if keyboardOnScreen {
//            view.frame.origin.y += keyboardHeight(notification)
//        }
//    }
//    
//    func keyboardDidShow(notification: NSNotification) {
//        keyboardOnScreen = true
//    }
//    
//    func keyboardDidHide(notification: NSNotification) {
//        keyboardOnScreen = false
//    }
//    
//    private func keyboardHeight(notification: NSNotification) -> CGFloat {
//        let userInfo = notification.userInfo
//        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
//        return keyboardSize.CGRectValue().height
//    }
    
    private func resignIfFirstResponder(textField: UITextField) {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
    }
    
//    @IBAction func userDidTapView(sender: AnyObject) {
//        resignIfFirstResponder(phraseTextField)
//        resignIfFirstResponder(latitudeTextField)
//        resignIfFirstResponder(longitudeTextField)
//    }
//    
    
    
        // MARK: TextField Validation
    
    private func isTextFieldValid(textField: UITextField, forRange: (Double, Double)) -> Bool {
        if let value = Double(textField.text!) where !textField.text!.isEmpty {
            return isValueInRange(value, min: forRange.0, max: forRange.1)
        } else {
            return false
        }
    }
    
    private func isValueInRange(value: Double, min: Double, max: Double) -> Bool {
        return !(value < min || value > max)
    }
}

extension SearchViewController {
    
    private func subscribeToNotification(notification: String, selector: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    private func unsubscribeFromAllNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
