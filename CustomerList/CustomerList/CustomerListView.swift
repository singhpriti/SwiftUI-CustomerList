//
//  CustomerListView.swift
//  CustomerList
//
//  Created by Preity Singh on 08/03/25.
//

import SwiftUI

struct CustomerListView: View {
    @StateObject private var viewModel = CustomerViewModel()
    @State private var toastMessage: String?

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    /// (No action)
                }) {
                    Image(systemName: "arrow.left")
                      .foregroundColor(.white)
                }
                Spacer()
                
                Text("CUSTOMERS")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    /// (No action)
                }) {
                    Image(systemName: "xmark")
                      .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color(red: 41/255, green: 41/255, blue: 41/255))

            //MARK: Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search", text: $viewModel.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 1))
            .padding(.horizontal)

            /// Lazy List with Infinite Scroll
            List {
                ForEach(viewModel.customers) { customer in
                    CustomerRowView(
                        customer: customer,
                        onToggleActive: { viewModel.toggleActiveStatus(for: customer) },
                        onDelete: { viewModel.deleteCustomer(customer) },
                        showToastMessage: $toastMessage
                    )
                    .onAppear {
                       viewModel.shouldLoadMore(customer: customer)
                    }
                }

                /// Loading Indicator
                if viewModel.isLoadingMore {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .listStyle(PlainListStyle())

            /// Toast Message
            if let toast = toastMessage {
                Text(toast)
                    .font(.body)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            toastMessage = nil
                        }
                    }
            }
        }
    }
}

struct CustomerListView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerListView()
    }
}


