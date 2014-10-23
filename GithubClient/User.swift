//
//  GithubClient.swift
//  GithubClient
//
//  Created by Alex G on 23.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var apiUrl: String
    @NSManaged var avatarLocalPath: String?
    @NSManaged var avatarUrl: String?
    @NSManaged var htmlUrl: String?
    @NSManaged var id: NSNumber
    @NSManaged var login: String
    @NSManaged var publicRepos: NSNumber?
    @NSManaged var updateDate: String?
    @NSManaged var name: String?
    @NSManaged var bio: String?
    @NSManaged var repos: NSSet?

}
