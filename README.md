# KToasty

[![CI Status](https://img.shields.io/travis/Lê Văn Sơn/KToasty.svg?style=flat)](https://travis-ci.org/kiluss2/KToasty)
[![Version](https://img.shields.io/cocoapods/v/KToasty.svg?style=flat)](https://cocoapods.org/pods/KToasty)
[![License](https://img.shields.io/cocoapods/l/KToasty.svg?style=flat)](https://cocoapods.org/pods/KToasty)
[![Platform](https://img.shields.io/cocoapods/p/KToasty.svg?style=flat)](https://cocoapods.org/pods/KToasty)

## Introduction

KToasty is a lightweight and customizable toast library for iOS applications. It provides a simple way to display informative messages in your app.

## Requirements

- iOS 12.0+

## Installation

KToasty is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KToasty'
```

## Usage

### 1. Show via Window Overlay (New in 1.1.0)
The recommended way to show toasts without depending on a specific `UIViewController`. It creates a pass-through window on top of everything.

```swift
import KToasty

// Simple string
Toasty(message: "Hello World!").show()

// With custom style
Toasty(message: "Success Message", style: .success).show()
```

### 2. Show via View Controller (Traditional)
If you want the toast to be contained within a specific view controller's bounds.

```swift
import KToasty

let toasty = Toasty(message: "Hello World!", sender: self)
toasty.show()
```

### 3. Using Attributed Strings
You can use `NSMutableAttributedString` to include icons or rich text:
```swift
import KToasty

let attrString = NSMutableAttributedString(string: "Hi world! ")

let imageAttachment = NSTextAttachment()
imageAttachment.image = UIImage(named: "wave")
imageAttachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20)
attrString.append(NSAttributedString(attachment: imageAttachment))

// Via Window
Toasty(messageAttribuleString: attrString).show()

// Or via ViewController
Toasty(messageAttribuleString: attrString, sender: self).show()
```

### 4. Customization Options

#### Duration and Style
Available styles: `.info` (default), `.success`, `.error`.
Available durations: `.short` (2s), `.average` (4s), `.long` (8s), `.custom(TimeInterval)`.

```swift
let toasty = Toasty(message: "Customized Toast", style: .error)
toasty.show(duration: .long)
```

#### Position
Toasts can appear at the `.top` (default) or `.bottom` of the screen.

```swift
Toasty(message: "Bottom Toast").show(position: .bottom)
```

#### Show Mode (Queue)
By default, toasts show `.instantly` (dismissing the current one). Use `.queue` to wait for previous toasts to finish.

```swift
Toasty(message: "Toast 1").show(.queue)
Toasty(message: "Toast 2").show(.queue)
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

Lê Văn Sơn, 69423922+kiluss2@users.noreply.github.com

## License

KToasty is available under the MIT license. See the LICENSE file for more info.
