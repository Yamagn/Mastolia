//
//  Toots.swift
//  Mastlia
//
//  Created by ymgn on 2018/11/25.
//  Copyright © 2018 ymgn. All rights reserved.
//

import Foundation

struct Toots: Codable {
    var created_at: String
    var replies_count: Int
    var reblogs_count: Int
    var favorites_count: Int
    var reblogged: Bool
    var favorited: Bool
    var account: User
    
    var content: String
}

struct User: Codable {
    var username: String
    var display_name: String
    var avatar: URL
}
