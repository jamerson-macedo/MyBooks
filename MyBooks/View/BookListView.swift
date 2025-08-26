//
//  ContentView.swift
//  MyBooks
//
//  Created by Jamerson Macedo on 21/08/25.
//

import SwiftUI
import SwiftData
enum SortOrder : String, CaseIterable, Identifiable {
    case title
    case author
    case status
    
    var id: Self {
        self
    }
}
struct BookListView: View {
   
    @State private var createNewBook = false
    @State private var sortOrder: SortOrder = .status
    @State private var filter = ""
    var body: some View {
        NavigationStack{
            Picker("", selection: $sortOrder) {
                ForEach(SortOrder.allCases){ sortOrder in
                    Text("Sort by \(sortOrder)").tag(sortOrder)
                }
            }.buttonStyle(.bordered)
            BookList(sortOrder: sortOrder, filterString: filter)
                .searchable(text: $filter,prompt: "Filter on title or author")
            .navigationTitle("My Books")
            .toolbar {
                Button {
                    createNewBook.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                }
                
            }
            .sheet(isPresented: $createNewBook) {
                NewBookView().presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    let preview = Preview(Book.self)
    let books = Book.sampleBooks
    let genres = Genre.sampleGenres
    preview.addExamples(books)
    preview.addExamples(genres)
  return BookListView().modelContainer(preview.container)
}

struct BookRow: View {
    var book : Book
    var body: some View {
        HStack(spacing:10){
            book.icon
            VStack(alignment: .leading){
                Text(book.title).font(.title2)
                Text(book.author).foregroundStyle(.secondary)
                if let rating = book.rating{
                    HStack{
                        ForEach(1..<rating, id:\.self){ _ in
                            Image(systemName: "star.fill")
                                .imageScale(.small)
                                .foregroundStyle(.yellow)
                        }
                    }
                }
                if let genres = book.genres{
                    ViewThatFits { // se nao couber ele cria o scroll
                        GenreStackView(genres: genres)
                        ScrollView(.horizontal,showsIndicators: false){
                            GenreStackView(genres: genres)
                        }
                    }
              
                }
            }
        }
    }
}
