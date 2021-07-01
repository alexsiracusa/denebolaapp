//
//  BlockView.swift
//  CypressApp
//
//  Created by Alex Siracusa on 6/25/21.
//

import CoreData
import SwiftUI

struct BlockView: View {
    @EnvironmentObject var viewModel: ViewModelData
    @Environment(\.managedObjectContext) var moc

    let block: Block
    let height: CGFloat

    var blocks: FetchRequest<BlockInfo>

    var manualColor: Color?
    var color: Color? {
        return manualColor ?? blocks.wrappedValue.first?.color
    }

    init(block: Block, height: CGFloat, school: SchoolData?) {
        self.block = block
        self.height = height

        if school == nil { manualColor = Color(UIColor.lightGray) }
        let filter = school == nil ? NSPredicate(format: "id == %d", block.data.id) : NSPredicate(format: "id == %d && school == %@", block.data.id, school!)
        blocks = FetchRequest<BlockInfo>(entity: BlockInfo.entity(), sortDescriptors: [], predicate: filter)
    }

    init(block: Block, height: CGFloat, color: Color) {
        self.block = block
        self.height = height
        manualColor = color
        blocks = FetchRequest<BlockInfo>(entity: BlockInfo.entity(), sortDescriptors: [])
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(block.times.from)
                .foregroundColor(color?.textColor ?? Color.black)
                .font(.caption2)
            Spacer(minLength: 0)
            if height >= 50 {
                Text(block.data.name)
                    .font(.caption)
                    .bold()
                    .foregroundColor(color?.textColor ?? Color.black)
            }
            Spacer(minLength: 0)
            Text(block.times.to)
                .foregroundColor(color?.textColor ?? Color.black)
                .font(.caption2)
        }
        .padding(.vertical, 3)
        .padding(.horizontal, 5)
        .frame(maxWidth: 100)
        .frame(height: height)
        .background((color ?? Color(UIColor.lightGray)).cornerRadius(5.0))
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        BlockView(block: Block.default, height: 100, school: nil)
            .environmentObject(ViewModelData.default)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
