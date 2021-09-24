//
//  PullRefresh.swift
//  Denebola
//
//  Created by Connor Tam on 8/28/21.
//

import SwiftUI

typealias RefreshCallback = (@escaping () -> Void) -> Void

/// Wrapper class to be used with immutable structs
class ObserverWrapper: ObservableObject {
    @Published var didRefresh = false
    @Published var topDiff: CGFloat = 0.0
    @Published var percentUp: CGFloat = 0.0
    var didReset = true

    private var observer: NSKeyValueObservation!
    private let refreshCallback: RefreshCallback

    init(_ refreshCallback: @escaping RefreshCallback) {
        self.refreshCallback = refreshCallback
    }

    /// calls refreshCallback if not already, and after completion, scrolls scrollView back
    func handleRefresh(scrollView: UIScrollView) {
        guard !didRefresh else { return }
        didRefresh = true
        // Delay for visual effect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.refreshCallback {
                scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: -scrollView.contentInset.top), animated: false)
                self.didRefresh = false
            }
        }
    }

    /// Sets up a scrollView to call refreshCallback() when scrolled up a certain distance
    func applyTo(_ scrollView: UIScrollView) {
        observer = scrollView.observe(\.contentOffset, options: .new) { scrollView, value in
            if !self.didReset {
                self.didReset = self.topDiff == 0
                return
            }

            self.topDiff = value.newValue!.y + scrollView.contentInset.top
            self.percentUp = self.topDiff / -80

            if self.topDiff < -80, !scrollView.isDragging, self.didReset {
                self.handleRefresh(scrollView: scrollView)
                scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: max(scrollView.contentOffset.y, -scrollView.contentInset.top - 60)), animated: false)
            }
        }
    }
}

struct PullRefresh: ViewModifier {
    @ObservedObject var observer: ObserverWrapper

    init(_ refreshCallback: @escaping RefreshCallback) {
        self.observer = ObserverWrapper(refreshCallback)
    }

    func body(content: Content) -> some View {
        content.introspectScrollView(customize: observer.applyTo)
            .overlay(GeometryReader { reader in
                Spinner(percentage: $observer.percentUp, animating: $observer.didRefresh, opacityFactor: observer.didRefresh ? max(min(Double(observer.percentUp) * 2, 1.0), 0) : 1)
                    .offset(x: reader.size.width * 0.5, y: 15 - max(observer.topDiff, 0))
            })
    }
}

extension View {
    func pullToRefresh(_ refresher: PullRefresh) -> some View {
        modifier(refresher)
    }
}

// from https://github.com/AppPear/SwiftUI-PullToRefresh/blob/cd33c339e2a030804dfda6517536c941c12cb3a3/Sources/SwiftUIPullToRefresh/PullToRefresh.swift#L161
struct Spinner: View {
    @Binding var percentage: CGFloat
    @Binding var animating: Bool
    var opacityFactor: Double

    @State private var rotationDegrees = 0
    @State private var opacityIndex = 1
    @State private var timer: Timer? = nil

    private func getOpacity(_ i: Int) -> Double {
        var opacity: Double
        
        if animating {
            opacity = Double((opacityIndex + i - 1) % 8) / 8.0
        } else {
            opacity = percentage * 8 >= CGFloat(i) ? Double(i) / 8.0 : 0
        }
        
        opacity *= opacityFactor
        
        return opacity
    }
    
    private func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) {_ in
                opacityIndex = (opacityIndex - 1 + 8) % 8
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func doAnimate() {
        if animating {
            opacityIndex = 0
            
            startTimer()
            
            withAnimation(Animation.linear(duration: 4.0).repeatForever()) {
                rotationDegrees = 360
            }
        } else {
            stopTimer()
            
            withAnimation(.default) {
                rotationDegrees = 0
            }
        }
    }

    var body: some View {
        GeometryReader { _ in
            ForEach(1 ... 8, id: \.self) { i in
                Rectangle()
                    .fill(Color.gray)
                    .cornerRadius(99)
                    .frame(width: 4, height: 11)
                    .opacity(getOpacity(i))
                    .offset(x: 0, y: -6)
                    .rotationEffect(.degrees(Double(45 * i)), anchor: .bottom)
            }
            .rotationEffect(.degrees(Double(rotationDegrees)), anchor: UnitPoint(x: 0, y: 1))
            .onChange(of: self.animating) { _ in doAnimate() }
            .onAppear(perform: doAnimate)
        }
        .frame(width: 40, height: 40)
    }
}
