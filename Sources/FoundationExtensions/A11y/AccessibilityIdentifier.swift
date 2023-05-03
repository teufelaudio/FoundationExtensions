// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

/// A namespace for accessibility identifiers.
///
/// You could declare A11Y IDs like this
/// ```
/// extension AccessibilityIdentifier {
///     enum HomeScreen: AccessibilityIdentifiable {
///        enum MusicView: AccessibilityIdentifiable {
///            case sectionHeader
///            case recentlyPlayedScrollview
///        }
///
///        enum MiniPlayer: AccessibilityIdentifiable {
///            case muteButton
///            case coverImage
///        }
///     }
/// }
/// ```
/// Thanks to the TypePathConvertible conformance, you can use it on your views:
/// ```
/// Text("Podcasts")
/// .accessibilityIdentifier(AccessibilityIdentifier.HomeScreen.MusicView.sectionHeader.typePath)
/// ```
/// which adds the A11Y ID "MyApp.AccessibilityIdentifier.HomeScreen.MusicView.sectionHeader" to the View.
///
public enum AccessibilityIdentifier: AccessibilityIdentifiable { }
