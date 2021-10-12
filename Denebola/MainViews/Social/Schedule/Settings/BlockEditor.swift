//
//  BlockEditor.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/28/21.
//

import SwiftUI

struct BlockEditor: View {
    @EnvironmentObject var viewModel: ViewModelData
    @ObservedObject var block: FullBlock
    @State var color = Color(UIColor.lightGray)
    @State var alert = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(block.name)
                    .foregroundColor(block.textColor)
                    .bold()
                if !block.onServer {
                    Button {
                        alert = true
                    } label: {
                        WarningIcon()
                    }
                }
                ColorPicker(selection: $color, supportsOpacity: false, label: {
                    Spacer()
                })
                .onChange(of: color, perform: { color in
                    block.codableColor = CodableColor(uiColor: UIColor(color))
                })
            }
            .frame(height: 30)
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .background(block.color)

            VStack {
                PropertyEditor(title: "SUBJECT", text: $block.subject)
                Divider()
                PropertyEditor(title: "ROOM", text: $block.room)
                Divider()
                PropertyEditor(title: "TEACHER LAST", text: $block.teacherLast)
                Divider()
                PropertyEditor(title: "TEACHER FIRST", text: $block.teacherFirst)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(block.color.opacity(0.3))
        }
        .onAppear {
            color = block.color
        }
        .alert(isPresented: $alert) {
            Alert(
                title: Text("This block no longer exists"),
                message: Text("Your school has deleted this block. Would you like to delete its data?"),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.fullBlocks[block.id] = nil
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct BlockEditor_Previews: PreviewProvider {
    static var previews: some View {
        BlockEditor(block: FullBlock.default)
            .environmentObject(ViewModelData.default)
    }
}
