//
//  SettingsViewModel.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import SwiftUI
import Combine

enum SettingsLoad {
    case onAddItem(String)
}

protocol SettingsViewModelProtocol: ObservableObject, Identifiable {
    var items: [String] {get set}
    var showAlert: Bool {get set}
    var showAddItemAlert: Bool {get set}
    var selectedItem: String {get set}
    func apply(_ input: SettingsLoad)
}

final class SettingsViewModel: AppDefaultViewModel, SettingsViewModelProtocol {
    
    // MARK: - Publishers

    @Published var items: [String] = ["About app"]
    @Published var showAlert = false
    @Published var showAddItemAlert = false
    @Published var selectedItem: String = ""
    
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
    typealias InputType = SettingsLoad

    func apply(_ input: SettingsLoad) {
        switch input {
        case .onAddItem(let item): addItem(item)
        }
    }
    
    private func addItem(_ item: String) {
        showAddItemAlert = true
        items.append(item)
    }
}
