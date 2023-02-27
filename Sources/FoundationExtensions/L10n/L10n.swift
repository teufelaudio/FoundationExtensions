// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation

/**
 Type-safe localization in 3 easy steps ✨.

 **Step 1**: Define your strings in an extension of L10n (i.e. in `App/Sources/L10n/L10n.swift`).

 ```
 extension L10n {
     public enum HomeScreen: Localizable {
         // sourcery: comment=Navigation Bar Title on Home screen
         case navigationBarTitle

         // sourcery: comment=Some value with parameters
         case value(/* sourcery: format=%d */ count: Int, another: String, /* sourcery: format=%.2f */ exacly: Float)

         // sourcery: comment=Title for submit button on Home screen
         case submitButton
     }
 }
 ```

 **Step 2**: Use [sourcery](https://github.com/krzysztofzablocki/Sourcery) + genstrings + [MergeL10n](https://github.com/teufelaudio/MergeL10n) to generate `Localizable.strings`.
 See .sourcery-l10n-example.yml and adjust the paths to your project. The sourcery template
 can be found in `Tools/Sourcery/Templates/Sources/Localizable.stencil`.


 ```
 # Makefile excerpt
 App/Sources/Generated/Localizable.generated.swift: App/Sources/L10n/L10n.swift
     sourcery --config App/Sources/.sourcery-l10n.yml
     genstrings -o App/Sources/Resources/zz.lproj -s LS App/Sources/Generated/Localizable.generated.swift
     Tools/MergeL10n pseudo-to-languages --base-paths="App/Sources/Resources"

 ```

 **Step 3**: Refer to the strings with the `.localizedString` method.

 ```
 public struct Example: View {
     public var body: some View {
         Text(L10n.HomeScreen.navigationBarTitle.localizedString)
     }
 }
 ```
 */
public enum L10n {
}
