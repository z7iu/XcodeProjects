//
//  LiquidGlass.swift
//  XcodeProjects
//

import SwiftUI

enum LiquidGlass {
    static var isAvailable: Bool {
        if #available(macOS 26.0, *) {
            return true
        }
        return false
    }

    static let cornerRadius: CGFloat = 12
}

extension View {
    /// macOS 26 以下不做任何处理
    @ViewBuilder
    func glass<S: Shape>(in shape: S, interactive: Bool = false) -> some View {
        if #available(macOS 26.0, *) {
            glassEffect(interactive ? .regular.interactive() : .regular, in: shape)
        } else {
            self
        }
    }

    func glassTile(interactive: Bool = false) -> some View {
        glass(in: RoundedRectangle(cornerRadius: LiquidGlass.cornerRadius, style: .continuous), interactive: interactive)
    }

    @ViewBuilder
    func glassCircle(diameter: CGFloat) -> some View {
        if #available(macOS 26.0, *) {
            frame(width: diameter, height: diameter)
                .contentShape(Circle())
                .glassEffect(.regular.interactive(), in: .circle)
        } else {
            self
        }
    }

    @ViewBuilder
    func legacyBackground<Background: View>(_ background: Background) -> some View {
        if LiquidGlass.isAvailable {
            self
        } else {
            self.background(background)
        }
    }

    @ViewBuilder
    func glassContainer(spacing: CGFloat? = nil) -> some View {
        if #available(macOS 26.0, *) {
            GlassEffectContainer(spacing: spacing) { self }
        } else {
            self
        }
    }

    @ViewBuilder
    func glassButtonStyle(prominent: Bool = false) -> some View {
        if #available(macOS 26.0, *) {
            if prominent {
                buttonStyle(.glassProminent)
            } else {
                buttonStyle(.glass)
            }
        } else {
            self
        }
    }
}

struct IconButton: View {
    let imageName: String
    let action: () -> Void

    var body: some View {
        if LiquidGlass.isAvailable {
            Button(action: action) {
                icon.frame(width: 28, height: 28).contentShape(Circle())
            }
            .buttonStyle(PlainButtonStyle())
            .glassCircle(diameter: 28)
        } else {
            Button(action: action) { icon }
                .buttonStyle(BorderlessButtonStyle())
        }
    }

    private var icon: some View {
        Image(imageName)
            .resizable()
            .renderingMode(.template)
            .frame(width: 16, height: 16)
            .foregroundColor(Color(NSColor.labelColor))
    }
}
