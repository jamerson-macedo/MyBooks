//
//  Genre.swift
//  MyBooks
//
//  Created by Jamerson Macedo on 25/08/25.
//

import SwiftUI
import SwiftData
@Model
class Genre{
    var name: String
    var color : String
    var books : [Book]?
    init(name: String, color: String) {
        self.name = name
        self.color = color
    }
    var hexColor : Color {
        Color(hex:self.color) ?? .red
    }
    
}
