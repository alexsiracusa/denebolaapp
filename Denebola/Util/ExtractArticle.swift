//
//  ExtractArticle.swift
//  CypressApp
//
//  Created by Connor Tam on 6/17/21.
//

import Alamofire
import Foundation
import PromiseKit
import SwiftSoup

struct ExtractedArticleElements {
    let head: String
    let scripts: String
    let styles: String
}

// Extracts the head and any scripts in a URL and returns them in a compiled ExtractedArticleElements
private func extractArticle(html: String) throws -> ExtractedArticleElements? {
    let doc: Document = try SwiftSoup.parse(html)

    guard let head = try doc.select("head").first()?.outerHtml() else { return nil }
    guard let body = try doc.select("body").first() else { return nil }
    let scripts = try body.select("script").map { try $0.outerHtml() }
    var styles = try body.select("style").map { try $0.outerHtml() }

    styles.append(contentsOf: try body.select("link").map { try $0.outerHtml() })

    return ExtractedArticleElements(
        head: head,
        scripts: scripts.joined(separator: "\n"),
        styles: styles.joined(separator: "\n")
    )
}

// Gets the supplied URL and returns an ExtractedArticleElements
func extractArticleFromUrl(url: URL) -> Promise<ExtractedArticleElements?> {
    return Promise { seal in
        AF.request(url, interceptor: Retry()).validate().responseString { response in
            let result = response.tryMap { try extractArticle(html: $0) }.result
            seal.resolve(result)
        }
    }
}
