import SwiftUI
import AppKit

private func adaptive(light: (Int, Int, Int), dark: (Int, Int, Int)) -> NSColor {
    NSColor(name: nil) { appearance in
        let c = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? dark : light
        return NSColor(
            srgbRed: CGFloat(c.0) / 255.0,
            green: CGFloat(c.1) / 255.0,
            blue: CGFloat(c.2) / 255.0,
            alpha: 1.0
        )
    }
}

enum ClaudeTheme {
    static let brand = Color(nsColor: adaptive(light: (201, 100, 66), dark: (217, 119, 87)))
    static let brandMuted = Color(nsColor: adaptive(light: (191, 122, 96), dark: (176, 108, 84)))

    static let usageSafe = Color(nsColor: adaptive(light: (201, 100, 66), dark: (217, 119, 87)))
    static let usageWarning = Color(nsColor: adaptive(light: (169, 113, 20), dark: (217, 164, 65)))
    static let usageCritical = Color(nsColor: adaptive(light: (169, 62, 48), dark: (224, 104, 90)))

    static let statusOperational = Color(nsColor: adaptive(light: (63, 122, 79), dark: (111, 191, 136)))
    static let statusDegraded = Color(nsColor: adaptive(light: (169, 113, 20), dark: (217, 164, 65)))
    static let statusOutage = Color(nsColor: adaptive(light: (169, 62, 48), dark: (224, 104, 90)))
    static let statusUnknown = Color(nsColor: adaptive(light: (124, 122, 114), dark: (150, 147, 138)))

    static let ink = Color(nsColor: adaptive(light: (31, 30, 29), dark: (245, 244, 238)))
    static let inkSecondary = Color(nsColor: adaptive(light: (108, 107, 104), dark: (168, 165, 158)))

    static let surfaceTint = Color(nsColor: adaptive(light: (240, 238, 230), dark: (38, 38, 36)))
    static let trackFill = Color(nsColor: adaptive(light: (31, 30, 29), dark: (245, 244, 238))).opacity(0.10)
    static let hairline = Color(nsColor: adaptive(light: (31, 30, 29), dark: (245, 244, 238))).opacity(0.08)

    static func hoverFill(_ isHovered: Bool) -> Color {
        isHovered ? brand.opacity(0.10) : .clear
    }

    static func popoverTintCGColor() -> CGColor {
        let isDark = NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
        if isDark {
            return NSColor(srgbRed: 30/255, green: 29/255, blue: 27/255, alpha: 0.42).cgColor
        }
        return NSColor(srgbRed: 250/255, green: 249/255, blue: 245/255, alpha: 0.62).cgColor
    }
}

enum ClaudeMotion {
    static let popoverAppear = Animation.easeOut(duration: 0.15)
    static let valueChange = Animation.easeOut(duration: 0.35)
    static let hover = Animation.easeOut(duration: 0.12)
    static let stateChange = Animation.easeOut(duration: 0.2)
}
