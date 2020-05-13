//
//  LocalNotification.swift
//  FarmacyTracker
//
//  Created by Cristina Matei on 12/05/2020.
//  Copyright © 2020 Cristina-Gabriela Matei. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationManager
{
    var notifications = [Remainder]()
    
    func listScheduledNotifications()
    {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in

            for notification in notifications {
                print(notification)
            }
        }
    }
    
    func schedule()
    {
        UNUserNotificationCenter.current().getNotificationSettings { settings in

            print("settings")
            print(settings)
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break // Do nothing
            }
        }
    }
    
    private func scheduleNotifications()
    {
        for notification in notifications
        {
            let content      = UNMutableNotificationContent()
            content.title    = notification.title
            content.sound    = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: false)

            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in

                guard error == nil else { return }

                print("Notification scheduled! --- ID = \(notification.id)")
            }
        }
    }

}
