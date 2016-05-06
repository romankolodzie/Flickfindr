//
//  ViewController.swift
//  Flickfindr
//
//  Created by Roman Kolodzie on 5/5/16.
//  Copyright © 2016 Roman Kolodzie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let minHeight: CGFloat = 73.0
    private let shapeLayer = CAShapeLayer()
    let blue = UIColor(red: 63/255.0, green: 169/255.0, blue: 245/255.0, alpha: 1.0)
    let lightBlue = UIColor(red: 118/255.0, green: 214/255.0, blue: 255.0, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        shapeLayer.frame = CGRect(x: view.bounds.width*0.78, y: 0.0, width: view.bounds.width, height: minHeight)
        shapeLayer.backgroundColor = lightBlue.CGColor
        view.layer.addSublayer(shapeLayer)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }


}

