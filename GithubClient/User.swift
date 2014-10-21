//
//  User.swift
//  GithubClient
//
//  Created by Alex G on 20.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var login: String
    @NSManaged var id: Int64
    @NSManaged var avatarUrl: String
    @NSManaged var apiUrl: String
    @NSManaged var htmlUrl: String
    @NSManaged var publicRepos: Int16
    @NSManaged var updateDate: String
    @NSManaged var avatarLocalPath: String
    @NSManaged var repos: NSSet

}
