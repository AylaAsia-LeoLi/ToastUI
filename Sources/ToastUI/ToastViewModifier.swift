//
//  ToastViewModifier.swift
//  ToastUI
//
//  Created by Quan Tran on 7/17/20.
//

import SwiftUI

#if os(iOS) || os(tvOS)
struct ToastViewIsPresentedModifier<QTContent>: ViewModifier where QTContent: View {
  @Binding var isPresented: Bool
  let dismissAfter: Double?
  let onDismiss: (() -> Void)?
  let content: () -> QTContent
  let isBgClear: Bool
  @State private var keyWindow: UIWindow?
  @State private var hostingVC: UIViewController?
  @State private var currentWindow: UIWindow?

  private func present() {
    if keyWindow == nil {
      keyWindow = UIApplication.shared.windows.first(where: \.isKeyWindow)
    }

    if isPresented {
      if currentWindow == nil {
        if let windowScene = keyWindow?.windowScene {
        currentWindow = UIWindow(windowScene: windowScene)
        currentWindow?.rootViewController = ToastViewHostingController(rootView: content())
        currentWindow?.windowLevel = .alert
        currentWindow?.makeKeyAndVisible()
        }
      } else {
        currentWindow?.rootViewController = ToastViewHostingController(rootView: content())
        currentWindow?.windowLevel = .alert
        currentWindow?.makeKeyAndVisible()
      }
      // 带倒计时的不是hud 添加背景颜色
      if let dismissAfter = dismissAfter {
        currentWindow?.backgroundColor = isBgClear ? .clear : UIColor.black.withAlphaComponent(0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter) {
          isPresented = false
        }
      } else {
        currentWindow?.backgroundColor =  UIColor.black.withAlphaComponent(0.5)
      }
    } else {
      currentWindow?.resignKey()
      currentWindow?.isHidden = true
      currentWindow = nil
    }

//
//    var rootViewController = keyWindow?.rootViewController
//    while true {
//      if let presented = rootViewController?.presentedViewController {
//        rootViewController = presented
//      } else if let navigationController = rootViewController as? UINavigationController {
//        rootViewController = navigationController.visibleViewController
//      } else if let tabBarController = rootViewController as? UITabBarController {
//        rootViewController = tabBarController.selectedViewController
//      } else {
//        break
//      }
//    }
//
//    let toastAlreadyPresented = rootViewController is ToastViewHostingController<QTContent>
//
//    if isPresented {
//      if !toastAlreadyPresented {
//        let toastViewController = ToastViewHostingController(rootView: content())
//        rootViewController?.present(toastViewController, animated: true)
//
//        if let dismissAfter = dismissAfter {
//          hostingVC = toastViewController
//          DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter) {
//            isPresented = false
//          }
//        }
//      }
//    } else {
//      if toastAlreadyPresented {
//        rootViewController?.dismiss(animated: true, completion: onDismiss)
//      } else {
//        hostingVC?.dismiss(animated: true, completion: onDismiss)
//        hostingVC = nil
//      }
//      keyWindow = nil
//    }
  }

  func body(content: Content) -> some View {
    content
      .onChange(of: isPresented) { _ in
        present()
      }
  }
}
#endif

#if os(macOS)
struct ToastViewIsPresentedModifier<QTContent>: ViewModifier where QTContent: View {
  @Binding var isPresented: Bool
  let dismissAfter: Double?
  let onDismiss: (() -> Void)?
  let content: () -> QTContent

  @State private var keyWindow: NSWindow?

  private func present() {
    if keyWindow == nil {
      keyWindow = NSApplication.shared.windows.first(where: \.isKeyWindow)
    }
    let rootViewController = keyWindow?.contentViewController
    let presentingToastViewController = rootViewController?.presentedViewControllers?
      .first(where: { $0 is ToastViewHostingController<QTContent> })
    let toastAlreadyPresented = presentingToastViewController != nil

    if isPresented {
      if !toastAlreadyPresented {
        let toastViewController = ToastViewHostingController(rootView: content())
        rootViewController?.presentAsSheet(toastViewController)

        if let dismissAfter = dismissAfter {
          DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter) {
            isPresented = false
          }
        }
      }
    } else {
      if toastAlreadyPresented {
        (presentingToastViewController as? ToastViewHostingController<QTContent>)?
          .dismissWithCompletion(onDismiss)
      }
      keyWindow = nil
    }
  }

  func body(content: Content) -> some View {
    content
      .onChange(of: isPresented) { _ in
        present()
      }
  }
}
#endif

#if os(iOS) || os(tvOS)
struct ToastViewItemModifier<Item, QTContent>: ViewModifier
where Item: Identifiable & Equatable, QTContent: View {
  @Binding var item: Item?
  let dismissAfter: Double?
  let onDismiss: (() -> Void)?
  let content: (Item) -> QTContent

  @State private var keyWindow: UIWindow?

  private func present() {
    if keyWindow == nil {
      keyWindow = UIApplication.shared.windows.first(where: \.isKeyWindow)
    }
    var rootViewController = keyWindow?.rootViewController
    while true {
      if let presented = rootViewController?.presentedViewController {
        rootViewController = presented
      } else if let navigationController = rootViewController as? UINavigationController {
        rootViewController = navigationController.visibleViewController
      } else if let tabBarController = rootViewController as? UITabBarController {
        rootViewController = tabBarController.selectedViewController
      } else {
        break
      }
    }

    let toastAlreadyPresented = rootViewController is ToastViewHostingController<QTContent>

    if item != nil {
      if !toastAlreadyPresented {
        if let item = item {
          let toastViewController = ToastViewHostingController(rootView: content(item))
          rootViewController?.present(toastViewController, animated: true)

          if let dismissAfter = dismissAfter {
            DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter) {
              self.item = nil
            }
          }
        }
      } else {
        print(
          """
          [ToastUI] Attempted to present toast while another toast is being presented. \
          This is an undefined behavior and will result in view presentation failures.
          """
        )
      }
    } else {
      if toastAlreadyPresented {
        rootViewController?.dismiss(animated: true, completion: onDismiss)
      }
      keyWindow = nil
    }
  }

  func body(content: Content) -> some View {
    content
      .onChange(of: item) { _ in
        present()
      }
  }
}
#endif

#if os(macOS)
struct ToastViewItemModifier<Item, QTContent>: ViewModifier
where Item: Identifiable & Equatable, QTContent: View {
  @Binding var item: Item?
  let dismissAfter: Double?
  let onDismiss: (() -> Void)?
  let content: (Item) -> QTContent

  @State private var keyWindow: NSWindow?

  private func present() {
    if keyWindow == nil {
      keyWindow = NSApplication.shared.windows.first(where: \.isKeyWindow)
    }
    let rootViewController = keyWindow?.contentViewController
    let presentingToastViewController = rootViewController?.presentedViewControllers?
      .first(where: { $0 is ToastViewHostingController<QTContent> })
    let toastAlreadyPresented = presentingToastViewController != nil

    if item != nil {
      if !toastAlreadyPresented {
        if let item = item {
          let toastViewController = ToastViewHostingController(rootView: content(item))
          rootViewController?.presentAsSheet(toastViewController)

          if let dismissAfter = dismissAfter {
            DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter) {
              self.item = nil
            }
          }
        }
      } else {
        print(
          """
          [ToastUI] Attempted to present toast while another toast is being presented. \
          This is an undefined behavior and will result in view presentation failures.
          """
        )
      }
    } else {
      if toastAlreadyPresented {
        (presentingToastViewController as? ToastViewHostingController<QTContent>)?
          .dismissWithCompletion(onDismiss)
      }
      keyWindow = nil
    }
  }

  func body(content: Content) -> some View {
    content
      .onChange(of: item) { _ in
        present()
      }
  }
}
#endif

#if os(iOS)
struct VisualEffectViewModifier: ViewModifier {
  var blurStyle: UIBlurEffect.Style
  var vibrancyStyle: UIVibrancyEffectStyle?
  var blurIntensity: CGFloat?

  func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(
        VisualEffectView(
          blurStyle: blurStyle,
          vibrancyStyle: vibrancyStyle,
          blurIntensity: blurIntensity
        )
        .edgesIgnoringSafeArea(.all)
      )
  }
}
#endif

#if os(tvOS)
struct VisualEffectViewModifier: ViewModifier {
  var blurStyle: UIBlurEffect.Style
  var blurIntensity: CGFloat?

  func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(
        VisualEffectView(
          blurStyle: blurStyle,
          blurIntensity: blurIntensity
        )
        .edgesIgnoringSafeArea(.all)
      )
  }
}
#endif

#if os(macOS)
struct VisualEffectViewModifier: ViewModifier {
  var material: NSVisualEffectView.Material
  var blendingMode: NSVisualEffectView.BlendingMode
  var state: NSVisualEffectView.State

  func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(
        VisualEffectView(
          material: material,
          blendingMode: blendingMode,
          state: state
        )
        .edgesIgnoringSafeArea(.all)
      )
  }
}
#endif
