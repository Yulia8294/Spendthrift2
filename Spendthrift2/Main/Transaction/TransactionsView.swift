//
//  TransactionView.swift
//  Spendthrift2
//
//  Created by Yulia Novikova on 9/13/21.
//

import SwiftUI
import CoreData

struct TransactionsView: View {
    
    let card: Card
    
    init(card: Card) {
        self.card = card
        fetchRequest = FetchRequest<CardTransaction>(entity: CardTransaction.entity(), sortDescriptors: [.init(key: "timestamp", ascending: false)], predicate: .init(format: "card == %@", self.card))
    }
    
    var fetchRequest: FetchRequest<CardTransaction>

    @State private var shouldShowAddTransactionForm = false
    
    var body: some View {
        
        VStack {
            Text("Get started by adding your first transaction").padding(5)
            
            Button {
                shouldShowAddTransactionForm.toggle()
            } label: {
                Text("+ Transaction")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(.systemBackground))
                    .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                    .background(Color(.label))
                    .cornerRadius(5)
            }
            .fullScreenCover(isPresented: $shouldShowAddTransactionForm) {
                AddTransactionForm(card: self.card)
            }
            
            ForEach(fetchRequest.wrappedValue) { transaction in
                TransactionCardView(transaction: transaction)
                 
            }
        }
    }
}

struct TransactiosnView_Previews: PreviewProvider {
    static let firstCard: Card? = {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<Card> = Card.fetchRequest()
        request.sortDescriptors = [.init(key: "timestamp", ascending: false)]
        return try? context.fetch(request).first
    }()
    
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        TransactionsView(card: firstCard ?? Card())
            .environment(\.managedObjectContext, context)
    }
}
