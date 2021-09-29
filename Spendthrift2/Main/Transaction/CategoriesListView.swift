//
//  CategoriesListView.swift
//  Spendthrift2
//
//  Created by Yulia Novikova on 9/29/21.
//

import SwiftUI

struct CategoriesListView: View {
    
    @State private var name = ""
    @State private var color = Color.red
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionCategory.timestamp, ascending: false)],
        animation: .default)
    private var categories: FetchedResults<TransactionCategory>
    
    var body: some View {
        Form {
            Section(header: Text("Select a category")) {
                ForEach(categories) { category in
                    HStack(spacing: 10) {
                        if let data = category.colorData, let uiColor = UIColor.color(data: data) {
                            let color = Color(uiColor)
                            Spacer()
                                .frame(width: 30, height: 10)
                                .background(color)
                                .cornerRadius(3)
                        }
                        
                        Text(category.name ?? "")

                    }
                }
            }
            
            Section(header: Text("Create a category")) {
                TextField("Name", text: $name)
                
                ColorPicker("Color", selection: $color)
                
                Button(action: handleCreate) {
                    HStack {
                        Spacer()
                        Text("Create")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(5)
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private func handleCreate() {
        let context = PersistenceController.shared.container.viewContext
        
        let category = TransactionCategory(context: context)
        category.name = self.name
        category.colorData = UIColor(color).encode()
        category.timestamp = Date()
        
        try? context.save()
        
        self.name = ""
    }
}

struct CategoriesListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesListView()
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
