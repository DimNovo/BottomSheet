# BottomSheet

[![Platform Support](https://shields.io/badge/Platform-iOS-lightgray?logo=apple&style=flat)](https://www.apple.com/ios/ios-15/)
[![SwiftUI Support](https://shields.io/badge/SwiftUI-3.0-7b68ee?logo=Swift&style=flat)](https://developer.apple.com/xcode/swiftui/)
[![SwiftPM compatible](https://shields.io/badge/SwiftPM-compatible-9acd32?logo=Swift&style=flat)](https://developer.apple.com/documentation/swift_packages)
[![License](https://shields.io/badge/License-MIT-informational?style=flat)](https://github.com/DimNovo/BottomSheet/blob/main/LICENSE)

A modal bottom sheet build with SwiftUI.

## Requirements

- iOS 15.0 *
- Swift 5.6
- Xcode 13

## Installation

[Swift Package Manager](https://swift.org/package-manager/)

>Xcode comes with built-in support for source control accounts and makes it easy to leverage available Swift packages

1. In Xcode, open your project and navigate to **`File`** → **`Add Packages...`**
2. Paste the repository URL (`https://github.com/DimNovo/BottomSheet`) & click **`Add Package`**.
3. After the package is installed into your project – just `import` [BottomSheet](https://github.com/DimNovo/BottomSheet) & start to use it.

## Usage

`Option: 1`
    Presents a bottom sheet when a binding to a Boolean value that you
    provide is true.
    Use this method when you want to present a bottom modal view to the
    user when a Boolean value you provide is true. The example
    below displays a modal view of the mockup for a software license
    agreement when the user toggles the `isShowingBottomSheet`
    variable by clicking or tapping on the "Show License Agreement" button:

```swift
import SwiftUI
import BottomSheet

struct ShowLicenseAgreementView: View {
    @State
    private var isShowingBottomSheet: Bool = false
    var body: some View {
        Button(action: {
            isShowingBottomSheet.toggle()
        }) {
            Text("Show License Agreement")
        }
        .bottomSheet(isPresented: $isShowingBottomSheet,
               onDismiss: didDismiss) {
            VStack {
                Text("License Agreement")
                    .font(.title)
                    .padding(50)
                Text("Terms and conditions go here.")
                    .padding(50)
                Button("Dismiss", action: { isShowingBottomSheet.toggle() })
            }
        }
    }
    func didDismiss() {
        // Handle the dismissing action.
    }
}
```
`Option: 2`
     Presents a bottom sheet using the given item as a data source
     for the bottom sheet's content.
     Use this method when you need to present a bottom modal view with content
     from a custom data source. The example below shows a custom data source
     `InventoryItem` that the `content` closure uses to populate the display
     the action sheet shows to the user:

```swift
import SwiftUI
import BottomSheet

struct ShowPartDetailView: View {
    @State
    private var bottomSheetDetail: InventoryItem?
    var body: some View {
        Button(action: buttonAction) {
            Text("Show Part Details")
        }
        .bottomSheet(item: $bottomSheetDetail, onDismiss: didDismiss) { detail in
            VStack(alignment: .leading, spacing: 20) {
                Text("Part Number: \(detail.partNumber)")
                Text("Name: \(detail.name)")
                Text("Quantity On-Hand: \(detail.quantity)")
            }
        }
    }
    func buttonAction() {
        if bottomSheetDetail == nil {
            bottomSheetDetail =
                .init(
                    id: "0123456789",
                    partNumber: "Z-1234A",
                    quantity: 100,
                    name: "Widget")
        } else {
            bottomSheetDetail = nil
        }
    }
    func didDismiss() {
        //  Handle the dismissing action.
    }
}

struct InventoryItem: Identifiable {
    var id: String
    let partNumber: String
    let quantity: Int
    let name: String
}
```

![1_light](https://user-images.githubusercontent.com/45280105/171779940-1c1dc62e-e747-48e8-a701-70c9ea3fcfe0.gif) ![1_dark](https://user-images.githubusercontent.com/45280105/171779955-fb61a3b8-d106-4e42-ac00-e7ed2884d16e.gif)

![2_light](https://user-images.githubusercontent.com/45280105/171779977-1985a61b-fe7f-4b8e-a7a4-2e0e335d33c3.gif) ![2_dark](https://user-images.githubusercontent.com/45280105/171779985-4b439b5e-36f7-4ca2-b999-19c7ac92e362.gif) 

![3_light](https://user-images.githubusercontent.com/45280105/171883065-6303ad09-d87b-4454-839b-a8138cb8368a.gif) ![3_dark](https://user-images.githubusercontent.com/45280105/171882416-727f1326-3609-4556-9c76-d308d039033f.gif)

## License

Licensed under the [MIT License](https://github.com/DimNovo/BottomSheet/blob/main/LICENSE).

## Credits

BottomSheet is a project of [@DimNovo](https://github.com/DimNovo).
