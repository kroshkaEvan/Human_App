//
//  AVApp.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import SwiftUI

@main
struct AVApp: App {
    @StateObject var coordinator = MainCoordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.sharedView()
        }
    }
}
