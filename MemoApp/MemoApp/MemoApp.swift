//
//  MemoAppApp.swift
//  MemoApp
//
//  Created by 조수원 on 5/3/25.
//

import SwiftUI

@main
struct MemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
