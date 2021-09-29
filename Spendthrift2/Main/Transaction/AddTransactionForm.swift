//
//  AddTransactionForm.swift
//  Spendthrift2
//
//  Created by Yulia Novikova on 9/10/21.
//

import SwiftUI
import CoreData

struct AddTransactionForm: View {
    
    let card: Card

    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var amount = ""
    @State private var date = Date()
    @State private var photoData: Data?
    
    @State private var shouldPresentPhotoPicker = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Information")) {
                    TextField("Name", text: $name)
                    TextField("Ammount", text: $amount)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section(header: Text("Categories")) {
                    NavigationLink {
                        CategoriesListView()
                            .navigationTitle("New title")
                    } label: {
                        Text("Select categories")
                    }

                }
                
                Section(header: Text("Photo/Receipt")) {
                    
                    Button {
                        shouldPresentPhotoPicker.toggle()
                    } label: {
                        Text("Select Photo")
                    }
                    .fullScreenCover(isPresented: $shouldPresentPhotoPicker) {
                        PhotoPickerView(photoData: $photoData)
                    }
                    
                    if let data = photoData, let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    }
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }
    
    
    private var cancelButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel")
        }
    }
    
    private var saveButton: some View {
        Button {
            let context = PersistenceController.shared.container.viewContext
            let transaction = CardTransaction(context: context)
            transaction.name = name
            transaction.date = date
            transaction.amount = Float(amount) ?? 0
            transaction.timestamp = Date()
            transaction.photoData = photoData
            transaction.card = card
            
            do {
                try context.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                print(error)
            }
            
        } label: {
            Text("Save")
        }
    }
}

struct AddTransactionForm_Previews: PreviewProvider {
    static let firstCard: Card? = {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        request.sortDescriptors = [.init(key: "timestamp", ascending: false)]
        return try? context.fetch(request).first
    }()
    
    static var previews: some View {
        AddTransactionForm(card: firstCard ?? Card())
    }
}
