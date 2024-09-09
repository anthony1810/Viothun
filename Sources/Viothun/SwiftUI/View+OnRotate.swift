//
//  View+OnRotate.swift
//
//
//  Created by Anthony on 9/9/24.
//

import Foundation
import SwiftUI

/// A view modifier that triggers an action when the device's orientation changes.
public struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    /// Defines the content and behavior of the modifier.
    ///
    /// - Parameter content: The content view to which the modifier is applied.
    /// - Returns: A view that listens for orientation changes and triggers the action when the device rotates.
    public func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

public extension View {
    
    /// Adds an action to perform when the device's orientation changes.
    ///
    /// - Parameter action: The action to perform when the device rotates, receiving the new `UIDeviceOrientation`.
    /// - Returns: A modified view that triggers the action on device rotation.
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        modifier(DeviceRotationViewModifier(action: action))
    }
}
