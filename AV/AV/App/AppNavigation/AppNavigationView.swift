//
//  AppNavigationView.swift
//  AV
//
//  Created by IvanDev on 29/07/2024.
//

import SwiftUI

struct AppNavigationView<Content: View>: View {
            
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack {
            content
        }
        .dynamicTypeSize(.medium ... .xLarge)
        .onAppear {
            let appearance = UINavigationBarAppearance()

            appearance.configureWithOpaqueBackground()

            appearance.titleTextAttributes = [.foregroundColor: Color.black]
            
            let backItemAppearance = UIBarButtonItemAppearance()
            backItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
            appearance.backButtonAppearance = backItemAppearance
            
            let image = UIImage(systemName: "arrow.backward")?.withTintColor(.black, renderingMode: .alwaysOriginal)
            appearance.setBackIndicatorImage(image, transitionMaskImage: image)
            appearance.backgroundColor = .clear
            appearance.shadowColor = .clear
            
            UINavigationBar.appearance().tintColor = .black
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
        }
        .buttonStyle(PlainButtonStyle())
    }
}
