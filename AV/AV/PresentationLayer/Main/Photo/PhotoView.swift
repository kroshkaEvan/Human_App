//
//  PhotoView.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import SwiftUI

struct PhotoView: UIViewControllerRepresentable {
    typealias UIViewControllerType = PhotoViewController
    
    var viewModel: any MainViewModelProtocol
    
    func makeUIViewController(context: Context) -> PhotoViewController {
        PhotoViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: PhotoViewController, context: Context) { }
}
