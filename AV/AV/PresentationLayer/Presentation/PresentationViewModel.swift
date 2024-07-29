//
//  UnlockViewModel.swift
//  BlackBox
//
//  Created by IvanDev on 17/06/2024.
//

import SwiftUI
import Combine

protocol PresentationViewModelProtocol: ObservableObject, Identifiable {
    func unlock()
}

final class PresentationViewModel: AppDefaultViewModel, PresentationViewModelProtocol {
    
    // MARK: Stored Properties
        
    private unowned let coordinator: HomeCoordinator
    
    // MARK: Initialization

    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
}

// MARK: PresentationViewModelProtocol methods

extension PresentationViewModel {
    func unlock() {
        coordinator.unlockHome()
    }
}

// MARK: DataFlowProtocol

extension PresentationViewModel: DataFlowProtocol {
    typealias InputType = Load

    enum Load {
        case onAppear
    }

    func apply(_ input: Load) {
        switch input {
        case .onAppear: break
        }
    }
}
