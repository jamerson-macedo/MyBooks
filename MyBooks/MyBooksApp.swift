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
    var body: some Scene {
        WindowGroup {
            BookListView()
        }.modelContainer(for: Book.self)
    }
    
    init(){
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
