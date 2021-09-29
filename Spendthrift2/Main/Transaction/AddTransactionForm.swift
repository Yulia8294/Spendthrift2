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
    
    @State private var selectedCategories = Set<TransactionCategory>()

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
                        CategoriesListView(selectedCategories: $selectedCategories)
                            .navigationTitle("Categoreis")
                            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                    } label: {
                        Text("Select categories")
                    }
                    
                    let sortedCategories = Array(selectedCategories).sorted(by: { $0.timestamp?.compare($1.timestamp ?? Date()) == .orderedDescending})
                    
                    ForEach(Array(sortedCategories)) { cat in
                        HStack(spacing: 12) {
                            if let data = cat.colorData, let uiColor = UIColor.color(data: data) {
                                let color = Color(uiColor)
                                Spacer()
                                    .frame(width: 30, height: 10)
                                    .background(color)
                                    .cornerRadius(3)
                            }
                            Text(cat.name ?? "")
                        }
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
            transaction.categories = selectedCategories as NSSet
            
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
