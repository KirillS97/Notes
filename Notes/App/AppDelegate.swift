//
//  AppDelegate.swift
//  Notes
//
//  Created by Kirill on 25.09.2023.
//

import UIKit



@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: Создание заметки при первом запуске приложения
        if !UserDefaults.standard.bool(forKey: "firstLaunch") {
            UserDefaults.standard.setValue(true, forKey: "firstLaunch")
            let coreDataManager = CoreDataManager.shared
            let context = coreDataManager.persistentContainer.viewContext
            let mutableAttributedText = NSMutableAttributedString(string: "Твоя первая заметка")
            mutableAttributedText.addAttributes(AppFonts.getRegularTextAttributes(),
                                                range: NSMakeRange(0, mutableAttributedText.length))
            let currentDate = Date(timeIntervalSinceNow: TimeInterval(TimeZone.current.secondsFromGMT()))
            var firstNote = Note(attributedText: mutableAttributedText, lastEditDate: currentDate)
            firstNote.attach()
            NoteEntity.createNoteEntity(note: firstNote, context: context)
        }
        
        return true
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


}

