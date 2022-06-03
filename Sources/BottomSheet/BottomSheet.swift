//
//  BottomSheet.swift
//  Created by Dmitry Novosyolov on 1/06/2022

import SwiftUI

@available(iOS 15.0, *)
public extension View {
    /// Presents a bottom sheet when a binding to a Boolean value that you
    /// provide is true.
    ///
    /// Use this method when you want to present a bottom modal view to the
    /// user when a Boolean value you provide is true. The example
    /// below displays a modal view of the mockup for a software license
    /// agreement when the user toggles the `isShowingBottomSheet`
    /// variable by clicking or tapping on the "Show License Agreement" button:
    ///
    ///     struct ShowLicenseAgreementView: View {
    ///         @State
    ///         private var isShowingBottomSheet: Bool = false
    ///         var body: some View {
    ///             Button(action: {
    ///                 isShowingBottomSheet.toggle()
    ///             }) {
    ///                 Text("Show License Agreement")
    ///             }
    ///             .bottomSheet(isPresented: $isShowingBottomSheet, onDismiss: didDismiss) {
    ///                 VStack {
    ///                     Text("License Agreement")
    ///                         .font(.title)
    ///                         .padding(50)
    ///                     Text("Terms and conditions go here.")
    ///                         .padding(50)
    ///                     Button("Dismiss", action: { isShowingBottomSheet.toggle() })
    ///                 }
    ///             }
    ///         }
    ///         func didDismiss() {
    ///             // Handle the dismissing action.
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - cornerRadius: The preferred corner radius, using a continuous corner curve, for the background and stroke.
    ///     The default value is [22.0]
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///     to present the sheet that you create in the modifier's
    ///     `content` closure.
    ///   - onDismiss: The closure to execute when dismissing the sheet.
    ///   - content: A closure that returns the content of the sheet.
    func bottomSheet<Content>(
        cornerRadius: CGFloat = 22,
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping() -> Content
    ) -> some View where Content: View {
        frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: BottomSheetConfig.Main.alignment) {
                if isPresented.wrappedValue,
                   let actualContent = content {
                    GeometryReader { proxy in
                        ZStack {
                            BottomSheetShape(cornerRadius: cornerRadius)
                                .fill(BottomSheetConfig.Main.fillStyle)
                            BottomSheetShape(cornerRadius: cornerRadius)
                                .stroke(BottomSheetConfig.Stroke.fillStyle, lineWidth: BottomSheetConfig.Stroke.lineWidth)
                        }
                        .overlay(alignment: BottomSheetConfig.Element.alignment) {
                            RoundedRectangle(
                                cornerRadius: BottomSheetConfig.Element.cornerRadius,
                                style: BottomSheetConfig.Element.style
                            )
                            .fill(BottomSheetConfig.Element.fillStyle)
                            .opacity(BottomSheetConfig.Element.fillStyleOpacity)
                            .frame(
                                width: BottomSheetConfig.Element.Frame.width(for: proxy),
                                height: BottomSheetConfig.Element.Frame.height(for: proxy)
                            )
                            .offset(y: BottomSheetConfig.Element.Offset.y(for: proxy))
                        }
                        .overlay {
                            actualContent()
                                .padding()
                                .animation(nil, value: isPresented.wrappedValue)
                                .onDisappear(perform: onDismiss)
                        }
                        .frame(
                            width: BottomSheetConfig.Global.Frame.width(for: proxy),
                            height: BottomSheetConfig.Global.Frame.height(for: proxy)
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .ignoresSafeArea(.container)
                    }
                    .transition(BottomSheetConfig.Global.Transition.moveFromBottom)
                }
            }
            .animation(BottomSheetConfig.Global.ActualAnimation.spring, value: isPresented.wrappedValue)
    }
    /// Presents a bottom sheet using the given item as a data source
    /// for the bottom sheet's content.
    ///
    /// Use this method when you need to present a bottom modal view with content
    /// from a custom data source. The example below shows a custom data source
    /// `InventoryItem` that the `content` closure uses to populate the display
    /// the action sheet shows to the user:
    ///
    ///          struct ShowPartDetailView: View {
    ///              @State
    ///              private var bottomSheetDetail: InventoryItem?
    ///              var body: some View {
    ///                  Button(action: buttonAction) {
    ///                      Text("Show Part Details")
    ///                  }
    ///                  .bottomSheet(item: $bottomSheetDetail, onDismiss: didDismiss) { detail in
    ///                      VStack(alignment: .leading, spacing: 20) {
    ///                          Text("Part Number: \(detail.partNumber)")
    ///                          Text("Name: \(detail.name)")
    ///                          Text("Quantity On-Hand: \(detail.quantity)")
    ///                      }
    ///                  }
    ///              }
    ///              func buttonAction() {
    ///                  if bottomSheetDetail == nil {
    ///                      bottomSheetDetail =
    ///                          .init(
    ///                              id: "0123456789",
    ///                              partNumber: "Z-1234A",
    ///                              quantity: 100,
    ///                              name: "Widget")
    ///                  } else {
    ///                      bottomSheetDetail = nil
    ///                  }
    ///              }
    ///              func didDismiss() {
    ///                  // Handle the dismissing action.
    ///              }
    ///          }
    ///
    ///          struct InventoryItem: Identifiable {
    ///              var id: String
    ///              let partNumber: String
    ///              let quantity: Int
    ///              let name: String
    ///          }
    ///
    /// - Parameters:
    ///   - cornerRadius: The preferred corner radius, using a continuous corner curve, for the background and stroke.
    ///     The default value is [22.0]
    ///   - item: A binding to an optional source of truth for the bottom sheet.
    ///     When `item` is non-`nil`, the system passes the item's content to
    ///     the modifier's closure. You display this content in a sheet that you
    ///     create that the system displays to the user. If `item` changes,
    ///     the system dismisses the sheet and replaces it with a new one
    ///     using the same process.
    ///   - onDismiss: The closure to execute when dismissing the sheet.
    ///   - content: A closure returning the content of the sheet.
    func bottomSheet<Item, Content>(
        cornerRadius: CGFloat = 22,
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping(Item) -> Content
    ) -> some View where Item: Identifiable, Content: View {
        frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: BottomSheetConfig.Main.alignment) {
                if let actualItem = item.wrappedValue {
                    GeometryReader { proxy in
                        ZStack {
                            BottomSheetShape(cornerRadius: cornerRadius)
                                .fill(BottomSheetConfig.Main.fillStyle)
                            BottomSheetShape(cornerRadius: cornerRadius)
                                .stroke(BottomSheetConfig.Stroke.fillStyle, lineWidth: BottomSheetConfig.Stroke.lineWidth)
                        }
                        .overlay(alignment: BottomSheetConfig.Element.alignment) {
                            RoundedRectangle(
                                cornerRadius: BottomSheetConfig.Element.cornerRadius,
                                style: BottomSheetConfig.Element.style
                            )
                            .fill(BottomSheetConfig.Element.fillStyle)
                            .opacity(BottomSheetConfig.Element.fillStyleOpacity)
                            .frame(
                                width: BottomSheetConfig.Element.Frame.width(for: proxy),
                                height: BottomSheetConfig.Element.Frame.height(for: proxy)
                            )
                            .offset(y: BottomSheetConfig.Element.Offset.y(for: proxy))
                        }
                        .overlay {
                            content(actualItem)
                                .padding()
                                .animation(nil, value: item.wrappedValue == nil)
                                .onDisappear(perform: onDismiss)
                        }
                        .frame(
                            width: BottomSheetConfig.Global.Frame.width(for: proxy),
                            height: BottomSheetConfig.Global.Frame.height(for: proxy)
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .ignoresSafeArea(.container)
                    }
                    .transition(BottomSheetConfig.Global.Transition.moveFromBottom)
                }
            }
            .animation(BottomSheetConfig.Global.ActualAnimation.spring, value: item.wrappedValue == nil)
    }
}

@available(iOS 15.0, *)
fileprivate struct BottomSheetShape: Shape {
    var cornerRadius: CGFloat
    fileprivate func path(in rect: CGRect) -> Path {
        let path: UIBezierPath =
            .init(
                roundedRect: rect,
                byRoundingCorners: [.topLeft, .topRight],
                cornerRadii: .init(width: cornerRadius, height: cornerRadius)
            )
        return Path(path.cgPath)
    }
}

@available(iOS 15.0, *)
fileprivate enum BottomSheetConfig {
    fileprivate enum Main {
        static let alignment: Alignment = .bottom
        static let fillStyle: Material = .regularMaterial
    }
    fileprivate enum Stroke {
        static let fillStyle: HierarchicalShapeStyle = .secondary
        static let lineWidth: CGFloat = 0.05
    }
    fileprivate enum Element {
        static let cornerRadius: CGFloat = 4.0
        static let style: RoundedCornerStyle = .circular
        static let fillStyle: HierarchicalShapeStyle = .primary
        static let fillStyleOpacity: CGFloat = 0.35
        static let alignment: Alignment = .top
        fileprivate enum Frame {
            static func width(for proxy: GeometryProxy) -> CGFloat {
                proxy.size.width * 0.085
            }
            static func height(for proxy: GeometryProxy) -> CGFloat {
                proxy.size.width * 0.0085
            }
        }
        fileprivate enum Offset {
            static func y(for proxy: GeometryProxy) -> CGFloat  {
                proxy.size.width * 0.03
            }
        }
    }
    fileprivate enum Global {
        fileprivate enum Frame {
            static func width(for proxy: GeometryProxy) -> CGFloat {
                proxy.frame(in: .global).width
            }
            static func height(for proxy: GeometryProxy) -> CGFloat {
                proxy.frame(in: .global).height * 0.5
            }
        }
        fileprivate enum Transition {
            static let moveFromBottom: AnyTransition = .move(edge: .bottom)
        }
        fileprivate enum ActualAnimation {
            static let spring: Animation = .spring(response: 0.5, dampingFraction: 1, blendDuration: .zero)
        }
    }
}
