//
//  MainView.swift
//  Spendthrift2
//
//  Created by Yulia Novikova on 9/6/21.
//

import SwiftUI

struct MainView: View {
    
    @State private var shouldPresentAddCardForm = false
    @State private var shouldShowAddTransactionForm = false
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: false)],
        animation: .default)
    private var cards: FetchedResults<Card>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CardTransaction.timestamp, ascending: false)],
        animation: .default)
    private var transactions: FetchedResults<CardTransaction>
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                if !cards.isEmpty {
                    TabView {
                        ForEach(cards) { card in
                            CreditCardView(card: card)
                                .padding(.bottom, 50)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 280)
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    
                    Text("Get started by adding your first transaction")
                        .padding(5)
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
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(transaction.name ?? "")
                                        .font(.headline)
                                    if let date = transaction.date {
                                        Text(dateFormatter.string(from: date))
                                    }
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .font(.system(size: 24))
                                    }.padding(EdgeInsets(top: 6, leading: 8, bottom: 4, trailing: 0))
                                    
                                    Text("$" + String(format: "%.2f", transaction.amount))
                                    
                                }
                                
                            }
                            
                            if let photoData = transaction.photoData,
                               let uiImage = UIImage(data: photoData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
                        .foregroundColor(Color(.label))
                        .padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(radius: 5)
                        .padding()
                    }
                    
                } else {
                    emptyPromptMessage
                }
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm, onDismiss: nil) {
                        AddCardForm()
                    }
            }
            .navigationTitle("Credit card")
            .navigationBarItems(leading: HStack {
                addItemButton
                deleteAllButton
            },
            trailing: addCardButton)
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    private var emptyPromptMessage: some View {
        VStack {
            Text("You currently have no cards in the system")
                .font(.system(size: 20, weight: .semibold))
                .padding(.horizontal, 48)
                .padding(.vertical)
                .multilineTextAlignment(.center)

            Button(action: {
                shouldPresentAddCardForm.toggle()
            }, label: {
                Text("+ Add your first card")
            })
            .font(.system(size: 24, weight: .semibold))
            .foregroundColor(Color(.systemBackground))
            .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
            .background(Color(.label))
            .cornerRadius(5)
        }
    }
    
    var deleteAllButton: some View {
        Button(action: {
            cards.forEach { card in
                viewContext.delete(card)
            }
            do {
                try viewContext.save()
            } catch {
            }
        }, label: {
            Text("Delete all")
        })
    }
    
    var addCardButton: some View {
        Button(action: {
            shouldPresentAddCardForm.toggle()
        }, label: {
            Text("+ Card")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
                .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                .background(Color.black)
                .cornerRadius(5)
        })
    }
    
    var addItemButton: some View {
        Button(action: {
            withAnimation {
                let card = Card(context: viewContext)
                card.timestamp = Date()
                
                do {
                    try viewContext.save()
                } catch {
                }
                
            }
        }, label: {
            Text("Add Item")
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        MainView()
            .environment(\.managedObjectContext, context)
    }
}
