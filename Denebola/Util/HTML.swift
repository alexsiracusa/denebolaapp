//
//  HTML.swift
//  CypressApp
//
//  Created by Connor Tam on 6/18/21.
//

import Foundation

func generateHtml(head: String? = nil, body: [String] = []) -> String {
    return """
        <!DOCTYPE HTML>
        <html>
            \(head ?? "<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>")
            <style>
                body {
                    font-family: -apple-system, "Helvetica Neue", "Lucida Grande";
                    font-size: large;
                    margin: 0;
                }
            </style>
            <body>
                \(body.joined(separator: "\n"))
            </body>
        </html>
    """
}
