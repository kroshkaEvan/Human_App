//
//  SettingsTabCoordinator.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import SwiftUI
import Combine

final class SettingsTabCoordinator: ObservableObject, Identifiable {
    
    // MARK: - Publishers
    
    @Published var viewModel: SettingsViewModel?
        
    // MARK: Stored Properties
    
    private unowned let parent: HomeCoordinator
    
    private var cancellables = Cancelable()
    
    // MARK: Initialization
    
    init(parent: HomeCoordinator) {
        self.parent = parent
        initViewModel()
    }
}

// MARK: Public methods

extension SettingsTabCoordinator { }

// MARK: Private methods

extension SettingsTabCoordinator {
    private func initViewModel() {
        viewModel = SettingsViewModel(coordinator: self)
    }
}
