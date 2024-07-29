//
//  UnlockView.swift
//  BlackBox
//
//  Created by IvanDev on 15/06/2024.
//

import SwiftUI
    
struct PresentationView<ViewModel>: View where ViewModel: PresentationViewModelProtocol {
    
    @StateObject private var viewModel: ViewModel
    
    private let webView = AppWebView()

    init(viewModel: @autoclosure @escaping () -> ViewModel) {
      self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        contentView
            .eraseToAnyView()
            .onViewDidLoad {
                webView.loadURL(urlString: Constants.Strings.testPDF)
            }
    }
    
    var contentView: some View {
        VStack {
            Spacer()
            
            Text("HumanApps")
            
            Text("Ivan Tsvetkov")
            
            webView
            
            Button {
                viewModel.unlock()
            } label: {
                Text("Open task")
            }
            
            Spacer()
        }
    }
}

#Preview {
    PresentationView(viewModel: PresentationViewModel(coordinator: Constants.PreviewMock.homeCoordinator))
}
