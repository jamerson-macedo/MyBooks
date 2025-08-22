//
//  Book.swift
//  MyBooks
//
//  Created by Jamerson Macedo on 21/08/25.
//

import SwiftUI
import SwiftData

@Model
class Book {
    var title : String
    var author : String
    var dateAdded:Date
    var dateStarted:Date
    var dateCompleted : Date
    @Attribute(originalName: "summary") // quando o valor na tabela muda, tem que colocar o nome antigo 
    var synopsis : String
    var rating : Int?
    var status : Status.RawValue
    var recommendedBy : String = ""
    init(
        title: String,
        author: String,
        dateAdded: Date=Date.now,
        dateStarted: Date = Date.distantPast, // uma data aleatoria do passado
        dateCompleted: Date = Date.distantPast,
        synopsis: String = "",
        rating: Int? = nil,
        status: Status = .onShelf,
        recommendedBy : String = "" // se voce colocar um valor nulo, ele pode ser adicionado ao banco
    ) {
        self.title = title
        self.author = author
        self.dateAdded = dateAdded
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
        self.synopsis = synopsis
        self.rating = rating
        self.status = status.rawValue
        self.recommendedBy = recommendedBy
    }
    var icon : Image{
        switch Status(rawValue: status)! {
        case .onShelf:
            Image(systemName: "checkmark.diamond.fill")
        case .inProgress:
            Image(systemName: "book.fill")
        case .completed:
            Image(systemName: "books.vertical.fill")
        }
    }
    
}
enum Status : Int,Codable, Identifiable,CaseIterable{
    case onShelf, inProgress, completed
    var id : Self {self}
    var description : String{
        switch self {
        case .onShelf:
            return "On Shelf"
        case .inProgress:
            return "In Progress"
        case .completed:
            return "Completed"
        }
    }
}
