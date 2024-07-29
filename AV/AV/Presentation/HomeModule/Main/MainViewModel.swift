//
//  MainViewModel.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import SwiftUI
import Combine
import UIKit

enum Load {
    case onAppear
    case onSaveImage(UIImage)
}

protocol MainViewModelProtocol: ObservableObject, Identifiable {
    var image: UIImage { get set }
    func apply(_ input: Load)
}

final class MainViewModel: AppDefaultViewModel, MainViewModelProtocol {
    
    // MARK: - Publishers

    @Published var image: UIImage = UIImage()
        
    // MARK: Stored Properties
        
    private unowned let coordinator: MainTabCoordinator
    
    // MARK: Initialization

    init(coordinator: MainTabCoordinator) {
        self.coordinator = coordinator
    }
}

// MARK: MainViewModelProtocol methods

extension MainViewModel {
    
}

// MARK: DataFlowProtocol

extension MainViewModel: DataFlowProtocol {
    typealias InputType = Load

    func apply(_ input: Load) {
        switch input {
        case .onAppear: break
        case .onSaveImage(let image):
            saveImageToPhotos(image)
        }
    }
    
    private func saveImageToPhotos(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image,
                                       self,
                                       nil,
                                       nil)
        log("Success! Image saved.")
    }
}
