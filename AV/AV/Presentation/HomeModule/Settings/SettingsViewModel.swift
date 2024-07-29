//
//  SettingsViewModel.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import SwiftUI
import Combine

protocol SettingsViewModelProtocol: ObservableObject, Identifiable {
    
}

final class SettingsViewModel: AppDefaultViewModel, SettingsViewModelProtocol {
    
    // MARK: Stored Properties
        
    private unowned let coordinator: SettingsTabCoordinator
    
    // MARK: Initialization

    init(coordinator: SettingsTabCoordinator) {
        self.coordinator = coordinator
    }
}

// MARK: SettingsViewModelProtocol methods

extension SettingsViewModel {
    
}

// MARK: DataFlowProtocol

extension SettingsViewModel: DataFlowProtocol {
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
