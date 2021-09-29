//
//  TransactionCardView.swift
//  Spendthrift2
//
//  Created by Yulia Novikova on 9/13/21.
//

import SwiftUI

struct TransactionCardView: View {
    
    let transaction: CardTransaction
    
    @State private var shoulPresentActionSheet = false
        
        var body: some View {
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
                            shoulPresentActionSheet.toggle()
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 24))
                        }
                        .padding(EdgeInsets(top: 6, leading: 8, bottom: 4, trailing: 0))
                        .actionSheet(isPresented: $shoulPresentActionSheet, content: {
                            .init(title: Text(transaction.name ?? ""), message: nil, buttons: [
                                .destructive(Text("Delete"), action: handleDelete),
                                .cancel()
                            ])
                        })
                        
                        Text("$" + String(format: "%.2f", transaction.amount))
                        
                    }
                    
                }
                
                if let cats = transaction.categories as? Set<TransactionCategory> {
                    
                    let sortedCats = Array(cats)
                        .sorted { $0.timestamp?.compare($1.timestamp ?? Date()) == .orderedDescending }
    
                    HStack {
                        ForEach(sortedCats, id: \.self) { cat in
                            HStack(spacing: 12) {
                                if let data = cat.colorData, let uiColor = UIColor.color(data: data) {
                                    let color = Color(uiColor)
                                    Text(cat.name ?? "")
                                        .font(.system(size: 16, weight: .semibold))
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 8)
                                        .background(color)
                                        .foregroundColor(.white)
                                        .cornerRadius(5)
                                }
                            }
                        }
                        Spacer()
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
    
    private func handleDelete() {
        withAnimation {
            let context = PersistenceController.shared.container.viewContext
            context.delete(transaction)
            
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}

struct TransactionCardView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionCardView(transaction: CardTransaction())
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
