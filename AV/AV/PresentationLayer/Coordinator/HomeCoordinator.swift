//
//  HomeCoordinator.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import SwiftUI
import Combine

final class HomeCoordinator: ObservableObject, Identifiable {
    
    // MARK: - Publishers
    
    @Published var mainCoordinator: MainTabCoordinator?
    
    @Published var settingsCoordinator: SettingsTabCoordinator?
    
    @Published var presentationViewModel: PresentationViewModel?
        
    @Published var tab = HomeTab.main
    
    @Published var isUnlocked: Bool = false
    
    // MARK: Stored Properties

    private unowned let parent: MainCoordinator

    private var subscriber = Cancelable()
    
    // MARK: Initialization
    
    init(parent: MainCoordinator) {
        self.parent = parent
        initPresentationViewModel()
        initTabs()
    }
}

// MARK: Private methods

extension HomeCoordinator {
    private func initTabs() {
        self.mainCoordinator = .init(parent: self)
        self.settingsCoordinator = .init(parent: self)
    }
    
    private func initPresentationViewModel() {
        self.presentationViewModel = PresentationViewModel(coordinator: self)
    }
}

// MARK: Public methods

extension HomeCoordinator {

    func unlockHome() {
        isUnlocked = true
    }
    
    func lockHome() {
        isUnlocked = false
    }
}
