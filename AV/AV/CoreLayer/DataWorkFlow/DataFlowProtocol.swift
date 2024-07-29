//
//  DataFlowProtocol.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import Foundation

protocol DataFlowProtocol {
    associatedtype InputType
    func apply(_ input: InputType)
}
