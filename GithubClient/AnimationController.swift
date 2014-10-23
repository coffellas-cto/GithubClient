//
//  AnimationController.swift
//  GithubClient
//
//  Created by Alex G on 23.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

enum AnimationType {
    case Push
    case Pop
}

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var type: AnimationType?
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UIViewController!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UIViewController!
        transitionContext.containerView().insertSubview(toVC!.view, belowSubview: fromVC.view)
        
        //Set anchor points for the views
        setAnchorPoint(CGPoint(x: type == .Push ? 1.0 : 0.0, y: 0.5), forView: toVC.view)
        setAnchorPoint(CGPoint(x: type == .Push ? 0.0 : 1.0, y: 0.5), forView: fromVC.view)
        
        //Set appropriate z indexes
        fromVC.view.layer.zPosition = 2.0
        toVC.view.layer.zPosition = 1.0
        
        //90 degree transform away from the user
        var t: CATransform3D = CATransform3DIdentity
        t = CATransform3DRotate(t, CGFloat(M_PI / 2.0), 0.0, 1.0, 0.0)
        t.m34 = 1.0 / -2000
        
        //Apply full transform to the 'to' view to start out with
        toVC.view.layer.transform = t
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            fromVC.view.layer.transform = t;
            toVC.view.layer.transform = CATransform3DIdentity;
        }) { (completed) -> Void in
            fromVC.view.layer.zPosition = 0.0
            toVC.view.layer.zPosition = 0.0
            transitionContext.completeTransition(completed)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.3
    }
    
    func setAnchorPoint(point: CGPoint, forView view: UIView) {
        let oldOrigin = view.frame.origin
        view.layer.anchorPoint = point;
        let newOrigin = view.frame.origin
        
        var transitionPoint = CGPointZero
        transitionPoint.x = newOrigin.x - oldOrigin.x
        transitionPoint.y = oldOrigin.y - oldOrigin.y
        
        view.center = CGPointMake (view.center.x - transitionPoint.x, view.center.y - transitionPoint.y)
    }
}
