//
//  MainCoordinator.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import SwiftUI
import Combine

final class MainCoordinator: ObservableObject {
    
    // MARK: - Publishers
    
    @Published var coordinatorType: CoordinatorType = .home
        
    // MARK: Stored Properties
    
    private var homeCoordinator: HomeCoordinator?
                    
    private var subscriber = Cancelable()
    
    // MARK: Initialization
    
    init() {
        DIContainer.shared.registration()
        self.setupCoordinators()
    }
}

// MARK: Shared View

extension MainCoordinator {
    @ViewBuilder func sharedView() -> some View {
        switch coordinatorType {
        case .home:
            if let homeCoordinator {
                HomeCoordinatorView(coordinator: homeCoordinator)
            }
        }
    }
}

// MARK: Public methods

extension MainCoordinator {
    func setCoordinator(type: CoordinatorType) {
        self.coordinatorType = type
        setupCoordinators()
    }
}

// MARK: Private methods

extension MainCoordinator {
    private func setupCoordinators() {
        switch coordinatorType {
        case .home:
            self.homeCoordinator = .init(parent: self)
        }
    }
}
