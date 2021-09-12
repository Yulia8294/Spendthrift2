//
//  TransactionView.swift
//  Spendthrift2
//
//  Created by Yulia Novikova on 9/13/21.
//

import SwiftUI

struct TransactionsView: View {
    
    @State private var shouldShowAddTransactionForm = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CardTransaction.timestamp, ascending: false)],
        animation: .default)
    private var transactions: FetchedResults<CardTransaction>
    
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
                AddTransactionForm()
            }
            
            ForEach(transactions) { transaction in
                TransactionCardView(transaction: transaction)
                 
            }
        }
    }
}

struct TransactiosnView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        TransactionsView()
            .environment(\.managedObjectContext, context)
    }
}
