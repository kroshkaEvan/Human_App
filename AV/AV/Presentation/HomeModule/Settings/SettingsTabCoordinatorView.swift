//
//  SettingsTabCoordinatorView.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import SwiftUI

struct SettingsTabCoordinatorView: View {
    @ObservedObject var coordinator: SettingsTabCoordinator
            
    var body: some View {
        if let viewModel = coordinator.viewModel {
            SettingsView(viewModel: viewModel)
        }
    }
}
