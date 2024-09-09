//
//  File 2.swift
//
//
//  Created by Anthony on 9/9/24.
//

import Foundation
import Combine

/// An error type representing issues with Combine publishers.
public enum CombineError: Error {
    case missingOutput  // Thrown when a publisher completes without providing any output.
}

public extension Publisher {
    
    /// Erases the publisher's type to `AnyPublisher`.
    ///
    /// This can be used when you want to hide the underlying publisher's type and only expose an abstract publisher.
    ///
    /// - Returns: A type-erased publisher.
    var any: AnyPublisher<Output, Failure> { eraseToAnyPublisher() }

    /// Maps the publisher's output to `Void`.
    ///
    /// This is useful when you don't care about the actual output of the publisher and only care that it completed.
    ///
    /// - Returns: A publisher that outputs `Void`.
    func mapToVoid() -> Publishers.Map<Self, Void> {
        map { _ in }
    }

    /// Maps the publisher's output to `true`.
    ///
    /// - Returns: A publisher that always outputs `true`.
    func mapToTrue() -> Publishers.Map<Self, Bool> {
        map { _ in true }
    }

    /// Maps the publisher's output to `false`.
    ///
    /// - Returns: A publisher that always outputs `false`.
    func mapToFalse() -> Publishers.Map<Self, Bool> {
        map { _ in false }
    }

    /// Attaches a completion handler to the publisher.
    ///
    /// This method allows you to attach a custom completion handler to handle the `Subscribers.Completion` event.
    ///
    /// - Parameter receiveCompletion: A closure that handles the completion event.
    /// - Returns: A cancellable instance that represents the attached completion handler.
    func onCompletion(
        _ receiveCompletion: @escaping ((Subscribers.Completion<Self.Failure>) -> Void)
    ) -> AnyCancellable {
        sink(receiveCompletion: receiveCompletion, receiveValue: { _ in })
    }

    /// Waits for the publisher to produce a single output and returns it asynchronously.
    ///
    /// This method is useful when you need to retrieve a value from a publisher asynchronously using the new Swift concurrency model.
    ///
    /// - Throws: `CombineError.missingOutput` if the publisher finishes without producing any output.
    /// - Returns: The output value of the publisher.
    func singleOutput() async throws -> Output {
        var cancellable: AnyCancellable?
        var didReceiveValue = false

        return try await withCheckedThrowingContinuation { continuation in
            cancellable = sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .finished:
                        if !didReceiveValue {
                            continuation.resume(throwing: CombineError.missingOutput)
                        }
                    }
                },
                receiveValue: { value in
                    guard !didReceiveValue else { return }

                    didReceiveValue = true
                    cancellable?.cancel()
                    continuation.resume(returning: value)
                }
            )
        }
    }
}
