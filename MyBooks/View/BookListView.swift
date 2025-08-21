//
//  ContentView.swift
//  MyBooks
//
//  Created by Jamerson Macedo on 21/08/25.
//

import SwiftUI
import SwiftData
struct BookListView: View {
    @Environment(\.modelContext) private var context
    @Query(sort:\Book.title) private var books: [Book]
    @State private var createNewBook = false
    var body: some View {
        NavigationStack{
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
    BookListView().modelContainer(for:Book.self,inMemory: true)
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
            }
        }
    }
}
