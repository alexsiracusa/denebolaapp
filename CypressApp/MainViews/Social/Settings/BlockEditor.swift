//
//  BlockEditor.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/28/21.
//

import SwiftUI

struct BlockEditor: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var block: BlockInfo

    @State var color = Color.clear

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(block.wrappedBlockName)
                    .foregroundColor(block.textColor)
                    .bold()
                if !block.onServer {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.yellow)
                }
                ColorPicker(selection: $color, supportsOpacity: false, label: {
                    Spacer()
                })
                    .onChange(of: color, perform: { color in
                        block.colorHex = UIColor(color).hexString()
                        moc.saveAsyncIfNeeded()
                    })
            }
            .frame(height: 30)
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .background(block.color)

            // causes the view to take ~0.3 seconds to load
            VStack {
                PropertyEditor(title: "SUBJECT", text: $block.classSubject ?? "")
                Divider()
                PropertyEditor(title: "ROOM", text: $block.roomNumber ?? "")
                Divider()
                PropertyEditor(title: "TEACHER LAST", text: $block.teacherLast ?? "")
                Divider()
                PropertyEditor(title: "TEACHER FIRST", text: $block.teacherFirst ?? "")
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(block.color.opacity(0.3))
        }
        .onAppear {
            color = block.color
        }
    }
}

struct BlockEditor_Previews: PreviewProvider {
    static var previews: some View {
        BlockEditor(block: BlockInfo.default)
            .environmentObject(ViewModelData.default)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
