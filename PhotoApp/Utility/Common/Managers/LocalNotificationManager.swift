//
//  LocalNotificationManager.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import UserNotifications
import UIKit

class LocalNotificationManager {

    let center = UNUserNotificationCenter.current()

    struct NotificationContent {
        var title: String?
        var body: String?
        var type: NotificationType = .initialNotification
        var repeats: Bool = true
        var repeatsTriggerHour: Int = 12
        var identifier: String?

        init(title: String?, body: String?, type: NotificationType = .initialNotification, repeats: Bool = true, repeatsTriggerHour: Int = 12, identifier: String?) {
            self.title = title
            self.body = body
            self.type = type
            self.repeats = repeats
            self.repeatsTriggerHour = repeatsTriggerHour
            self.identifier = identifier
        }

        enum NotificationType: String {
            case initialNotification
        }
    }

    private(set) var initialNotifications: [NotificationContent] = [
        NotificationContent(title: "Stories are memories!🌼",
                            body: "🚨 Claim your gift now! 🎁",
                            repeats: true,
                            repeatsTriggerHour: 12,
                            identifier: "1"),
        NotificationContent(title: "Every week new exclusive templates💫",
                            body: "🚨 Claim your gift now! 🎁",
                            repeats: true,
                            repeatsTriggerHour: 20,
                            identifier: "2")
    ]

    static let shared = LocalNotificationManager()

    private init() { }

    func scheduleNotifications(notifications: [NotificationContent]) {
        notifications.forEach({ scheduleLocalNotification(notificationContent: $0) })
    }

    private func scheduleLocalNotification(notificationContent: NotificationContent) {

        let content = UNMutableNotificationContent()
        content.title = notificationContent.title ?? ""
        content.body = notificationContent.body ?? ""
        content.sound = UNNotificationSound.default
        content.badge = 1

        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = notificationContent.repeatsTriggerHour
        dateComponents.minute = 0

        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: notificationContent.repeats)

        let request = UNNotificationRequest(identifier: notificationContent.identifier ?? "",
                                            content: content,
                                            trigger: trigger)
        center.add(request) { (error) in
            guard error == nil else { print(error?.localizedDescription ?? ""); return }
            print("scheduled local notification successfully, with notification identifier: \(notificationContent.identifier ?? "")")
        }
        center.add(request, withCompletionHandler: nil)
    }

    func removeAllScheduledNotifications(forNotifications notifications: [NotificationContent]) {
        print("removing notifications with identifiers: \(notifications.map({ $0.identifier ?? "" }))")
        center.removePendingNotificationRequests(withIdentifiers: notifications.map({ $0.identifier ?? "" }))
    }

    func registerForRemoteNotifications() {
        let application = UIApplication.shared

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { [weak self] granted, error in
                    guard let self = self else { return }
                    guard granted else { return }
                    if !LocalStorageManager.shared.isPremiumUser {
                        if LocalStorageManager.shared.initialNotificationsScheduleTimestamp == 0 {
                            self.scheduleNotifications(notifications: LocalNotificationManager.shared.initialNotifications)
                            LocalStorageManager.shared.initialNotificationsScheduleTimestamp = Int(Date().timeIntervalSince1970)
                        } else {
                            let hasPassedAWeek = Int(Date().timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(LocalStorageManager.shared.initialNotificationsScheduleTimestamp)))) > 7 * 24 * 60 * 60
                            if hasPassedAWeek {
                                self.removeAllScheduledNotifications(forNotifications: LocalNotificationManager.shared.initialNotifications)
                            }
                        }
                    } else {
                        self.removeAllScheduledNotifications(forNotifications: LocalNotificationManager.shared.initialNotifications)
                    }
            })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }

}

