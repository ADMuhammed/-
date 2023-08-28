//
//  TaskListApp.swift
//  TaskList
//
//  Created by Muhammed on 23.05.2023.
//


import SwiftUI
@main
struct TaskListApp: App {
    let persistenceContainer = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
        }
    }
}

