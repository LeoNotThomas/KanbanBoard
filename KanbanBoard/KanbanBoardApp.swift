//
//  KanbanBoardApp.swift
//  KanbanBoard
//
//  Created by Thomas Leonhardt on 12.09.22.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Kanban.configure()
        Kanban.shared.initData()
        return true
    }
}

@main
struct KanbanBoardApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
