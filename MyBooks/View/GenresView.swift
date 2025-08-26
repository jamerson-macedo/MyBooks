//
//  GenresView.swift
//  MyBooks
//
//  Created by Jamerson Macedo on 25/08/25.
//

import SwiftData
import SwiftUI
struct GenresView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Bindable var book: Book // nesse caso a uireage automaticamente a cada mudança
    @Query(sort: \Genre.name) var genres: [Genre]
    @State private var newGenre = false
    var body: some View {
        NavigationStack {
            Group {
                if genres.isEmpty {
                    ContentUnavailableView {
                        Image(systemName: "bookmark.fill")
                            .font(.largeTitle)
                    } description: {
                        Text("You need to create some genres first.")
                    } actions: {
                        Button("Create Genre") {
                            newGenre.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List {
                        ForEach(genres) { genre in
                            HStack {
                                if let bookGenres = book.genres {
                                    if bookGenres.isEmpty {
                                        Button {
                                            addRemove(genre)
                                        } label: {
                                            Image(systemName: "circle")
                                        }
                                        .foregroundStyle(genre.hexColor)
                                    } else {
                                        Button {
                                            addRemove(genre)
                                        } label: {
                                            Image(systemName: bookGenres.contains(genre) ? "circle.fill" : "circle")
                                        }
                                        .foregroundStyle(genre.hexColor)
                                    }
                                }
                                Text(genre.name)
                            }
                        }
                        .onDelete(perform: { indexSet in
                            indexSet.forEach { index in
                                if let bookGenres = book.genres,
                                   bookGenres.contains(genres[index]),
                                   let bookGenreIndex = bookGenres.firstIndex(where: {$0.id == genres[index].id}) {
                                    book.genres?.remove(at: bookGenreIndex)
                                }
                                context.delete(genres[index])
                            }
                        })
                        LabeledContent {
                            Button {
                                newGenre.toggle()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.large)
                            }
                            .buttonStyle(.borderedProminent)
                        } label: {
                            Text("Create new Genre")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle(book.title)
            .sheet(isPresented: $newGenre) {
                NewGenreView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
    }
    func addRemove(_ genre: Genre) {
        // Tenta pegar os gêneros atuais do livro
        if let bookGenres = book.genres {
            
            // Se a lista estiver vazia, adiciona o gênero direto
            if bookGenres.isEmpty {
                book.genres?.append(genre)
            } else {
                // Se a lista não estiver vazia
                if bookGenres.contains(genre),                     // Verifica se o gênero já está na lista
                   let index = bookGenres.firstIndex(where: { $0.id == genre.id }) { // Encontra o índice do gênero
                    book.genres?.remove(at: index)                // Remove o gênero existente (toggle off)
                } else {
                    book.genres?.append(genre)                    // Caso contrário, adiciona o gênero (toggle on)
                }
            }
        }
    }
}

#Preview {
    let preview = Preview(Book.self)
    let book = Book.sampleBooks
    let genres = Genre.sampleGenres
    preview.addExamples(genres)
    preview.addExamples(book)
    book[1].genres?.append(genres[0])
    return NavigationStack{
        GenresView(book: book[1])
            .modelContainer(preview.container)
    }
}
