//
//  QuotesListView.swift
//  MyBooks
//
//  Created by Jamerson Macedo on 25/08/25.
//

import SwiftUI

struct QuotesListView: View {
    @Environment(\.modelContext) private var  modelContext
    let book : Book
    @State private var text: String = ""
    @State private var page = ""
    @State private var selectedQuote: Quote?
    var isEditing : Bool{
        selectedQuote != nil
    }
    var titleButton : String {
        isEditing ? "Update" : "Create"
    }
    var body: some View {
        GroupBox{
            HStack{
                LabeledContent("Page"){
                    TextField("page #", text: $page)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 150)
                    Spacer()
                }
                // se tiver alguma coisa escrita vai aparece o botao de resetar tudo
                if isEditing{
                    Button("Cancel"){
                        page = ""
                        text = ""
                        selectedQuote = nil
                    }.buttonStyle(.bordered)
                }
                // sempre vai ter esse botão
                Button(titleButton){
                    // se tiver alguma coisa preenche a quote com os novos dados e apaga
                    if isEditing {
                        selectedQuote?.text = text
                        selectedQuote?.page = page.isEmpty ? nil : page
                        page = ""
                        text = ""
                        selectedQuote = nil
                    }else{
                        // se a page for vazia manda so o texto
                        let quote = page.isEmpty ? Quote(text: text) : Quote(text: text, page: page)
                        book.quotes?.append(quote)
                        text = ""
                        page = ""
                    }
                    
                }.buttonStyle(.borderedProminent)
                    .disabled(text.isEmpty)

            }
            TextEditor(text: $text)
                .border(Color.secondary)
                .frame(height: 150)
                
        }
        .padding(.horizontal)
        List{
            // cria uma ordenaçcao
            let sortedQuotes = book.quotes?.sorted(using: KeyPathComparator(\Quote.creationDate)) ?? []
            ForEach(sortedQuotes){ quote in
                VStack(alignment: .leading){
                    Text(quote.creationDate,format: .dateTime.month().day().year())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(quote.text)
                    HStack{
                        Spacer()
                        if let page = quote.page, !page.isEmpty{
                            Text("Page: \(page)")
                        }
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedQuote = quote
                    text = quote.text
                    page = quote.page ?? ""
                }
                
            }.onDelete { indexSet in
                withAnimation {
                    indexSet.forEach { index in
                        if let quotes = book.quotes?[index]{
                            modelContext.delete(quotes)
                        }
                    }
                }
              
            }
            
        }
        .listStyle(.plain)
        .navigationTitle("Quotes")
    }
}

#Preview {
    let preview = Preview(Book.self)
    let books = Book.sampleBooks
    preview.addExamples(books)
    return NavigationStack{QuotesListView(book: books[1])
            .navigationBarTitleDisplayMode(.inline)
            .modelContainer(preview.container)
    }
}
