//
//  CreditCardView.swift
//  Spendthrift2
//
//  Created by Yulia Novikova on 9/10/21.
//

import SwiftUI

struct CreditCardView: View {
    
    let card: Card
    
    @State var refreshId = UUID()
    @State private var shouldShowActionSheet = false
    @State private var shouldShowEditView = false
    
    private var cardColor: Color {
        guard let data = card.color else { return .blue }
        return Color(UIColor.color(data: data) ?? .blue)
    }
    
    private func handleDelete() {
        let context = PersistenceController.shared.container.viewContext
        context.delete(card)
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private func handleEdit() {
        shouldShowEditView.toggle()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Text(card.name ?? "")
                    .font(.system(size: 24, weight: .semibold))
                Spacer()
                Button {
                    shouldShowActionSheet.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 24, weight: .bold))
                }
                .actionSheet(isPresented: $shouldShowActionSheet) {
                    .init(title: Text(card.name ?? ""),
                          buttons: [
                            .default(Text("Edit"), action: handleEdit),
                            .destructive(Text("Delete"), action: handleDelete),
                            .cancel()])
                }
            }
            
            
            HStack {
                Image("visa")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 44)
                    .clipped()
                Spacer()
                Text("Balance: $5,000")
                    .font(.system(size: 18, weight: .semibold))
            }
            
            Text(card.number ?? "")
            
            
            HStack {
                Text("Credit limit: $\(card.limit)")
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Valid thru")
                    Text("\(String(format: "%02d", card.expMonth))/\(String(card.expYear % 2000))")
                }
            }
            
        }
        .foregroundColor(.white)
        .padding()
        .background(
            LinearGradient(gradient: Gradient(
                            colors: [cardColor.opacity(0.6), cardColor]),
                            startPoint: .center,
                            endPoint: .bottom)
        )
        .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(8)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.top, 8)
        
        .fullScreenCover(isPresented: $shouldShowEditView) {
            AddCardForm(card: card)
        }
    }
}

struct CreditCardView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        MainView().environment(\.managedObjectContext, context)
    }
}
