//
//  Post.swift
//  WordpressAPI
//
//  Created by Alex Siracusa on 4/18/21.
//

import Foundation

struct Post: Codable, Equatable, Identifiable {
    let id: Int
    let date: String
    let date_gmt: String?
    let status: String?
    let type: String?
    let link: String?
    let title: Render
    let content: Render
    let excerpt: Render
    let author: Int?
    let featured_media: Int
    let categories: [Int]?
    let _embedded: Embeded?
    
    static func ==(lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
    
    func asPostRow() -> PostRow {
        return PostRow(id: self.id, title: self.renderedTitle, author: (self._embedded!.author![0].name)!, date: self.renderedDate, imageURL: self._embedded?.featuredMedia?[0].source_url, hasMedia: self.hasMedia)
    }
    
    var renderedContent: String {
        return content.rendered.html2AttributedString!
            .replacingOccurrences(of: "\n", with: "\n\n")
    }
    
    var renderedExcerpt: String {
        return excerpt.rendered.html2AttributedString!
    }
    
    var renderedTitle: String {
        return title.rendered.html2AttributedString!
    }
    
    var renderedDate: String {
        let date = DateFormatter()
        date.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        date.locale = Locale(identifier: "en_US")
        
        let parsedDate = date.date(from: self.date)!
        date.setLocalizedDateFormatFromTemplate("MMMMdYYYY")
        
        return date.string(from: parsedDate)
    }
    
    var htmlContent: String {
        return """
            <!DOCTYPE HTML>
            <head><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></meta></head>
            <html>
                <style>
                    body {
                        font-family: -apple-system, "Helvetica Neue", "Lucida Grande";
                        font-size: "Large";
                    }
                </style>
                <body>
                    \(self.content.rendered)
                </body>
            </html>
        """
    }
    
    var hasMedia: Bool {
        return featured_media != 0
    }
}

struct Embeded: Codable {
    let author: [Author]?
    let featuredMedia: [SimpleMedia]?
    //let category: [Category]?
    
    enum CodingKeys: String, CodingKey {
        case featuredMedia = "wp:featuredmedia"
        case author = "author"
        //case category = "wp:term"
    }
}

struct SimpleMedia: Codable {
    let id: Int?
    let source_url: String?
}

struct Author: Codable {
    let id: Int?
    let name: String?
}

struct Render: Codable {
    let rendered: String
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



