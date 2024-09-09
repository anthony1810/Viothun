# Viothun

A collection of Swift utilities and extensions for building scalable, maintainable, and efficient iOS applications.

## Table of Contents

### 1. Combine Extensions
   - [Debouncer](#debouncer)
   - [Publisher Extensions](#publisher-extensions)

### 2. Services
   - [DebugLogger](#debuglogger)

### 3. SwiftUI Extensions
   - [Debounced Button](#debounced-button)
   - [View+If](#view-if)
   - [View+OnRotate](#view-onrotate)
   - [ViewModifiers+OnFirstViewAppear](#viewmodifiers-onfirstviewappear)

### 4. UIKit Extensions
   - [Comparable+Extensions](#comparable-extensions)
   - [Date+Extensions](#date-extensions)
   - [Optional+Extensions](#optional-extensions)
   - [RandomAccessCollection+Extensions](#randomaccesscollection-extensions)
   - [Sequence+Extensions](#sequence-extensions)
   - [String+Extensions](#string-extensions)
   - [UIColor+Extensions](#uicolor-extensions)
   - [UIDevice+Extensions](#uidevice-extensions)
   - [UIImage+Extensions](#uiimage-extensions)

---

## 1. Combine Extensions

### Debouncer
The `Debouncer` class provides a debouncing mechanism to prevent excessive triggering of actions over a short period.

- **File**: `Sources/Viothun/Combine/Debouncer.swift`
- **Details**:
  - Debounces input and delays output until the input stops changing for a specified delay.

### Publisher Extensions
These extensions provide various utilities for `Combine.Publisher`.

- **File**: `Sources/Viothun/Combine/Publishers+Extensions.swift`
- **Available Functions**:
  - `any`: Type-erases the publisher to `AnyPublisher`.
  - `mapToVoid`: Maps the output to `Void`.
  - `mapToTrue`: Maps the output to `true`.
  - `mapToFalse`: Maps the output to `false`.
  - `onCompletion`: Attaches a completion handler to the publisher.
  - `singleOutput`: Waits for the publisher to produce a single output asynchronously.

---

## 2. Services

### DebugLogger
`DebugLogger` is a customizable logging system that supports multiple logging contexts, log levels, and location information.

- **File**: `Sources/Viothun/Services/DebugLogger.swift`
- **Available Functions**:
  - `enable(_:)`: Enables logging for a specific context.
  - `disable(_:)`: Disables logging for a specific context.
  - `log(_:message:newLine:level:showLocationOverride:file:line:function:)`: Logs a message with optional location information.
  - `logTitle(_:title:newLine:isStart:level:showLocationOverride:file:line:function:)`: Logs a start or end title.
  - `logMultiLine(_:message:newLine:level:showLocationOverride:file:line:function:)`: Logs a multi-line message.

---

## 3. SwiftUI Extensions

### Debounced Button
A custom SwiftUI button view that triggers an action with a debounce interval.

- **File**: `Sources/Viothun/SwiftUI/DebouncedButton.swift`
- **Available Functions**:
  - `DebouncedButton`: A button view that prevents excessive button taps by debouncing.

### View+If
This extension applies a transformation to a view conditionally, based on a boolean value.

- **File**: `Sources/Viothun/SwiftUI/View+If.swift`
- **Available Functions**:
  - `if(_:transform:)`: Conditionally applies a transformation to a view.

### View+OnRotate
This extension detects device orientation changes and triggers a specified action.

- **File**: `Sources/Viothun/SwiftUI/View+OnRotate.swift`
- **Available Functions**:
  - `onRotate(perform:)`: Executes an action when the device orientation changes.

### ViewModifiers+OnFirstViewAppear
Executes an action only when the view appears for the first time.

- **File**: `Sources/Viothun/SwiftUI/ViewModifiers+OnFirstViewAppear.swift`
- **Available Functions**:
  - `onFirstViewAppear(perform:)`: Executes an action the first time a view appears.

---

## 4. UIKit Extensions

### Comparable+Extensions
Provides a method to clamp values within a range.

- **File**: `Sources/Viothun/UIKit/Comparable+Extensions.swift`
- **Available Functions**:
  - `clamp(to:)`: Clamps a value to a specified range.

### Date+Extensions
Utilities for manipulating and formatting `Date` objects.

- **File**: `Sources/Viothun/UIKit/Date+Extensions.swift`
- **Available Functions**:
  - `adding100Years()`: Adds 100 years to the current date.
  - `addMoreTime(component:value:)`: Adds a specified time component and value to the current date.
  - `formattedString`: Returns the date formatted as a string.
  - `adjustDateTime(from:baseDate:)`: Adjusts a base date by adding or subtracting time.

### Optional+Extensions
Provides default values for `Optional` types.

- **File**: `Sources/Viothun/UIKit/Optional+Extensions.swift`
- **Available Functions**:
  - `orBlank`: Returns the wrapped string or an empty string.
  - `orBlackHex`: Returns the wrapped string or a default black hex value.
  - `orZero`: Returns the wrapped integer or 0.
  - `orFalse`: Returns the wrapped boolean or `false`.

### RandomAccessCollection+Extensions
Safely access elements in a `RandomAccessCollection` by index, returning `nil` if out of bounds.

- **File**: `Sources/Viothun/UIKit/RandomAccessCollection+Extensions.swift`
- **Available Functions**:
  - `subscript(safe:)`: Safely accesses an element at a specified index.

### Sequence+Extensions
Utilities for working with sequences, such as updating, sorting, and removing duplicates.

- **File**: `Sources/Viothun/UIKit/Sequence+Extensions.swift`
- **Available Functions**:
  - `updating(with:)`: Updates a sequence with a new sequence of elements.
  - `sorted(using:)`: Sorts a sequence using sort descriptors.
  - `sorted(alwaysFirst:)`: Sorts a sequence, ensuring a specific element appears first.
  - `uniqued()`: Removes duplicate elements from a sequence.

### String+Extensions
Utilities for manipulating strings, including date conversions and validation.

- **File**: `Sources/Viothun/UIKit/String+Extensions.swift`
- **Available Functions**:
  - `toDate`: Converts a string to a `Date`.
  - `isValidEmailAddress`: Returns `true` if the string is a valid email address.
  - `toInt()`: Converts a string to an integer.

### UIColor+Extensions
Utilities for creating `UIColor` objects from hex strings and RGB values.

- **File**: `Sources/Viothun/UIKit/UIColor+Extensions.swift`
- **Available Functions**:
  - `init(hexString:)`: Initializes a `UIColor` from a hex string.
  - `init(rgbValue:)`: Initializes a `UIColor` from an RGB integer value.
  - `color`: Converts the `UIColor` to a SwiftUI `Color`.

### UIDevice+Extensions
Utility properties to check the type of device (iPhone, iPad, etc.).

- **File**: `Sources/Viothun/UIKit/UIDevice+Extensions.swift`
- **Available Functions**:
  - `isPhone`: Returns `true` if the device is an iPhone.
  - `isPad`: Returns `true` if the device is an iPad.
  - `isTV`: Returns `true` if the device is an Apple TV.
  - `isCarPlay`: Returns `true` if the device is using CarPlay.

### UIImage+Extensions
Provides methods for resizing and rotating `UIImage` instances.

- **File**: `Sources/Viothun/UIKit/UIImage+Extensions.swift`
- **Available Functions**:
  - `resized(withPercentage:isOpaque:)`: Resize the image by a given percentage.
  - `rotated(byDegrees:)`: Rotate the image by a specified number of degrees.

---

## 5. Tests

- **Tests for Viothun components**: Located in the `Tests/ViothunTests` directory.

---

This README provides a structured and detailed explanation of the components in your package, organized in categories like `Combine`, `Services`, `SwiftUI`, and `UIKit`, with links to the relevant files.
