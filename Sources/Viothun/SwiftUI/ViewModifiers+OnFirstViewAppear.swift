//
//  OnFirstAppearModifier.swift
//  ViothunSwiftComponents
//
//  Created by Anthony Tran on 18/06/2023.
//

import SwiftUI

/// A view modifier that triggers an action only when the view appears for the first time.
public struct OnFirstViewAppear: ViewModifier {
    
    @State private var hasAppeared: Bool = false
    let perform: () -> Void
    
    /// Defines the content and behavior of the modifier.
    ///
    /// - Parameter content: The content view to which the modifier is applied.
    /// - Returns: A view that triggers the action on the first appearance of the view.
    public func body(content: Content) -> some View {
        content
            .onAppear {
                guard !hasAppeared else { return }
                hasAppeared = true
                perform()
            }
    }
}

public extension View {
    
    /// Adds an action to perform when the view appears for the first time.
    ///
    /// - Parameter perform: The action to perform when the view first appears.
    /// - Returns: A modified view that triggers the action on the first appearance.
    func onFirstViewAppear(perform: @escaping () -> Void) -> some View {
        modifier(OnFirstViewAppear(perform: perform))
    }
}
