//
//  Toasty.swift
//  KToasty
//
//  Created by KiLuSs 11/20/2023.
//

import UIKit

public final class Toasty {
    
    /// Defines the duration of the toast presentation. (Default is .`short`)
    ///
    /// - short: 2 seconds
    /// - average: 4 seconds
    /// - long: 8 seconds
    /// - custom: A custom duration (usage: `.custom(5.0)`)
    public enum Duration {
        case short
        case average
        case long
        case custom(TimeInterval)
        
        var length: TimeInterval {
            switch self {
            case .short:   return 2.0
            case .average: return 4.0
            case .long:    return 8.0
            case .custom(let timeInterval):
                return timeInterval
            }
        }
    }
    
    public enum Position {
        case top
        case bottom
    }
    
    public enum ShowMode {
        case instantly
        case queue
    }
    
    public enum Style {
        case success
        case info
        case error
    }
    
    public typealias ToastCompletionHandler = (() -> Void)?
    fileprivate weak var sender: UIViewController?
    fileprivate var message: NSMutableAttributedString
    fileprivate var completionHandler: ToastCompletionHandler = nil
    fileprivate let toastView: ToastView
    fileprivate var duration: Duration = .short
    fileprivate var position: Position = .top
    
    /// Initializes a new instance of the Toasty library to display a toast message.
    ///
    /// - Parameters:
    ///   - message: The message to be displayed in the toast.
    ///   - sender: The UIViewController from which the toast should be presented.
    ///   - style: The visual style of the toast, indicating its appearance and purpose. Defaults to .info.
    public init(message: String, sender: UIViewController?, style: Style = .info) {
        self.sender = sender
        self.message = NSMutableAttributedString(string: message)
        self.toastView =  ToastView(message: self.message, style: style)
    }
    
    /// Initializes a new instance of the Toasty library to display a toast message.
    ///
    /// - Parameters:
    ///   - messageAttribuleString: The NSMutableAttributedString message to be displayed in the toast.
    ///   - sender: The UIViewController from which the toast should be presented.
    ///   - style: The visual style of the toast, indicating its appearance and purpose. Defaults to .info.
    public init(messageAttribuleString: NSMutableAttributedString, sender: UIViewController?, style: Style = .info) {
        self.sender = sender
        self.message = messageAttribuleString
        self.toastView =  ToastView(message: message, style: style)
    }

    /// Initializes a new instance of the Toasty library to display a toast message on top of the screen window.
    ///
    /// - Parameters:
    ///   - message: The message to be displayed in the toast.
    ///   - style: The visual style of the toast, indicating its appearance and purpose. Defaults to .info.
    public init(message: String, style: Style = .info) {
        self.message = NSMutableAttributedString(string: message)
        self.toastView = ToastView(message: self.message, style: style)
    }

    /// Initializes a new instance of the Toasty library to display a toast message on top of the screen window.
    ///
    /// - Parameters:
    ///   - messageAttribuleString: The NSMutableAttributedString message to be displayed in the toast.
    ///   - style: The visual style of the toast, indicating its appearance and purpose. Defaults to .info.
    public init(messageAttribuleString: NSMutableAttributedString, style: Style = .info) {
        self.message = messageAttribuleString
        self.toastView = ToastView(message: message, style: style)
    }
    
    /// Show the toast for a specified duration. (Default is `.short`)
    ///
    /// - Parameter duration: Length the toast will be presented
    /// - Parameter showMode: show toast instantly or push it in queue. (Default is `.instantly`)
    /// - Parameter completionHandler: be triggered when all toasts dismissed
    public func show(
        _ showMode: ShowMode = .instantly,
        duration: Duration = .short,
        position: Position = .top,
        completionHandler: ToastCompletionHandler = nil) {
            self.duration = duration
            self.position = position
            self.completionHandler = completionHandler
            
            switch showMode {
            case .instantly:
                ToastManager.shared.clearQueueAndPresent(self)
            case .queue:
                ToastManager.shared.queueAndPresent(self)
            }
        }
}

fileprivate class ToastView: UIView {
    private var messageLabel: UILabel!
    
    init(message: NSMutableAttributedString, style: Toasty.Style) {
        super.init(frame: CGRect.zero)
        configureUI(message: message, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureUI(message: NSMutableAttributedString, style: Toasty.Style) {
        // Customize your toast view's appearance
        
        messageLabel = UILabel(frame: CGRect.zero)
        messageLabel.attributedText = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .natural
        messageLabel.font = UIFont.boldSystemFont(ofSize: 16)
        messageLabel.lineBreakMode = .byTruncatingTail
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(messageLabel)
        
        switch style {
        case .info:
            backgroundColor = UIColor.white
            messageLabel.textColor = UIColor.gray
            layer.shadowColor = UIColor.black.cgColor
        case .success:
            backgroundColor = UIColor(hex: 0x5ec498)
            messageLabel.textColor = UIColor.white
            layer.shadowColor = UIColor(hex: 0x193621).cgColor
        case .error:
            backgroundColor = UIColor(hex: 0xc44d4d)
            messageLabel.textColor = UIColor.white
            layer.shadowColor = UIColor(hex: 0x361919).cgColor
        }
        layer.cornerRadius = 10
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        clipsToBounds = false
    
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}

private protocol ToastDelegate: AnyObject {
    func toastDidDismiss()
}

final fileprivate class ToastManager: ToastDelegate {
    static let shared = ToastManager()
    
    private var queue = Queue<Toasty>()
    private var isPresenting = false
    private var currentToast: Toasty? = nil
    private var currentToastDismissAction: DispatchWorkItem?
    private var toastViewMargin = CGFloat(20)
    
    private lazy var window: UIWindow? = {
        let win: UIWindow
        if #available(iOS 13.0, *),
           let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) {
            win = PassThroughToastWindow(windowScene: windowScene)
        } else {
            win = PassThroughToastWindow(frame: UIScreen.main.bounds)
        }
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindow.Level.alert + 1
        win.backgroundColor = .clear
        win.isHidden = false
        win.isUserInteractionEnabled = true
        return win
    }()
    
    fileprivate func queueAndPresent(_ toast: Toasty) {
        queue.enqueue(toast)
        presentIfPossible()
    }
    
    fileprivate func clearQueueAndPresent(_ toast: Toasty) {
        dismissLatestToast()
        queue.clearQueue()
        queue.enqueue(toast)
        toastDidDismiss()
    }
    
    func dismissLatestToast() {
        // Check if the delayed action is pending and cancel it
        if let dismissAction = currentToastDismissAction, !dismissAction.isCancelled {
            dismissAction.cancel()
            currentToastDismissAction = nil
        }
        if let currentToast = currentToast {
            DispatchQueue.main.async {
                currentToast.toastView.removeFromSuperview()
                currentToast.toastView.superview?.layoutIfNeeded()
            }
        }
        isPresenting = false
    }
    
    func toastDidDismiss() {
        if queue.array.isEmpty && !isPresenting {
            currentToast?.completionHandler?()
        }
        presentIfPossible()
    }
    
    fileprivate func presentIfPossible() {
        guard isPresenting == false, let toast = queue.dequeue() else { return }
        currentToast = toast
        isPresenting = true
        presentToast(toast: toast)
    }
    
    func presentToast(toast: Toasty) {
        let toastView = toast.toastView
        let position = toast.position
        
        let targetView: UIView
        if let sender = toast.sender {
            targetView = sender.view
        } else {
            // Setup window if needed
            if window == nil { _ = window }
            guard let win = window, let root = win.rootViewController?.view else { return }
            targetView = root
        }
        
        var topConstraint = NSLayoutConstraint()
        var bottomConstraint = NSLayoutConstraint()
        let leadingConstraint = toastView.leadingAnchor.constraint(greaterThanOrEqualTo: targetView.leadingAnchor, constant: self.toastViewMargin)
        let trailingConstraint = toastView.trailingAnchor.constraint(lessThanOrEqualTo: targetView.trailingAnchor, constant: -self.toastViewMargin)
        let centerConstraint = toastView.centerXAnchor.constraint(equalTo: targetView.centerXAnchor)
        let widthConstraint = toastView.widthAnchor.constraint(equalToConstant: 0)
        let heightConstraint = toastView.heightAnchor.constraint(equalToConstant: 0)
        
        switch position {
        case .top:
            topConstraint = toastView.topAnchor.constraint(equalTo: targetView.safeAreaLayoutGuide.topAnchor, constant: -40)
            bottomConstraint = toastView.bottomAnchor.constraint(lessThanOrEqualTo: targetView.bottomAnchor, constant: -self.toastViewMargin)
        case .bottom:
            topConstraint = toastView.topAnchor.constraint(greaterThanOrEqualTo: targetView.safeAreaLayoutGuide.topAnchor, constant: self.toastViewMargin)
            bottomConstraint = toastView.bottomAnchor.constraint(equalTo: targetView.safeAreaLayoutGuide.bottomAnchor, constant: 40)
        }
        
        DispatchQueue.main.async {
            
            let dismissAction = DispatchWorkItem {
                centerConstraint.isActive = false
                trailingConstraint.isActive = false
                leadingConstraint.constant = 0
                UIView.animate(withDuration: 0.3, animations: {
                    switch position {
                    case .bottom:
                        bottomConstraint.constant = 40
                    default:
                        topConstraint.constant = -40
                    }
                    
                    widthConstraint.isActive = true
                    heightConstraint.isActive = true
                    targetView.layoutIfNeeded()
                }, completion: { _ in
                    toastView.removeFromSuperview()
                    self.isPresenting = false
                    self.toastDidDismiss()
                })
            }
            
            targetView.addSubview(toastView)
            toastView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                topConstraint,
                bottomConstraint,
                leadingConstraint,
                widthConstraint,
                heightConstraint
            ])
            targetView.layoutIfNeeded()
            NSLayoutConstraint.deactivate([
                widthConstraint,
                heightConstraint
            ])
            trailingConstraint.isActive = true
            centerConstraint.isActive = true
            
            UIView.animate(withDuration: 0.3, animations: {
                switch position {
                case .bottom:
                    bottomConstraint.constant = -self.toastViewMargin
                default:
                    topConstraint.constant = self.toastViewMargin
                }
                targetView.layoutIfNeeded()
            }, completion: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration.length, execute: dismissAction)
                self.currentToastDismissAction = dismissAction
            })
        }
    }
}

private struct Queue<T> {
    fileprivate var array = [T]()
    
    mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    mutating func dequeue() -> T? {
        if array.isEmpty {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    
    mutating func clearQueue() {
        array.removeAll()
    }
}

private class PassThroughToastWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }
        // If the hit view is the window itself or the root view controller's view,
        // (which are transparent), we return nil so that the touch passes through to the window below.
        if hitView == self || hitView == rootViewController?.view {
            return nil
        }
        return hitView
    }
}
