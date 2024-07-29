//
//  Log.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import Foundation

func log(_ text: String) {
    let thread = Thread.isMainThread ? "main thread" : "other thread"
    print("[\(thread)] / [\(Date())]/n \(text)")
}
