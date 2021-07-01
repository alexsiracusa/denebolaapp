//
//  NewPageView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/26/21.
//

import Foundation
import SwiftUI
import UIKit

// stolen from: https://stackoverflow.com/questions/58388071/how-can-i-implement-pageview-in-swiftui
public struct MultiPageView: View {
    public init<PageType: View>(
        pages: [PageType],
        indexDisplayMode: PageTabViewStyle.IndexDisplayMode = .automatic,
        currentPageIndex: Binding<Int>, offset: CGFloat = -20
    ) {
        self.pages = pages.map { AnyView($0) }
        self.indexDisplayMode = indexDisplayMode
        self.currentPageIndex = currentPageIndex
        self.offset = offset
    }

    public init<Model, ViewType: View>(
        items: [Model],
        indexDisplayMode: PageTabViewStyle.IndexDisplayMode = .automatic,
        currentPageIndex: Binding<Int>,
        pageBuilder: (Model) -> ViewType, offset: CGFloat = -20
    ) {
        pages = items.map { AnyView(pageBuilder($0)) }
        self.indexDisplayMode = indexDisplayMode
        self.currentPageIndex = currentPageIndex
        self.offset = offset
    }

    private let pages: [AnyView]
    private let indexDisplayMode: PageTabViewStyle.IndexDisplayMode
    private var currentPageIndex: Binding<Int>
    private var offset: CGFloat

    public var body: some View {
        TabView(selection: currentPageIndex) {
            ForEach(Array(pages.enumerated()), id: \.offset) {
                $0.element.tag($0.offset)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .overlay(Fancy3DotsIndexView(numberOfPages: pages.count, currentIndex: currentPageIndex.wrappedValue, offset: offset), alignment: .top)
    }
}

// stolen from https://betterprogramming.pub/custom-paging-ui-in-swiftui-13f1347cf529
struct Fancy3DotsIndexView: View {
    let numberOfPages: Int
    let currentIndex: Int
    let offset: CGFloat

    private let circleSize: CGFloat = 8
    private let circleSpacing: CGFloat = 10

    private let primaryColor = Color(UIColor(red: 180 / 255, green: 180 / 255, blue: 180 / 255, alpha: 1))
    private let secondaryColor = Color(UIColor(red: 210 / 255, green: 210 / 255, blue: 210 / 255, alpha: 1))

    var body: some View {
        HStack(spacing: circleSpacing) {
            ForEach(0 ..< numberOfPages) { index in // 1
                Circle()
                    .fill(currentIndex == index ? primaryColor : secondaryColor)
                    .frame(width: circleSize, height: circleSize)
                    .transition(AnyTransition.opacity.combined(with: .scale))
                    .id(index)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 3)
        .offset(y: offset)
    }
}

struct MultiPageView_Previews: PreviewProvider {
    static var previews: some View {
        MultiPageView(pages: [Color.blue, Color.red, Color.green], currentPageIndex: .constant(1))
            .environmentObject(ViewModelData.default)
    }
}
