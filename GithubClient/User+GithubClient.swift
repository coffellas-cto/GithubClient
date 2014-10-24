//
//  User+GithubClient.swift
//  GithubClient
//
//  Created by Alex G on 20.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import Foundation

extension User {
    class func userFromJSONData(JSONData: NSData) -> User? {
        var error: NSError?
        let dic = NSJSONSerialization.JSONObjectWithData(JSONData, options: nil, error: &error) as NSDictionary
        if error != nil {
            println("Couldn't parse JSONData")
            return nil
        }
        
        return userFromNSDictionary(dic)
    }
    
    class func userFromNSDictionary(dic: NSDictionary) -> User? {
        let id = dic["id"] as Int!
        if id == nil {
            return nil
        }
        
        var retVal: User!
        var mustUpdate = true
        
        let resultsArray = CoreDataManager.manager.fetchObjectsWithEntityClass(User.classForCoder(), predicateFormat: "id == %@", NSNumber(integer: id))
        if (resultsArray != nil) && (resultsArray?.count > 0) {
            retVal = resultsArray!.first as? User
            if let updateDate = dic["updated_at"] as String? {
                mustUpdate = retVal.updateDate != updateDate
            }
        }
        else {
            retVal = CoreDataManager.manager.newObjectForEntityClass(User) as? User
        }
        
        if mustUpdate && (retVal != nil) {
            retVal.id = id
            retVal.updateDate = dic["updated_at"] as String?
            retVal.login = dic["login"] as String
            retVal.apiUrl = dic["url"] as String
            if let avatarUrl = dic["avatar_url"] as? String {
                if avatarUrl != retVal.avatarUrl {
                    retVal.avatarUrl = avatarUrl
                    retVal.avatarLocalPath = nil
                }
            }
            retVal.htmlUrl = dic["html_url"] as? String
            retVal.reposUrl = dic["repos_url"] as? String
            retVal.publicRepos = dic["public_repos"] as? NSNumber
            retVal.name = dic["name"] as? String
            retVal.bio = dic["bio"] as? String
        }
        
        return retVal
    }
}