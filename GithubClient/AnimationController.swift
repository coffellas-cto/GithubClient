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

let kTransitionDuration: NSTimeInterval = 0.5

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    var type: AnimationType?
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UIViewController!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UIViewController!
        transitionContext.containerView().insertSubview(toVC!.view, belowSubview: fromVC.view)
        let containerView = transitionContext.containerView()
        
        if type == .Push {
            containerView.addSubview(toVC.view)
            
            let fromVCUsers = fromVC as UsersViewController
            let toVCUser = toVC as UserViewController
            var tmpImageView = UIImageView(image: fromVCUsers.selectedImageView!.imageFromView())
            tmpImageView.frame.origin = fromVCUsers.selectedImageViewOrigin
            containerView.addSubview(tmpImageView)
            
            // Set toVC original frame
            toVC.view.frame = containerView.frame
            toVC.view.frame.origin = CGPoint(x: toVC!.view.frame.width, y:toVC!.view.frame.origin.y)
            
            // Set views initial values
            fromVCUsers.selectedImageView?.alpha = 0
            toVCUser.selectedImageView?.alpha = 0
            
            UIView.animateWithDuration(kTransitionDuration, animations: { () -> Void in
                toVC.view.frame.origin = fromVC.view.frame.origin
                tmpImageView.frame.origin = toVCUser.selectedImageViewOrigin
            }) { (completed) -> Void in
                toVCUser.selectedImageView?.alpha = 1
                tmpImageView.removeFromSuperview()
                fromVCUsers.selectedImageView?.alpha = 1
                transitionContext.completeTransition(completed)
            }
        }
        else {
            containerView.addSubview(fromVC.view)
            
            let fromVCUser = fromVC as UserViewController
            let toVCUsers = toVC as UsersViewController
            var tmpImageView = UIImageView(image: fromVCUser.selectedImageView!.imageFromView())
            tmpImageView.frame.origin = fromVCUser.selectedImageViewOrigin
            containerView.addSubview(tmpImageView)
            
            // Set fromVC original frame
            fromVC.view.frame = containerView.frame
            
            // Set views initial values
            fromVCUser.selectedImageView?.alpha = 0
            toVCUsers.selectedImageView?.alpha = 0
            
            UIView.animateWithDuration(kTransitionDuration, animations: { () -> Void in
                fromVC.view.frame.origin = CGPoint(x: fromVC.view.frame.width, y:fromVC.view.frame.origin.y)
                tmpImageView.frame.origin = toVCUsers.selectedImageViewOrigin
                }) { (completed) -> Void in
                    toVCUsers.selectedImageView?.alpha = 1
                    tmpImageView.removeFromSuperview()
                    fromVCUser.selectedImageView?.alpha = 1
                    transitionContext.completeTransition(completed)
            }
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return kTransitionDuration
    }
}
