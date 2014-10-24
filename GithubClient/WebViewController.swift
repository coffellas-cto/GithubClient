//
//  WebViewController.swift
//  GithubClient
//
//  Created by Alex G on 23.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    // MARK: Public Properties
    var URLString: String!
    
    // MARK: Private Properties
    private var webView: WKWebView!
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Private Methods
    private func showError(error: String) {
        UIAlertView(title: "Error", message: error, delegate: nil, cancelButtonTitle: "OK").show()
    }
    
    // MARK: WKNavigationDelegate
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            webView.alpha = 1
        }) { (completed) -> Void in
            self.activityIndicator.stopAnimating()
        }
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        showError(error.localizedDescription)
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        showError(error.localizedDescription)
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.URL.host? == NSURL(string: URLString)?.host? {
            decisionHandler(.Allow)
            return
        }
        
        decisionHandler(.Cancel)
        showError("Navigation outside Github is not allowed")
    }
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        webView = WKWebView(frame: self.view.bounds)
        webView.navigationDelegate = self
        webView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        self.view.addSubview(webView)

        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        activityIndicator.autoresizingMask = .FlexibleLeftMargin | .FlexibleTopMargin | .FlexibleBottomMargin | .FlexibleRightMargin
        self.view.addSubview(activityIndicator)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        webView.alpha = 0
        if let URLString = URLString {
            let request = NSURLRequest(URL: NSURL(string: URLString)!)
            webView.loadRequest(request)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        webView.stopLoading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
