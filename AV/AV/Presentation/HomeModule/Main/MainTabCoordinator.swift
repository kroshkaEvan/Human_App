//
//  MainTabCoordinator.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import SwiftUI
import Combine

final class MainTabCoordinator: ObservableObject, Identifiable {
    
    // MARK: - Publishers
    
    @Published var viewModel: MainViewModel?
        
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

extension MainTabCoordinator { }

// MARK: Private methods

extension MainTabCoordinator {
    private func initViewModel() {
        viewModel = MainViewModel(coordinator: self)
    }
}
