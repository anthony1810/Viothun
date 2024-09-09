//
//  Debouncer.swift
//  ViothunSwiftComponents
//
//  Created by Anthony Tran on 18/06/2023.
//

import Combine
import SwiftUI

/// A class that provides a debouncing mechanism, delaying the emission of a value until the input stops changing for a specified delay period.
///
/// Debouncing is useful for limiting the frequency of updates in response to user input or other events. For example, it can prevent a function from being called multiple times in quick succession when unnecessary.
///
/// - Parameters:
///   - T: The type of value to debounce.
public class Debouncer<T>: ObservableObject {
    
    /// The input value that will be debounced.
    @Published var input: T
    
    /// The output value, which is the debounced version of the input.
    @Published var output: T
    
    private var cancellable: AnyCancellable?
    
    /// Initializes the debouncer with an initial value, delay, and a dispatch queue for scheduling.
    ///
    /// - Parameters:
    ///   - initialValue: The initial value for both `input` and `output`.
    ///   - delay: The time interval in seconds to debounce input changes. Defaults to 1 second.
    ///   - queue: The `DispatchQueue` on which the debounce will be scheduled.
    init(initialValue: T, delay: Double = 1, queue: DispatchQueue) {
        self.input = initialValue
        self.output = initialValue
        
        // Set up the debouncing mechanism
        cancellable = $input
            .debounce(for: .seconds(delay), scheduler: queue)
            .sink(receiveValue: { [weak self] in
                self?.output = $0  // Update the output with the debounced input
            })
    }
}
