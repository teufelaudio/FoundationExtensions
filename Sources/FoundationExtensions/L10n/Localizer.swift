// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

// swiftlint:disable nslocalizedstring_key
/// Controls localization of the app.
import Foundation
#if canImport(UIKit)
import UIKit
#endif

public enum Localizer {
    public enum FallbackMode: String, CaseIterable, Codable {
        /// Fetches the English value of the translation key.
        case fallbackToEnglish
        /// Shows the keys for all non-value keys.
        case appleDefault
        /// Shows keys, but appended with a lot of Emojis.
        case visualAlertMode
        /// Crashes if it sees any key which does not have a value.
        case crash

        public var title: String {
            switch self {
            case .fallbackToEnglish: return "English Value (Default)"
            case .appleDefault: return "Apple behavior (Show keys)"
            case .visualAlertMode: return "Visual Alert (🚨🚨🚨)"
            case .crash: return "Crash (exactly as it sounds, might need to uninstall app after)"
            }
        }
    }
}

// MARK: - Thread safe access to preferredLanguage

extension Localizer {

    // This code runs exactly once, because of `private static let foo = { bar }()`
    private static let _setup: Void = {
        // make sure we are notified, when the preferred language could have been changed
        #if canImport(UIKit)
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { _ in
            Task { @MainActor in
                updatePreferredLanguage()
            }
        }
        #endif
        NotificationCenter.default.addObserver(
            forName: NSLocale.currentLocaleDidChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            Task { @MainActor in
                updatePreferredLanguage()
            }
        }
        // Set the initial value
        Task { @MainActor in
            updatePreferredLanguage()
        }
    }()

    nonisolated(unsafe) private static var _preferredLanguage: String? = "en"
    private static let preferredLanguageLock = NSLock()

    private static var preferredLanguage: String? {
        get {
            preferredLanguageLock.lock()
            defer { preferredLanguageLock.unlock() }
            return _preferredLanguage
        }
        set {
                        preferredLanguageLock.lock()
            defer { preferredLanguageLock.unlock() }
            _preferredLanguage = newValue
        }
    }

    private static func updatePreferredLanguage() {
        preferredLanguage = Locale.preferredLanguages.first
    }
}

// MARK: - Thread safe access to fallbackMode

extension Localizer {

    nonisolated(unsafe) private static var _fallbackMode: FallbackMode = .fallbackToEnglish
    private static let fallbackModeLock = NSLock()

    /// Determines how keys without a translation in the Locale language should be handled.
    public static var fallbackMode: FallbackMode {
        get {
            fallbackModeLock.lock()
            defer { fallbackModeLock.unlock() }
            return _fallbackMode
        }
        set {
            fallbackModeLock.lock()
            defer { fallbackModeLock.unlock() }
            _fallbackMode = newValue
        }
    }
}

// Mark: Localisation business

extension Localizer {

    fileprivate static func localizedString(_ key: String, bundle: Bundle, comment: String) -> String {
        _ = _setup // setup once, later it's a chaep NOP

        // Code here is adopted from https://stackoverflow.com/a/48415872
        let value = NSLocalizedString(key, bundle: bundle, comment: comment)

        // If the user's language is english, we don't need to handle the mode.
        guard Self.preferredLanguage != "en" else {
            return value
        }

        // If key is the same as value, we don't have a proper translation.
        let needsFallback = value == key
        guard needsFallback else { return value }

        switch fallbackMode {
        case .fallbackToEnglish:
            return englishString(key, bundle: bundle, comment: comment, value: value)
        case .appleDefault:
            return value
        case .visualAlertMode:
            return "🚨🚨🚨 UNLOCALIZED STRING KEY: \(value) 🚨🚨🚨"
        case .crash:
            fatalError("LocalizedStringKey \(key) has no translation for the Locale language: \(Locale.preferredLanguages.first ?? "Unknown")")
        }
    }

    private static func englishString(_ key: String, bundle: Bundle, comment: String, value: String) -> String {
        // Check the bundle for the en.lproj file to manually retrieve English translation.
        guard
            let path = bundle.path(forResource: "en", ofType: "lproj"),
            let bundle = Bundle(path: path)
            else { return value }
        return NSLocalizedString(key, bundle: bundle, comment: comment)
    }
}

public func LS(_ key: String, bundle: Bundle, comment: String) -> String {
    Localizer.localizedString(key, bundle: bundle, comment: comment)
}

// swiftlint:enable nslocalizedstring_key
