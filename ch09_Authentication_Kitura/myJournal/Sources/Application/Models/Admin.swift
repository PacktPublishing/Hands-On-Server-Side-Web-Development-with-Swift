//
//  Admin.swift
//  Application
//
//  Created by Angus yeung on 10/15/18.
//

import SwiftKueryORM
import CredentialsHTTP


struct Admin: Model 
{
	static var idColumnName = "id"

    public static func checkPassword(username: String, 
                                      password: String) -> Bool {
        var ret = false
        Admin.find(id: username) { user, error in
            if let user = user {
                if password == user.password {
                    ret = true
                }
            }
        }
        return ret
    }

    public var id: String
    private let password: String
}