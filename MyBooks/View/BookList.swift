//
//  BookList.swift
//  MyBooks
//
//  Created by Jamerson Macedo on 21/08/25.
//

import SwiftUI
import SwiftData

struct BookList: View {
    @Environment(\.modelContext) private var context
    @Query private var books: [Book]
    
    /// se usar enum na query ele vai crashar
    init(sortOrder : SortOrder, filterString : String){
        let sortDescriptors: [SortDescriptor<Book>] = switch sortOrder {
        case .title:
            [SortDescriptor(\Book.title)]
        case .author:
            [SortDescriptor(\Book.author)]
        case .status:
            [SortDescriptor(\Book.status), SortDescriptor(\Book.title)]
        }
        let predicate = #Predicate<Book> { book in
            book.title.localizedStandardContains(filterString)
            || book.author.localizedStandardContains(filterString)
            || filterString.isEmpty
            
        }
        _books = Query(filter:predicate,sort: sortDescriptors)
    }
    var body: some View {
        Group{
            if books.isEmpty {
                ContentUnavailableView("Enter your first book", systemImage: "book.fill")
            }else {
                List{
                    ForEach(books){ book in
                        NavigationLink {
                            EditBookView(book:book)
                        } label: {
                            BookRow(book:book)
                        }
                    }
                    .onDelete{ indexSet in
                        indexSet.forEach { index in
                            let book = books[index]
                            context.delete(book)
                        }
                    }
                    
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    let preview = Preview(Book.self)
    preview.addExamples(Book.sampleBooks)
    return NavigationStack {
        BookList(sortOrder: .status, filterString: "")
    }.modelContainer(preview.container)
    
}
