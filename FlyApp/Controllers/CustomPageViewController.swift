//
//  CustomPageViewController.swift
//  BWWalkthroughExample
//
//  Created by Yari D'areglia on 18/09/14.
//  Copyright (c) 2014 Yari D'areglia. All rights reserved.
//

import UIKit
import BWWalkthrough

class CustomPageViewController: UIViewController{

     var imageView:UIImageView?
     var titleLabel:UILabel?
     var textLabel:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
}
// MARK: BWWalkThroughPage protocol

extension CustomPageViewController: BWWalkthroughPage{
    func walkthroughDidScroll(to: CGFloat, offset: CGFloat) {
        var tr = CATransform3DIdentity
        tr.m34 = -1/500.0
        
        titleLabel?.layer.transform = CATransform3DRotate(tr, CGFloat(Double.pi) * (1.0 - offset), 1, 1, 1)
        textLabel?.layer.transform = CATransform3DRotate(tr, CGFloat(Double.pi) * (1.0 - offset), 1, 1, 1)
        
        var tmpOffset = offset
        if(tmpOffset > 1.0){
            tmpOffset = 1.0 + (1.0 - tmpOffset)
        }
        imageView?.layer.transform = CATransform3DTranslate(tr, 0 , (1.0 - tmpOffset) * 200, 0)
    }
}
