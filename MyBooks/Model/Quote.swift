//
//  Quote.swift
//  MyBooks
//
//  Created by Jamerson Macedo on 25/08/25.
//

import Foundation
import SwiftData
@Model
class Quote {
    var creationDate: Date = Date.now
    var text: String
    var page: String?
    init(
        text: String,
        page: String? = nil
    ) {
        self.text = text
        self.page = page
    }
    var book  : Book?
}
