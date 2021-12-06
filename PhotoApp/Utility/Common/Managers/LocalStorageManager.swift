//
//  LocalStorageManager.swift
//  PhotoApp
//
//  Created by Ali on 21.11.2021.
//

import Foundation
 

class LocalStorageManager {
    //MARK: - UserPreferences
    private let defaults = UserDefaults.standard
    static let shared = LocalStorageManager()
    
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

    enum Keys: String {
        case purchaseExpirationDate
        case isPremiumUser
        case installDateTimestamp
        case sessionCount
        case hasRequestedRating
        case initialNotificationsScheduleTimestamp
        case shouldUpdate
        case weeklyGiftScarcityTimeLeft
    }

    var purchaseExpirationDate: Date {
        get {
            return UserDefaults.standard.value(forKey: Keys.purchaseExpirationDate.rawValue) as? Date ?? Date().addingTimeInterval(-1000) // if not found, return a past date value
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.purchaseExpirationDate.rawValue)
        }
    }

    var isPremiumUser: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.isPremiumUser.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isPremiumUser.rawValue)
            if newValue {
                LocalNotificationManager.shared.removeAllScheduledNotifications(forNotifications: LocalNotificationManager.shared.initialNotifications)
            }
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: Keys.isPremiumUser.rawValue), object: nil, userInfo: nil)
        }
    }

    var sessionCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.sessionCount.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.sessionCount.rawValue)
        }
    }

    var installDateTimestamp: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.installDateTimestamp.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.installDateTimestamp.rawValue)
        }
    }

    var hasRequestedRating: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.hasRequestedRating.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.hasRequestedRating.rawValue)
        }
    }

    var initialNotificationsScheduleTimestamp: Int {
        get {
            return UserDefaults.standard.integer(forKey: Keys.initialNotificationsScheduleTimestamp.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.initialNotificationsScheduleTimestamp.rawValue)
        }
    }

    var weeklyGiftScarcityTimeLeft: TimeInterval {
        get {
        return UserDefaults.standard.double(forKey: Keys.weeklyGiftScarcityTimeLeft.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.weeklyGiftScarcityTimeLeft.rawValue)
        }
    }

    private init() {}

}
