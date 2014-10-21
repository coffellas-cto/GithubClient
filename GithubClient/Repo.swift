//
//  Repo.swift
//  GithubClient
//
//  Created by Alex G on 20.10.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

import Foundation
import CoreData

class Repo: NSManagedObject {

    @NSManaged var id: Int64
    @NSManaged var name: String
    @NSManaged var fullName: String
    @NSManaged var isPrivate: Bool
    @NSManaged var htmlUrl: String
    @NSManaged var descriptionString: String
    @NSManaged var updateDate: String
    @NSManaged var language: String
    @NSManaged var stargazersCount: Int16
    @NSManaged var user: User?

}
