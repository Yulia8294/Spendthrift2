//
//  AddCardView.swift
//  Spendthrift2
//
//  Created by Yulia Novikova on 9/6/21.
//

import SwiftUI

struct AddCardForm: View {
    
    let card: Card?
    
    init(card: Card? = nil) {
        self.card = card
        
        _name = State(initialValue: card?.name ?? "")
        _number = State(initialValue: card?.number ?? "")
        _cardType = State(initialValue: card?.type ?? "")
        _month = State(initialValue: Int(card?.expMonth ?? 1))
        _year = State(initialValue: Int(card?.expYear ?? Int16(currentYear)))
        
        if let limit = card?.limit {
            _limit = State(initialValue: String(limit))
        }

        if let color = card?.color {
            _color = State(initialValue: Color(UIColor.color(data: color) ?? .blue))
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var number = ""
    @State private var limit = ""
    
    @State private var cardType = "Visa"
    @State private var month = 1
    @State private var year = Calendar.current.component(.year, from: Date())
    
    @State private var color: Color = .blue
    
    let currentYear = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("Card Info")) {
                    TextField("Name", text: $name)
                    TextField("Credit card number", text: $number)
                        .keyboardType(.numberPad)
                    TextField("Credit Limit", text: $limit)
                        .keyboardType(.numberPad)
                    
                    Picker("Type", selection: $cardType) {
                        ForEach(["Visa", "Mastercard", "Discover"], id: \.self) { cardType in
                            Text(String(cardType)).tag(String(cardType))
                        }
                    }
                }
                
                Section(header: Text("Expiration")) {
                    Picker("Month", selection: $month) {
                        ForEach(1..<13, id: \.self) { num in
                            Text(String(num)).tag(String(num))
                        }
                    }
                    
                    Picker("Year", selection: $year) {
                        ForEach(currentYear..<currentYear + 20, id: \.self) { num in
                            Text(String(num)).tag(String(num))
                        }
                    }
                }
                
                Section(header: Text("Color")) {
                    ColorPicker("Color", selection: $color)
                }
                
            }
            .navigationTitle(title)
            .navigationBarItems(leading: cancelButton,
                                trailing: saveButton)
        }
    }
    
    private var title: String {
        card == nil ? "Add Credit Card" : "Edit Credit Card"
    }
    
    var cancelButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Cancel")
        })
    }
    
    var saveButton: some View {
        Button(action: {
            let context = PersistenceController.shared.container.viewContext
            let card = card ?? Card(context: context)
            card.name = name
            card.number = number
            card.limit = Int32(limit) ?? 0
            card.expMonth = Int16(month)
            card.expYear = Int16(year)
            card.timestamp = Date()
            card.type = cardType
            card.color = UIColor(color).encode()
            
            do {
                try context.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                print("Failed to persist new card: \(error)")
            }
            
        }, label: {
            Text("Save")
        })
    }
}

struct AddCardForm_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        MainView()
            .environment(\.managedObjectContext, context)
    }
}


