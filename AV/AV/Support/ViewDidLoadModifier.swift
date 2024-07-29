//
//  ViewDidLoadModifier.swift
//  AV
//
//  Created by IvanDev on 29/07/2024.
//

import SwiftUI

public struct ViewDidLoadModifier: ViewModifier {

    @State private var viewDidLoad = false
    let action: (() -> Void)?

    public func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    action?()
                }
            }
    }
}

public extension View {
    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(ViewDidLoadModifier(action: action))
            .onTapGesture {
                self.endEditing()
            }
    }

    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
    
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil,
                                        from: nil,
                                        for: nil)
    }
}

extension Identifiable where ID: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
