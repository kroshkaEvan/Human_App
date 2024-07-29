//
//  SettingsView.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import SwiftUI
    
struct SettingsView<ViewModel>: View where ViewModel: SettingsViewModelProtocol {
    
    @StateObject private var viewModel: ViewModel

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
      self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        VStack {
            Text("First View")

        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel(coordinator: Constants.PreviewMock.settingsCoordinator))
}
