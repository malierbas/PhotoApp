//
//  LocalStorageManager.swift
//  PhotoApp
//
//  Created by Ali on 21.11.2021.
//

import Foundation

let globalUserPreferences = LocalStorageManager()

class LocalStorageManager {
    //MARK: - UserPreferences
    private let defaults = UserDefaults.standard
    
    //: UserDemoToken
    var token: String {
        get {
            return defaults.string(forKey: "userDemoToken") ?? "nil"
        }
        set {
            defaults.set(newValue, forKey: "userDemoToken")
        }
    }
    
    //: UserLoggedIn
    var isUserLoggedIn: Bool {
        get {
            return defaults.bool(forKey: "isUserLoggedIn")
        }
        
        set {
            defaults.set(newValue, forKey: "isUserLoggedIn")
        }
    }
}
