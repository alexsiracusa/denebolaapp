//
//  Extensions.swift
//  DenebolaApp
//
//  Created by Connor Tam on 5/9/21.
//

import Foundation
import FetchImage
import SwiftUI

extension FetchImage {
    var displayImage: Image? {
        guard let image = self.image else {return nil}
        return Image(uiImage: image.imageWithoutBaseline())

    }
}

extension String {
    var html2AttributedString: String? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil).string
            //return self
            
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    
    var asURL: URL? {
        guard let urlString = self.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            return nil
        }
        return URL(string: urlString)
    }
}
