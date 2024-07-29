//
//  WorkScheduler.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import Combine
import Foundation

final class WorkScheduler {

    static var backgroundWorkScheduler: OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 5
        operationQueue.qualityOfService = QualityOfService.userInitiated
        return operationQueue
    }()

    static let mainScheduler = RunLoop.main
    static let mainThread = DispatchQueue.main
}
