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

let kTransitionDuration: NSTimeInterval = 0.7

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
            
            // Apply blur effect
            let effectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
            effectView.frame = CGRectMake(0, 0, fromVCUsers.view.frame.width, fromVCUsers.view.frame.height)
            effectView.alpha = 0
            fromVCUsers.view.addSubview(effectView)
            
            UIView.animateKeyframesWithDuration(kTransitionDuration, delay: 0, options: .allZeros, animations: { () -> Void in
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.4, animations: { () -> Void in
                    effectView.alpha = 1
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.2, relativeDuration: 0.7, animations: { () -> Void in
                    tmpImageView.frame.origin = toVCUser.selectedImageViewOrigin
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
                    toVC.view.frame.origin = fromVC.view.frame.origin
                })
            }, completion: { (completed) -> Void in
                effectView.removeFromSuperview()
                toVCUser.selectedImageView?.alpha = 1
                tmpImageView.removeFromSuperview()
                fromVCUsers.selectedImageView?.alpha = 1
                transitionContext.completeTransition(completed)
            })
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
            
            // Apply blur effect
            let effectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
            effectView.frame = CGRectMake(0, 0, toVCUsers.view.frame.width, toVCUsers.view.frame.height)
            toVCUsers.view.addSubview(effectView)
            
            UIView.animateKeyframesWithDuration(kTransitionDuration, delay: 0, options: .allZeros, animations: { () -> Void in
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.5, animations: { () -> Void in
                    fromVC.view.frame.origin = CGPoint(x: fromVC.view.frame.width, y:fromVC.view.frame.origin.y)
                })
                
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.7, animations: { () -> Void in
                    tmpImageView.frame.origin = toVCUsers.selectedImageViewOrigin
                })
                
                UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
                    effectView.alpha = 0
                })
            }, completion: { (completed) -> Void in
                effectView.removeFromSuperview()
                toVCUsers.selectedImageView?.alpha = 1
                tmpImageView.removeFromSuperview()
                fromVCUser.selectedImageView?.alpha = 1
                transitionContext.completeTransition(completed)
            })
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return kTransitionDuration
    }
}
