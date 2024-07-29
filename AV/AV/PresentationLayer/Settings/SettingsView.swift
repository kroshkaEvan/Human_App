//
//  SettingsView.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import SwiftUI
    
struct SettingsView<ViewModel>: View where ViewModel: SettingsViewModelProtocol {
    
    @StateObject private var viewModel: ViewModel
    
    @State private var newItemText: String = ""
    
    init(viewModel: @autoclosure @escaping () -> ViewModel) {
      self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.items, id: \.self) { item in
                    Button(item) {
                        viewModel.selectedItem = item
                        viewModel.showAlert = true
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.showAddItemAlert.toggle()
                    } label: {
                        Label("Add", 
                              systemImage: "plus")
                    }
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text(viewModel.selectedItem),
                    message: nil,
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert("Add new item",
                   isPresented: $viewModel.showAddItemAlert,
                   actions: {
                TextField("Name element",
                          text: $newItemText)
                Button("Add", action: {
                    if !newItemText.isEmpty {
                        viewModel.apply(.onAddItem(newItemText))
                        newItemText = ""
                    }
                })
            }, message: {
                Text("Enter name new item")
            })
            .navigationTitle(Constants.Strings.settings)
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel(coordinator: Constants.PreviewMock.settingsCoordinator))
}
