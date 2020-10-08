//
//  AppDelegate.swift
//  test
//
//  Created by Efe Mazlumoğlu on 8.10.2020.
//

import UIKit
import BackgroundTasks
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.efemaz.fetch", using: nil) { (task) in
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
        return true
    }
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
            PokeManager.urlSession.invalidateAndCancel()
          }
          
          let randomPoke = (1...151).randomElement() ?? 1
          PokeManager.pokemon(id: randomPoke) { (pokemon) in
            NotificationCenter.default.post(name: .newPokemonFetched,
                                            object: self,
                                            userInfo: ["pokemon": pokemon])
            self.scheduleNotification(inSeconds: 1, completion: { success in
                if success {
                    print("Successfully scheduled notification")
                } else {
                    print("Error scheduling notification")
                }
            })
            task.setTaskCompleted(success: true)
          }
          
          scheduleBackgroundPokemonFetch()
    }
    
    func scheduleNotification(inSeconds: TimeInterval, completion: @escaping (Bool) -> ()) {
        
        // Create Notification content
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = "Notification"
        notificationContent.subtitle = "This is a notification"
        notificationContent.body = "EFE MAZ"
        
        // Create Notification trigger
        // Note that 60 seconds is the smallest repeating interval.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        // Create a notification request with the above components
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: notificationContent, trigger: trigger)
        
        // Add this notification to the UserNotificationCenter
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("\(String(describing: error))")
                completion(false)
            } else {
                completion(true)
            }
        })
    }
    
    let notificationIdentifier = "myNotification"
    
    func scheduleBackgroundPokemonFetch() {
        let pokemonFetchTask = BGAppRefreshTaskRequest(identifier: "com.efemaz.fetch")
        pokemonFetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        do {
          try BGTaskScheduler.shared.submit(pokemonFetchTask)
            print("successed of schedule background pokemon fetch and earliest begin date is: ", pokemonFetchTask.earliestBeginDate as Any)
        } catch {
          print("Unable to submit task: \(error.localizedDescription)")
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension Notification.Name {
  static let newPokemonFetched = Notification.Name("com.efemaz.fetch")
}
