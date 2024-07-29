//
//  MainTabCoordinatorView.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import SwiftUI

struct MainTabCoordinatorView: View {
    @ObservedObject var coordinator: MainTabCoordinator
            
    var body: some View {
        if let viewModel = coordinator.viewModel {
            MainView(viewModel: viewModel)
        }
    }
}
