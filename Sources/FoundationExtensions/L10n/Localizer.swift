// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

// swiftlint:disable nslocalizedstring_key
/// Controls localization of the app.
import Foundation

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

    /// Determines how keys without a translation in the Locale language should be handled.
    public static var fallbackMode: FallbackMode { .fallbackToEnglish }

    fileprivate static func localizedString(_ key: String, bundle: Bundle, comment: String) -> String {
        // Code here is adopted from https://stackoverflow.com/a/48415872
        let value = NSLocalizedString(key, bundle: bundle, comment: comment)

        // If the user's language is english, we don't need to handle the mode.
        guard Locale.preferredLanguages.first != "en" else {
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
