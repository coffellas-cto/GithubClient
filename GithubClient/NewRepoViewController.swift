//
//  NewRepoViewController.swift
//  GithubClient
//
//  Created by Alex G on 24.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import UIKit

class NewRepoViewController: UITableViewController {

    // MARK: Life Cycle
    
    @IBOutlet weak var downloadsSwitch: UISwitch!
    @IBOutlet weak var readmeSwitch: UISwitch!
    @IBOutlet weak var repoDescriptionTextField: UITextField!
    @IBOutlet weak var repoNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.compare(NSIndexPath(forRow: 0, inSection: 2)) == .OrderedSame {
            if (repoNameTextField.text == "") || (repoNameTextField.text == nil) {
                UIAlertView(title: "Alert", message: "Repo's name cannot be empty", delegate: nil, cancelButtonTitle: "OK").show()
                return
            }
            
            GithubNetworking.controller.newRepoWithName(repoNameTextField.text, description: repoDescriptionTextField.text, generateReadme: readmeSwitch.selected, allowDownloads: downloadsSwitch.selected, completion: { (responseDic, errorString) -> Void in
                if errorString != nil {
                    UIAlertView(title: "Error", message: "Can't create repo. \(errorString)", delegate: nil, cancelButtonTitle: "OK").show()
                    return
                }
                
                println(responseDic)
            })
        }
    }

}
