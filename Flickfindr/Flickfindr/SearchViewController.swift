//
//  SearchViewController.swift
//  Flickfindr
//
//  Created by Roman Kolodzie on 5/5/16.
//  Copyright © 2016 Roman Kolodzie. All rights reserved.
//



// TODO
//        finish app
//
//        *optional*
//        bezier animation


import UIKit

class SearchViewController: UIViewController {
    
    
            // PROPERTIES
    
    var keyboardOnScreen = false
    
    @IBOutlet weak var flickfindrLabel: UILabel!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
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
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
        
        searchField.returnKeyType = UIReturnKeyType.Search
        latitudeTextField.returnKeyType = UIReturnKeyType.Next
        longitudeTextField.returnKeyType = UIReturnKeyType.Search
        
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
    
    
    // UI Setup
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
    
    
    // Logic for segment control to search by phrase or search by Lat/Lon
    @IBAction func segmentSelector(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex{
        case 0:
            searchByPhraseBool = true
            if searchBarOut{
                longitudeTextField.hidden = true
                latitudeTextField.hidden = true
                longitudeTextField.enabled = false
                latitudeTextField.enabled = false
                searchField.hidden = false
                searchField.enabled = true
                searchField.becomeFirstResponder()
            }
        case 1:
            searchByPhraseBool = false
            if searchBarOut{
                searchField.enabled = false
                searchField.hidden = true
                longitudeTextField.hidden = false
                latitudeTextField.hidden = false
                longitudeTextField.enabled = true
                latitudeTextField.enabled = true
                latitudeTextField.becomeFirstResponder()
            }
        default:
            break
        }
    }
    
    
    func searchButtonPressed(sender: AnyObject) {
        flickfindrLabel.hidden = true
        searchButton.enabled = false
        searchBarOut = true
        cancelButton.enabled = true
        
        if searchByPhraseBool{
            searchField.hidden = false
            searchField.enabled = true
            searchField.becomeFirstResponder()
        } else {
            latitudeTextField.hidden = false
            longitudeTextField.hidden = false
            latitudeTextField.enabled = true
            longitudeTextField.enabled = true
            latitudeTextField.becomeFirstResponder()
        }
        
        // Button animations
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: [], animations: {
                self.searchButton.frame = CGRectMake(self.CGPointButtonLeft.x, self.CGPointButtonLeft.y, 40.0, 40.0)
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
    
    
    func searchByPhrase(){
        print("\(searchField.text)")
        
        if !searchField.text!.isEmpty {
            photoTitleLabel.text = "Searching..."
            // TODO: Set necessary parameters!
            let methodParameters: [String: String!] = [
                Constants.FlickrParameterKeys.SafeSearch : Constants.FlickrParameterValues.UseSafeSearch,
                Constants.FlickrParameterKeys.Text : searchField.text,
                Constants.FlickrParameterKeys.Extras : Constants.FlickrParameterValues.MediumURL,
                Constants.FlickrParameterKeys.APIKey : Constants.FlickrParameterValues.APIKey,
                Constants.FlickrParameterKeys.Method : Constants.FlickrParameterValues.SearchMethod,
                Constants.FlickrParameterKeys.Format : Constants.FlickrParameterValues.ResponseFormat,
                Constants.FlickrParameterKeys.NoJSONCallback : Constants.FlickrParameterValues.DisableJSONCallback
            ]
            displayImageFromFlickrBySearch(methodParameters)
        } else {
            photoTitleLabel.text = "Please enter a phrase to search"
        }
    }
    
    
    func searchByLatLon(){
        print("\(latitudeTextField.text) \(longitudeTextField.text)")
        
        if isTextFieldValid(latitudeTextField, forRange: Constants.Flickr.SearchLatRange) && isTextFieldValid(longitudeTextField, forRange: Constants.Flickr.SearchLonRange) {
            photoTitleLabel.text = "Searching..."
            // TODO: Set necessary parameters!
            let methodParameters: [String: String!] = [
                Constants.FlickrParameterKeys.SafeSearch : Constants.FlickrParameterValues.UseSafeSearch,
                Constants.FlickrParameterKeys.BoundingBox : bboxString(),
                Constants.FlickrParameterKeys.Extras : Constants.FlickrParameterValues.MediumURL,
                Constants.FlickrParameterKeys.APIKey : Constants.FlickrParameterValues.APIKey,
                Constants.FlickrParameterKeys.Method : Constants.FlickrParameterValues.SearchMethod,
                Constants.FlickrParameterKeys.Format : Constants.FlickrParameterValues.ResponseFormat,
                Constants.FlickrParameterKeys.NoJSONCallback : Constants.FlickrParameterValues.DisableJSONCallback]
            displayImageFromFlickrBySearch(methodParameters)
        }
        else {
            photoTitleLabel.text = "Lat should be [-90, 90].\nLon should be [-180, 180]."
        }
    }
        
    
    private func bboxString() -> String {
        if let latitude = Double(latitudeTextField.text!), let longitude = Double(longitudeTextField.text!) {
            let minLon = max(longitude - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.0)
            let minLat = max(latitude - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.0)
            let maxLon = min(longitude + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.1)
            let maxLat = min(latitude + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.1)
            return "\(minLon),\(minLat),\(maxLon),\(maxLat)"
        } else {
            return "0,0,0,0"
        }
    }
    
    // MARK: Flickr API
    
    private func displayImageFromFlickrBySearch(methodParameters: [String:AnyObject]) {
        
        let session = NSURLSession.sharedSession()
        let request = NSURLRequest(URL: flickrURLFromParameters(methodParameters))
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            func displayError(error: String){
                print(error)
                performUIUpdatesOnMain {
                    self.photoTitleLabel.text = "No photo returned. Try a new search"
                    self.photoImageView.image = nil
                }
            }
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            
            /* GUARD: Check status code*/
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where
                statusCode >= 200 && statusCode <= 299 else {
                displayError("Your status code returned something other than 2XX")
                return
            }
            
            /* GUARD: Was any data returned? */
            guard let data = data else {
                displayError("There was no data returned by request!")
                return
            }
            
            // Parse Data
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            } catch {
                displayError("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did Flickr return an error (stat != ok)? */
            guard let stat = parsedResult[Constants.FlickrResponseKeys.Status] as? String where stat == Constants.FlickrResponseValues.OKStatus else {
                displayError("Flickr returned an error. See error code and message in \(parsedResult)")
                return
            }
            
            /* GUARD: Does Photo key exist*/
            guard let photosDictionary = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                displayError("Could not find Keys '\(Constants.FlickrResponseKeys.Photos)' in \(parsedResult)")
                return
            }
            
            /*GUARD: Does photo key exist*/
            guard let photoArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String:AnyObject]] else {
                displayError("Could not find Keys '\(Constants.FlickrResponseKeys.Photo)' in \(parsedResult)")
                return
            }
            
            // Generate random photo
            let randomIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
            let photoDictionary = photoArray[randomIndex] as [String:AnyObject]
            
            /* GUARD: does photo have url_m key*/
            guard let imageURLString = photoDictionary[Constants.FlickrResponseKeys.MediumURL] as? String, let photoTitle = photoDictionary[Constants.FlickrResponseKeys.Title] as? String else {
                displayError("Could not find keys '\(Constants.FlickrResponseKeys.MediumURL) and \(Constants.FlickrResponseKeys.Title) in \(photoDictionary)")
                return
            }
            
            // Convert String to url
            let imageURL = NSURL(string: imageURLString)
            
            /* GUARD: Get image data */
            guard let imageData = NSData(contentsOfURL: imageURL!) else {
                print("Data for image could not be found")
                return
            }
            
            // Perform UI Changes on main Queue
            performUIUpdatesOnMain{
                self.photoImageView.image = UIImage(data: imageData)
                self.photoTitleLabel.text = photoTitle
            }
            
         }
        
        
        task.resume()
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
        if textField == searchField || textField == longitudeTextField{
            if searchByPhraseBool{
                searchByPhrase()
            } else {
                searchByLatLon()
            }
        } else {
            longitudeTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    private func resignIfFirstResponder(textField: UITextField) {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(sender: AnyObject) {
        resignIfFirstResponder(searchField)
        resignIfFirstResponder(latitudeTextField)
        resignIfFirstResponder(longitudeTextField)
    }
    
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
