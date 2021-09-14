//
//  Spendthrift2App.swift
//  Spendthrift2
//
//  Created by Yulia Novikova on 9/6/21.
//

import SwiftUI

@main
struct Spendthrift2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
