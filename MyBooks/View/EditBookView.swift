//
//  EditBookView.swift
//  MyBooks
//
//  Created by Jamerson Macedo on 21/08/25.
//

import SwiftUI

struct EditBookView: View {
    @Environment(\.dismiss) private var dismiss
    let book : Book
    @State private var status = Status.onShelf
    @State private var rating : Int?
    @State private var title : String = ""
    @State private var author : String = ""
    @State private var synopsis : String = ""
    @State private var dateAdded = Date.distantPast
    @State private var dateStarted = Date.distantPast
    @State private var dateCompleted = Date.distantPast
    @State private var firstView = true
    @State private var recommendedBy = ""
    @State private var showGenres : Bool = false
    var changed : Bool{
        status != Status(rawValue:book.status)!
       || rating != book.rating
       || title != book.title
       || author != book.author
       || synopsis != book.synopsis
       || dateAdded != book.dateAdded
       || dateStarted != book.dateStarted
       || dateCompleted != book.dateCompleted
        || recommendedBy != book.recommendedBy
    }
    var body: some View {
        HStack{
            Text("Status")
            Picker("Status", selection: $status) {
                ForEach(Status.allCases) { status in
                    Text(status.description).tag(status) // a tag é como se fosse o status = novo status
                }
            }
            .buttonStyle(.bordered)
        }
        VStack(alignment:.leading){
            GroupBox{
                LabeledContent {
                    DatePicker("", selection: $dateAdded,displayedComponents: .date)
                } label: {
                    Text("Date added")
                }
                if status == .inProgress || status == .completed {
                    LabeledContent {
                        DatePicker("", selection: $dateStarted,in:dateAdded..., displayedComponents: .date)
                    } label: {
                        Text("Date Started")
                    }
                }
                if status == .completed {
                    LabeledContent {
                        DatePicker("", selection: $dateCompleted,in:dateStarted..., displayedComponents: .date)
                    } label: {
                        Text("Date Completed")
                    }
                }
                
            }
            .foregroundStyle(.secondary)
            .onChange(of: status) { oldValue, newValue in
                if !firstView{
                    // 📌 Caso 1: Se o novo status for "onShelf"
                    if newValue == .onShelf {
                        // Livro ainda não começou a ser lido → resetar as datas
                        dateStarted = Date.distantPast   // valor "nulo" simbólico
                        dateCompleted = Date.distantPast // idem
                        
                        // 📌 Caso 2: Mudou para "inProgress", mas veio de "completed"
                    } else if newValue == .inProgress && oldValue == .completed {
                        // Significa que estava finalizado e voltou para em andamento
                        // → apagar a data de término
                        dateCompleted = Date.distantPast
                        
                        // 📌 Caso 3: Mudou para "inProgress", mas veio de "onShelf"
                    } else if newValue == .inProgress && oldValue == .onShelf {
                        // Livro saiu da prateleira para leitura
                        // → definir a data de início como agora
                        dateStarted = Date.now
                        
                        // 📌 Caso 4: Mudou para "completed", mas veio de "onShelf"
                    } else if newValue == .completed && oldValue == .onShelf {
                        // Livro foi concluído direto da prateleira (sem passar por "inProgress")
                        // → definir a data de conclusão como agora
                        dateCompleted = Date.now
                        // → início é quando o livro foi adicionado
                        dateStarted = dateAdded
                        
                        // 📌 Caso 5: Todos os outros cenários
                    } else {
                        // Exemplo: mudou de "inProgress" para "completed"
                        // → define apenas a data de conclusão como agora
                        dateCompleted = Date.now
                    }
                    firstView = false
                }
            }
            Divider()
            LabeledContent {
                RatingsView(maxRating: 5, currentRating: $rating,width: 30)
            } label: {
                Text("Rating")
            }
            LabeledContent {
             TextField("", text: $title)
            } label: {
                Text("Title").foregroundStyle(.secondary)
            }
            LabeledContent {
             TextField("", text: $author)
            } label: {
                Text("Author").foregroundStyle(.secondary)
            }
            LabeledContent {
             TextField("", text: $recommendedBy)
            } label: {
                Text("Recommended By").foregroundStyle(.secondary)
            }
            Divider()
            Text("Synopsis").foregroundStyle(.secondary)
            TextEditor(text: $synopsis)
                .padding(5)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(uiColor: .tertiarySystemFill),lineWidth: 2))
            if let genres = book.genres{
                ViewThatFits { // se nao couber ele cria o scroll
                    GenreStackView(genres: genres)
                    ScrollView(.horizontal,showsIndicators: false){
                        GenreStackView(genres: genres)
                    }
                }
            }
            HStack {
                Button("Genres",systemImage: "bookmark.fill"){
                    showGenres.toggle()
                }.sheet(isPresented: $showGenres) {
                    GenresView(book: book)
                }
                NavigationLink{
                    QuotesListView(book: book)
                } label: {
                    let count = book.quotes?.count ?? 0
                    Label("\(count) Quotes", systemImage: "quote.opening")
                }
               
            } .buttonStyle(.bordered)
                .frame(maxWidth:.infinity,alignment:.trailing)
                .padding(.horizontal)
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if changed{
                Button("Update"){
                    book.status = status.rawValue
                    book.rating = rating
                    book.title = title
                    book.author = author
                    book.synopsis = synopsis
                    book.dateAdded = dateAdded
                    book.dateStarted = dateStarted
                    book.dateCompleted = dateCompleted
                    book.recommendedBy = recommendedBy
                    dismiss()
                }.buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            status = Status(rawValue:book.status)!
            rating = book.rating
            title = book.title
            author = book.author
            synopsis = book.synopsis
            dateAdded = book.dateAdded
            dateStarted = book.dateStarted
            dateCompleted = book.dateCompleted
            recommendedBy = book.recommendedBy
        }
    }
}

#Preview {
    let preview = Preview(Book.self)
   return NavigationStack{
       EditBookView(book: Book.sampleBooks[2])
           .modelContainer(preview.container)
   }
}
