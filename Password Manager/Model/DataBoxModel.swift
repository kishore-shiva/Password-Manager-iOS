//
//  DataBoxModel.swift
//  Password Manager
//
//  Created by Kishore Shiva Saravanan on 10/12/24.
//

import Foundation

struct DataBox: Identifiable {
    var id: String
    var topic: String
    var UsernameOrCardNo: String
    var mailId: String
    var passwordOrPin: String
    var additionalDetails: String
    var isExpanded: Bool = false // Track whether the box is expanded
}
