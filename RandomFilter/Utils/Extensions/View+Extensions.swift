//
//  View+Utils.swift
//  iWidget
//
//  Created by Anh Pham on 9/25/20.
//

import SwiftUI
 
// MARK: - LeadingAlignmentModifier

struct LeadingAlignmentModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            content
            Spacer(minLength: 0)
        }
    }
}

extension View {
    func leadingAlignment() -> some View {
        modifier(LeadingAlignmentModifier())
    }
}

// MARK: - TrailingAlignmentModifier

struct TrailingAlignmentModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            content
        }
    }
}

extension View {
    func trailingAlignment() -> some View {
        modifier(TrailingAlignmentModifier())
    }
}

// MARK: - HCenterAlignmentModifier

struct HCenterAlignmentModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            Spacer(minLength: 0)
            content
            Spacer(minLength: 0)
        }
    }
}

extension View {
    func horizontalCenterAlignment() -> some View {
        modifier(HCenterAlignmentModifier())
    }
}

// MARK: - TopAlignmentModifier

struct TopAlignmentModifier: ViewModifier {
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
            Spacer(minLength: 0)
        }
    }
}

extension View {
    func topAlignment() -> some View {
        modifier(TopAlignmentModifier())
    }
}

// MARK: - BottomAlignmentModifier

struct BottomAlignmentModifier: ViewModifier {
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            Spacer(minLength: 0) 
            content
        }
    }
}

extension View {
    func bottomAlignment() -> some View {
        modifier(BottomAlignmentModifier())
    }
}

// MARK: - MultilineModifier

struct MultilineModifier: ViewModifier {
    let lineLimit: Int?
    
    func body(content: Content) -> some View {
        content.lineLimit(lineLimit)
            .fixedSize(horizontal: false, vertical: true)
    }
}

extension View {
    func multiline(lineLimit: Int? = nil) -> some View {
        modifier(MultilineModifier(lineLimit: lineLimit))
    }
}

// MARK: - Debug
extension View {
    func debugView(_ action: () -> Void) -> some View {
        action()
        return EmptyView()
    }
}

// MARK: - ClearButtonModifier
fileprivate struct ClearButtonModifier: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            
            Button(action: {
                text = ""
            }) {
                Image(systemName: "multiply.circle.fill")
                    .foregroundColor(.secondary)
                    .frame(width: 30, height: 30)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

extension View {
    func clearButton(text: Binding<String>) -> some View {
        modifier(ClearButtonModifier(text: text))
    }
}

// MARK: - DismissingKeyboard

struct DismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture(count: 2, perform: {})
            .onLongPressGesture(minimumDuration: 0, maximumDistance: 0, pressing: nil) {
                let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
                keyWindow?.endEditing(true)
        }
    }
}

struct VerticalScrollView: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                content
                    .frame(minHeight: geometry.size.height)
            }
        }
    }
}

struct HorizontalScrollView: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                content
            }
        }
    }
}

extension View {
    func verticalScroll() -> some View {
        return modifier(VerticalScrollView())
    }
    
    func horizontalScroll() -> some View {
        return modifier(HorizontalScrollView())
    }
}

extension View {
    func dismissKeyboardOnTap() -> some View {
        return modifier(DismissingKeyboard())
    }
}

// MARK: - ViewDidLoadModifier
struct ViewDidLoadModifier: ViewModifier {
    @State private var isViewDidLoad = false
    private let action: (() -> Void)

    init(perform action: @escaping (() -> Void)) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if isViewDidLoad == false {
                isViewDidLoad = true
                action()
            }
        }
    }
}

extension View {
    func onLoad(perform action: @escaping (() -> Void)) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
}

// MARK: - View Extensions
extension View {
    func syncBinding<T: Equatable>(
        source: Binding<T>,
        destination: Binding<T>
    ) -> some View {
        self
            .onChange(of: source.wrappedValue) { oldValue, newValue in
                destination.wrappedValue = newValue
            }
            .onChange(of: destination.wrappedValue) { oldValue, newValue in
                source.wrappedValue = newValue
            }
    }
}

extension View {
    @ViewBuilder
    func applyIf<T: View>(_ condition: Bool,
                          transform: (Self) -> T) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
