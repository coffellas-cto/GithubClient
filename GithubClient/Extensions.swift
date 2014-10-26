//
//  Extensions.swift
//  GithubClient
//
//  Created by Alex G on 23.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

extension UIView {
    func imageFromView() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0)
        self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: false)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }
}

extension String {
    var valid: Bool {
        get {
            var error: NSError?
            let regex = NSRegularExpression(pattern: "[^0-9a-zA-Z \n]", options: nil, error: &error)
            if error != nil {
                return true
            }
            
            return regex!.numberOfMatchesInString(self, options: nil, range: NSRange(location: 0, length: countElements(self))) == 0
        }
    }
}