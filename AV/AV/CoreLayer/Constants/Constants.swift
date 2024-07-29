//
//  Constants.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import Foundation

enum Constants {
    
    enum KernelName {
        static let grayscale: String = "grayscaleKernel"
    }
    
    enum Title { }
    
    enum Strings {
        static let main = "Main"
        static let settings = "Settings"
        static let testPDF = "TestTask"
        static let colour = "Colour"
        static let dark = "Black/White"
    }
    
    enum PreviewMock {
        static let homeCoordinator = HomeCoordinator(parent: MainCoordinator())
        static let settingsCoordinator = SettingsTabCoordinator(parent: HomeCoordinator(parent: MainCoordinator()))
        static let mainCoordinator = MainTabCoordinator(parent: HomeCoordinator(parent: MainCoordinator()))
    }
}
