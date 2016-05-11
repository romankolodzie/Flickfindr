//
//  SearchViewController.swift
//  Flickfindr
//
//  Created by Roman Kolodzie on 5/5/16.
//  Copyright © 2016 Roman Kolodzie. All rights reserved.
//



// TODO
//        Make code less redundant
//        fix animation timing
//        finish app
//        gradient the search bar
//
//        *optional*
//        bezier animation


import UIKit

class SearchViewController: UIViewController {
    
    // VARIABLES
    
    @IBOutlet weak var flickfindrLabel: UILabel!
    
    private var searchButton = UIButton(type: UIButtonType.Custom) as UIButton
    private var cancelButton = UIButton(type: UIButtonType.Custom) as UIButton
    let searchButtonImage = UIImage(named: "Search") as UIImage?
    let cancelButtonImage = UIImage(named: "Cancel") as UIImage?
    
    private var searchField = UITextField()
    private let searchBarShapeLayer = CAShapeLayer()
    
    var CGPointSearchBarInitial: CGPoint!
    var CGPointSearchBarFinal: CGPoint!
    var CGPointButtonRight: CGPoint!
    var CGPointButtonLeft: CGPoint!
    
    private let minHeight: CGFloat = 73.0
    
    let blue = UIColor(red: 63/255.0, green: 169/255.0, blue: 245/255.0, alpha: 1.0)
    let lightBlue = UIColor(red: 118/255.0, green: 214/255.0, blue: 255.0, alpha: 1.0)
    
    
    
    
    // LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        flickfindrLabel.hidden = false
        
        setup()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    
    
    
    
    // FUNCTIONS
    
    func setup() {
        
        
        CGPointSearchBarInitial = CGPointMake(1.5*view.bounds.width-80.0, minHeight/2)
        CGPointSearchBarFinal = CGPointMake(view.bounds.width/2, minHeight/2)
        CGPointButtonRight = CGPointMake(view.bounds.width-60.0, 26.0)
        CGPointButtonLeft = CGPointMake(20.0, 26.0)
        
        //Search Bar shape layer
        searchBarShapeLayer.frame = CGRectMake(view.bounds.width-80.0, 0.0, view.bounds.width, minHeight)
        searchBarShapeLayer.backgroundColor = lightBlue.CGColor
        view.layer.addSublayer(searchBarShapeLayer)
        
        
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
        searchField.frame = CGRect(x: 80, y: 37, width: view.bounds.width - 160.0, height: 20)
        searchField.backgroundColor = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 0.2)
        searchField.textColor = UIColor.whiteColor()
        searchField.borderStyle = UITextBorderStyle.RoundedRect
        searchField.textAlignment = .Center
        self.view.addSubview(searchField)
    }
    
    
    func searchButtonPressed(sender: AnyObject) {
        flickfindrLabel.hidden = true
        searchButton.enabled = false
        searchField.enabled = true
        searchField.hidden = false
        
        // Button animations
        
        UIView.animateWithDuration(0.5, animations: {
            self.searchButton.frame = CGRectMake(self.CGPointButtonLeft.x, self.CGPointButtonLeft.y, 40.0, 40.0)
            // How can I make the Search button rotate while moving, but end up in the same orientation?
            self.cancelButton.frame = CGRectMake(self.CGPointButtonRight.x, self.CGPointButtonRight.y, 40.0, 40.0)
        })
        
    
        searchBarAnimationFunc(CGPointSearchBarInitial, toPoint: CGPointSearchBarFinal, object: searchBarShapeLayer)
        
    }
    
    
    func cancelButtonPressed(sender:AnyObject) {
        print("Gotit")
        searchField.hidden = true
        searchButton.enabled = true
        
        UIView.animateWithDuration(0.5, animations: {
            self.searchButton.frame = CGRectMake(self.CGPointButtonRight.x, self.CGPointButtonRight.y, 40.0, 40.0)
            self.cancelButton.frame = CGRectMake(self.CGPointButtonRight.x + self.view.bounds.width, self.CGPointButtonRight.y, 40.0, 40.0)
        })
        
        searchBarAnimationFunc(CGPointSearchBarFinal, toPoint: CGPointSearchBarInitial, object: searchBarShapeLayer)
        
    }
    
    
    func searchBarAnimationFunc(fromPoint: CGPoint, toPoint: CGPoint, object: CAShapeLayer){
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.additive = true
        animation.fromValue = NSValue(CGPoint: fromPoint)
        animation.toValue = NSValue(CGPoint: toPoint)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.duration = 0.5
        
        object.addAnimation(animation, forKey: "position")
        object.position = toPoint
        
    }
}
