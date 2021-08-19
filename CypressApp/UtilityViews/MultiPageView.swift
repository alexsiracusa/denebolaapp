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
        indexDisplay: Alignment? = nil,
        currentPageIndex: Binding<Int>,
        offset: CGFloat = -20,
        impactStyle: UIImpactFeedbackGenerator.FeedbackStyle? = nil,
        indexDisplayMode: PageTabViewStyle.IndexDisplayMode? = nil
    ) {
        self.pages = pages.map { AnyView($0) }
        self.indexDisplay = indexDisplay
        self.currentPageIndex = currentPageIndex
        self.offset = offset
        self.impactStyle = impactStyle
        self.indexDisplayMode = indexDisplayMode

        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.orange)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.orange.withAlphaComponent(0.2)
    }

    private let pages: [AnyView]
    private let indexDisplay: Alignment?
    private var currentPageIndex: Binding<Int>
    private var offset: CGFloat
    private let impactStyle: UIImpactFeedbackGenerator.FeedbackStyle?
    private let indexDisplayMode: PageTabViewStyle.IndexDisplayMode?

    public var body: some View {
        TabView(selection: currentPageIndex) {
            ForEach(Array(pages.enumerated()), id: \.offset) {
                $0.element.tag($0.offset)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: indexDisplayMode ?? .never))
        .overlay(
            Fancy3DotsIndexView(show: indexDisplay != nil, numberOfPages: pages.count, currentIndex: currentPageIndex, offset: offset),
            alignment: indexDisplay ?? .top
        )
        .onChange(of: currentPageIndex.wrappedValue) { _ in
            if let style = impactStyle {
                impact(style)
            }
        }
    }
}

// stolen from https://betterprogramming.pub/custom-paging-ui-in-swiftui-13f1347cf529
struct Fancy3DotsIndexView: View {
    var show: Bool = true
    let numberOfPages: Int
    @Binding var currentIndex: Int
    let offset: CGFloat

    private let circleSize: CGFloat = 8
    private let circleSpacing: CGFloat = 12
    private var finalSpacing: CGFloat {
        circleSpacing - (30 - circleSize)
    }

    private let primaryColor = Color(UIColor(red: 180 / 255, green: 180 / 255, blue: 180 / 255, alpha: 1))
    private let secondaryColor = Color(UIColor(red: 210 / 255, green: 210 / 255, blue: 210 / 255, alpha: 1))

    var body: some View {
        if show {
            HStack(spacing: finalSpacing) {
                ForEach(0 ..< numberOfPages) { index in // 1
                    Button {
                        withAnimation {
                            currentIndex = index
                        }
                    } label: {
                        Circle()
                            .fill(currentIndex == index ? primaryColor : secondaryColor)
                            .frame(width: circleSize, height: circleSize)
                            .frame(width: 30, height: 20)
                            .transition(AnyTransition.opacity.combined(with: .scale))
                            .id(index)
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 3)
            .offset(y: offset)
        }
    }
}

struct MultiPageView_Previews: PreviewProvider {
    static var previews: some View {
        MultiPageView(pages: [Color.blue, Color.red, Color.green], indexDisplay: .top, currentPageIndex: .constant(1))
            .environmentObject(ViewModelData.default)
    }
}
