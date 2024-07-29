//
//  HomeCoordinatorView.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import SwiftUI

enum HomeTab {
    case main
    case settings
}

struct HomeCoordinatorView: View {
    
    @ObservedObject var coordinator: HomeCoordinator

    // MARK: Views

    var body: some View {
        if let viewModel = coordinator.presentationViewModel {
            PresentationView(viewModel: viewModel)
                .fullScreenCover(isPresented: $coordinator.isUnlocked) {
                    TabView(selection: $coordinator.tab) {
                        if let mainCoordinator = coordinator.mainCoordinator {
                            MainTabCoordinatorView(coordinator: mainCoordinator)
                                .tabItem { Text("Main") }
                                .tag(HomeTab.main)
                        }
                        
                        if let settingsCoordinator = coordinator.settingsCoordinator {
                            SettingsTabCoordinatorView(coordinator: settingsCoordinator)
                                .tabItem { Text("Settings") }
                                .tag(HomeTab.settings)
                        }
                    }
                    .edgesIgnoringSafeArea(.all)
                }
        }
    }
}
