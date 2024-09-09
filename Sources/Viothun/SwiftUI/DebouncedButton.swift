import Foundation
import SwiftUI
import Combine

/// A button view that triggers an action with a debounce interval.
///
/// The `DebouncedButton` delays the execution of an action to avoid repeated rapid clicks. The action will be performed after the specified debounce interval has passed since the last click.
///
/// - Parameters:
///   - action: The action to be performed when the button is pressed, after the debounce interval.
///   - interval: The time interval to wait between successive actions. Defaults to `0.3` seconds.
///   - receivedOn: The `DispatchQueue` on which to debounce. Defaults to the main queue.
///   - content: The content of the button, defined using a `ViewBuilder`.
public struct DebouncedButton<Content: View>: View {
    
    @StateObject private var debouncer: Debouncer<Void>  // Debouncer to control the timing of button clicks
    
    let action: () -> Void  // The action to perform
    let content: Content  // The content of the button
    let interval: TimeInterval  // Debounce interval
    let receivedOn: DispatchQueue  // The dispatch queue on which debounce is handled

    /// Initializes a `DebouncedButton` with the provided parameters.
    ///
    /// - Parameters:
    ///   - action: The action to be performed when the button is pressed, after the debounce interval.
    ///   - interval: The time interval to wait between successive actions. Defaults to `0.3` seconds.
    ///   - receivedOn: The `DispatchQueue` on which to debounce. Defaults to the main queue.
    ///   - content: A closure that provides the button's content as a `View`.
    init(action: @escaping () -> Void,
         interval: TimeInterval = 0.3,
         receivedOn: DispatchQueue = .main,
         @ViewBuilder content: () -> Content
    ) {
        self.action = action
        self.content = content()
        self.interval = interval
        self.receivedOn = receivedOn
        self._debouncer = StateObject(wrappedValue: Debouncer(initialValue: (), queue: receivedOn))
    }
    
    public var body: some View {
        Button(action: {
            debouncer.input = ()  // Trigger the debouncer when the button is pressed
        }) {
            content  // Display the button content
        }
        .onReceive(debouncer.$output.dropFirst(2)) { _ in
            action()  // Execute the action when debounce completes
        }
    }
}

public extension View {
    
    /// Wraps the view in a debounced button, delaying the execution of the provided action.
    ///
    /// - Parameters:
    ///   - interval: The time interval to debounce between successive actions. Defaults to `0.5` seconds.
    ///   - action: The action to be performed after the debounce interval.
    /// - Returns: A view that wraps the original view in a debounced button.
    func debounced(interval: TimeInterval = 0.5, action: @escaping () -> Void) -> some View {
        DebouncedButton(action: action, interval: interval) { self }
    }
}
