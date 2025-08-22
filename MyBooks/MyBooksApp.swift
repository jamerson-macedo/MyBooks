//
//  MyBooksApp.swift
//  MyBooks
//
//  Created by Jamerson Macedo on 21/08/25.
//

import SwiftUI
import SwiftData
@main
struct MyBooksApp: App {
    let container : ModelContainer
    var body: some Scene {
        WindowGroup {
            BookListView()
        }//.modelContainer(for: Book.self)
        .modelContainer(container)
    }
    
    init(){
        let schema = Schema([Book.self])
        let config = ModelConfiguration("MyBooks", schema: schema) // definindo um nome e as entidades
        
        do {
            container = try ModelContainer(for: schema, configurations: config)
        }catch{
            fatalError("Could not configure the container")
        }
//        let config = ModelConfiguration(url: URL.documentsDirectory.appending(path: "MyBooks.store"))
//        do {
//            container = try ModelContainer(for: Book.self, configurations: config)
//        }catch {
//            fatalError("Could not configure the container")
//        }
    
        //print(URL.applicationSupportDirectory.path(percentEncoded: false))
        print(URL.documentsDirectory.path())
    }
}
