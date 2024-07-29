//
//  AppDefaultViewModel.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import Foundation
import Combine
import SwiftUI

enum ViewModelStatus: Equatable {
    case loadStart
    case dismissAlert
    case emptyStateHandler(title: String)
}

protocol BaseViewModelEventSource: AnyObject {
    var loadingState: CurrentValueSubject<ViewModelStatus, Never> { get }
}

protocol ViewModelService: AnyObject { }

typealias BaseViewModel = BaseViewModelEventSource & ViewModelService

open class AppDefaultViewModel: BaseViewModel, ObservableObject {

    var loadingState = CurrentValueSubject<ViewModelStatus, Never>(.dismissAlert)
    let subscriber = Cancelable()
    
}
