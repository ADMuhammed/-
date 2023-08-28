//
//  Persistence.swift
//  TaskList
//
//  Created by Muhammed on 09.06.2023.
//

import CoreData
import SwiftUI

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "TaskList")

        container.loadPersistentStores{ (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolve Error: \(error)")
            }
        }
    }
}
//данный код представляет общий контроллер сохранения данных Core Data для приложения. Он инициализирует контейнер Core Data и обеспечивает доступ к нему через статическое свойство shared. Это позволяет нам удобно управлять и использовать Core Data во всем приложении
