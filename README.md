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

Display a Simple Toast
To display a simple toast message, instantiate a Toasty object and call the show method:
```swift
import KToasty

let toasty = Toasty(message: "Hello World!", sender: self)
toasty.show()
```
You can also use NSMutableAttributedString to add some icon for ex:
```swift
import KToasty

let attrString = NSMutableAttributedString(string:"Hi world!")

let imageAttachment = NSTextAttachment()
imageAttachment.image = UIImage(name: "wave")
imageAttachment.bounds = CGRect(x: 0, y: -8, width: 25, height: 25)
let imageString = NSAttributedString(attachment: imageAttachment)
attrString.append(imageString)

Toasty(messageAttribuleString: attrString, sender: self).show()
```
### Customize Toast Duration and Style
You can customize the duration of the toast and its visual style:
```swift
let toasty = Toasty(message: "Customized Toast", sender: self, style: .success)
toasty.show(duration: .long)
```
### Specify Toast Position
You can specify whether the toast should appear at the top or bottom of the screen:

```swift
let toasty = Toasty(message: "Top Toast", sender: self)
toasty.show(position: .top)
```
### Show Toast in Queue
To show toasts in a queue, use the ShowMode.queue option:

```swift
let toasty1 = Toasty(message: "Toast 1", sender: self)
let toasty2 = Toasty(message: "Toast 2", sender: self)

toasty1.show(showMode: .queue)
toasty2.show(showMode: .queue)
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

Lê Văn Sơn, 69423922+kiluss2@users.noreply.github.com

## License

KToasty is available under the MIT license. See the LICENSE file for more info.
