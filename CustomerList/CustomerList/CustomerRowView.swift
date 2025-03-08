//
//  CustomerRowView.swift
//  CustomerList
//
//  Created by Preity Singh on 08/03/25.
//


import SwiftUI

struct CustomerRowView: View {
    let customer: Customer
    let onToggleActive: () -> Void
    let onDelete: () -> Void

    @State private var showActionSheet = false
    @State private var showDeleteAlert = false
    @Binding var showToastMessage: String?  /// Bind global toast state

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                   HStack{
                      Text(customer.displayName)
                          .font(.headline)
                          .opacity(customer.isActive ? 1.0 : 0.5)
                      
                      if (customer.locationErrors != nil) {
                          Image(systemName: "location.north.circle.fill")
                              .foregroundColor(.red)
                              .opacity(customer.isActive ? 1.0 : 0.5)
                      }
                   }
                    Text(customer.locations.first?.city ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .opacity(customer.isActive ? 1.0 : 0.5)
                }
            
                Spacer()
                Button(action: {
                    showActionSheet = true
                }) {
                    Image(systemName: "ellipsis")
                        .padding()
                }
                .confirmationDialog("Actions", isPresented: $showActionSheet, titleVisibility: .visible) {
                    Button("Edit", role: .none) {}
                    Button(customer.isActive ? "Deactivate" : "Activate", action: onToggleActive)
                    Button("Delete", role: .destructive) { showDeleteAlert = true }
                    Button("Cancel", role: .cancel) {}
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        .alert("Delete Customer", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Confirm", role: .destructive) {
                onDelete()
                showToastMessage = "\(customer.displayName) is deleted" /// Set global toast
            }
        } message: {
            Text("Are you sure you want to delete \(customer.displayName)?")
        }
    }
}
