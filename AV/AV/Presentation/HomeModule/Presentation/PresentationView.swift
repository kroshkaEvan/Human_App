//
//  UnlockView.swift
//  BlackBox
//
//  Created by IvanDev on 15/06/2024.
//

import SwiftUI
    
struct PresentationView<ViewModel>: View where ViewModel: PresentationViewModelProtocol {
    
    @StateObject private var viewModel: ViewModel

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
      self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        VStack {
            Text("Presentation View")

            HStack {
                Button {
                    viewModel.unlock()
                } label: {
                    Text("Enter")
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    PresentationView(viewModel: PresentationViewModel(coordinator: Constants.PreviewMock.homeCoordinator))
}
