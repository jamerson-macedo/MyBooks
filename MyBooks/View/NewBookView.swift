//
//  NewBookView.swift
//  MyBooks
//
//  Created by Jamerson Macedo on 21/08/25.
//

import SwiftUI

struct NewBookView: View {
    @State var title: String = ""
    @State var author: String = ""
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Book Title", text: $title)
                TextField("Author", text: $author)
                Button("Create") {
                    let newBook = Book(title: title, author: author)
                    context.insert(newBook)
                    dismiss()
                }
                .frame(maxWidth:.infinity,alignment: .trailing)
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                .disabled(title.isEmpty || author.isEmpty)
                .navigationTitle("New Book")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement:.topBarLeading) {
                        Button("Cancel"){
                            dismiss()
                        }
                    }
                }
                    

            }
        }
    }
}

#Preview {
    NewBookView()
}
