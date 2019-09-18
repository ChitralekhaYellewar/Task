//
//  UIViewController+Extension.swift
//  FashionCloudAssignment
//
//  Created by Chitralekha Yellewar on 18/09/19.
//  Copyright © 2019 Chitralekha Yellewar. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK : - function to get top most view controller
    
    class internal var topMostViewController: UIViewController? {
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        while let viewController = presentedVC?.presentedViewController {
            presentedVC = viewController
        }
        return presentedVC
    }
    
}

