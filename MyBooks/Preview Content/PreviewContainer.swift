//
//  PreviewContainer.swift
//  MyBooks
//
//  Created by Jamerson Macedo on 21/08/25.
//

import Foundation
import SwiftData
struct Preview {
    let container : ModelContainer
    init(_ models: any PersistentModel.Type...) { 
        let config = ModelConfiguration(isStoredInMemoryOnly: true) // os dados fica so na memoria não no disco
        let schema = Schema(models)
        do {
            container = try ModelContainer(for:schema, configurations: config)
        }catch {
            fatalError("Could not create preview container")
        }
    }
    func addExamples(_ examples : [any PersistentModel]) {
        Task { @MainActor in 
            examples.forEach { example in
                container.mainContext.insert(example)
                
            }
        }
       
    }
}
