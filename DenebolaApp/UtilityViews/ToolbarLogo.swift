//
//  ToolbarLogo.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/9/21.
//

import SwiftUI

struct ToolbarLogo: View {
    var body: some View {
        Image("DenebolaLogoNoBackground")
            .resizable()
            .frame(width: 30, height: 30)
    }
}

struct ToolbarLogo_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarLogo()
    }
}
