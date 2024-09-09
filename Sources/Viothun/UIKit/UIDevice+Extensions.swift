//
//  UIDevice+Extensions.swift
//  ViothunSwiftComponents
//
//  Created by Anthony Tran on 18/06/2023.
//

import UIKit

public extension UIDevice {

    /// A Boolean value indicating whether the current device is an iPhone.
    ///
    /// - Returns: `true` if the current device is an iPhone, otherwise `false`.
    class var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }

    /// A Boolean value indicating whether the current device is an iPad.
    ///
    /// - Returns: `true` if the current device is an iPad, otherwise `false`.
    class var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    /// A Boolean value indicating whether the current device is an Apple TV.
    ///
    /// - Returns: `true` if the current device is an Apple TV, otherwise `false`.
    class var isTV: Bool {
        return UIDevice.current.userInterfaceIdiom == .tv
    }

    /// A Boolean value indicating whether the current device is running CarPlay.
    ///
    /// - Returns: `true` if the current device is running CarPlay, otherwise `false`.
    class var isCarPlay: Bool {
        return UIDevice.current.userInterfaceIdiom == .carPlay
    }
}
