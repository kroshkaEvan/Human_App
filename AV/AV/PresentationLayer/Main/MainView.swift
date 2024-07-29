//
//  MainView.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import SwiftUI
    
struct MainView<ViewModel>: View where ViewModel: MainViewModelProtocol {
    
    @StateObject private var viewModel: ViewModel

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
      self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        VStack {
            PhotoView(viewModel: viewModel)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    MainView(viewModel: MainViewModel(coordinator: Constants.PreviewMock.mainCoordinator))
}
