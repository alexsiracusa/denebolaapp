//
//  DefaultImage.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 6/3/21.
//

import Foundation
import SwiftUI

class DefaultImage: ObservableObject {
    @Published var image: Image = Image("DenebolaLogoNoBackground")
    
    init() {}
    init(_ image: Image) {
        self.image = image
    }
}
