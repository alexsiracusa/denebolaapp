//
//  DenebolaAppApp.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/1/21.
//

import CoreData
import SwiftUI

@main
struct CypressAppApp: App {
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
