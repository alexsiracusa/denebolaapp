//
//  InfiniteExampleView.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 02/03/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//
import SwiftUI
import SwiftUIPager

struct InfinitePager: View {
    @StateObject var page1 = Page.withIndex(2)
    @StateObject var page2 = Page.first()
    @State var data1 = Array(0 ..< 7)

    @Binding var page: Int
    var pageView: (_ page: Int) -> AnyView

    var body: some View {
        Pager(page: page1,
              data: data1,
              id: \.self) {
            self.pageView($0)
        }
        .sensitivity(.high)
        .onPageWillChange { page in
            self.page = data1[page]
        }
        .onPageChanged { page in
            changePage(page)
        }
        .pagingPriority(.high)
        .onAppear {
            self.page = data1[page]
        }
    }

    func changePage(_ page: Int) {
        if page == 1 {
            let newData = (1 ... 5).map { data1.first! - $0 }.reversed()
            withAnimation {
                page1.index += newData.count
                data1.insert(contentsOf: newData, at: 0)
            }
        } else if page == data1.count - 2 {
            guard let last = data1.last else { return }
            let newData = (1 ... 5).map { last + $0 }
            withAnimation {
                data1.append(contentsOf: newData)
            }
        }
    }
}

struct InfiniteExampleView_Previews: PreviewProvider {
    static var previews: some View {
        InfinitePager(page: .constant(1)) { _ in
            AnyView(
                ScheduleView(date: Date("6/21/2021", format: "M/d/yyyy", region: .local)!, height: 400, showLunches: false)
            )
        }
    }
}
