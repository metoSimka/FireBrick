//
//  TeamModel.swift
//  FireBrick
//
//  Created by metoSimka on 28/05/2019.
//  Copyright © 2019 metoSimka. All rights reserved.
//

import Foundation
import Firebase

struct Team {
    var name: String?
    var users: [User]?
    var technologies: [Technology]?
    var documentID: String?
}
