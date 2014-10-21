//
//  Repo+GithubClient.swift
//  GithubClient
//
//  Created by Alex G on 20.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import Foundation

extension Repo {
    class func repoFromJSONData(JSONData: NSData) -> Repo? {
        var error: NSError?
        let dic = NSJSONSerialization.JSONObjectWithData(JSONData, options: nil, error: &error) as NSDictionary
        if error != nil {
            println("Couldn't parse JSONData")
            return nil
        }
        
        return repoFromNSDictionary(dic)
    }
    
    class func repoFromNSDictionary(dic: NSDictionary) -> Repo? {
        let id = dic["id"] as Int!
        if id == nil {
            return nil
        }
        
        var retVal: Repo!
        var mustUpdate = true
        
        let resultsArray = CoreDataManager.manager.fetchObjectsWithEntityClass(Repo.classForCoder(), predicateFormat: "id == %@", NSNumber(integer: id))
        if (resultsArray != nil) && (resultsArray?.count > 0) {
            retVal = resultsArray!.first as? Repo
            if let updateDate = dic["updated_at"] as String? {
                mustUpdate = retVal.updateDate != updateDate
            }
        }
        else {
            retVal = CoreDataManager.manager.newObjectForEntityClass(Repo) as? Repo
        }
        
        if mustUpdate && retVal != nil {
            retVal.id = Int64(id)
            retVal.name = dic["name"] as String
            retVal.fullName = dic["full_name"] as String
            retVal.htmlUrl = dic["html_url"] as String
            retVal.isPrivate = dic["private"] as Bool
            retVal.language = dic["language"] as String
            retVal.stargazersCount = Int16(dic["stargazers_count"] as Int)
            retVal.updateDate = dic["updated_at"] as String
            retVal.descriptionString = dic["description"] as String
            retVal.user = User.userFromNSDictionary(dic["owner"] as NSDictionary)
        }
        
        return retVal
    }
}