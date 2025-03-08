//
//  CustomerViewModel.swift
//  CustomerList
//
//  Created by Preity Singh on 08/03/25.
//

import Foundation
import Combine

class CustomerViewModel: ObservableObject {
    @Published var customers: [Customer] = []
    @Published var searchText: String = ""
    @Published var isLoadingMore: Bool = false

    private var allCustomers: [Customer] = []
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    private let itemsPerPage = 10

    init() {
        loadCustomers()
        setupSearch()
    }

    private func loadCustomers() {
        if let url = Bundle.main.url(forResource: "customerSample", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decodedCustomers = try? JSONDecoder().decode(CustomerResponse.self, from: data) {
            
            self.allCustomers = decodedCustomers.customer
            self.customers = Array(allCustomers.prefix(itemsPerPage)) // Load first set
        }
    }

    private func setupSearch() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.filterCustomers(searchText: searchText)
            }
            .store(in: &cancellables)
    }

    private func filterCustomers(searchText: String) {
        if searchText.isEmpty {
            customers = Array(allCustomers.prefix(itemsPerPage))
        } else {
            customers = allCustomers.filter { customer in
                customer.displayName.lowercased().contains(searchText.lowercased()) ||
               ((customer.locations.first?.city.lowercased().contains(searchText.lowercased())) ?? false)
            }
        }
    }

    // Lazy Loading Logic
    func shouldLoadMore(customer: Customer) -> Bool {
        return customers.last?.id == customer.id && !isLoadingMore
    }

    func loadMoreCustomers() {
        guard customers.count < allCustomers.count else { return }

        isLoadingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
            let nextBatch = allCustomers.dropFirst(customers.count).prefix(itemsPerPage)
            customers.append(contentsOf: nextBatch)
            isLoadingMore = false
        }
    }

    func toggleActiveStatus(for customer: Customer) {
        if let index = customers.firstIndex(where: { $0.id == customer.id }) {
            customers[index].isActive.toggle()
        }
    }

    func deleteCustomer(_ customer: Customer) {
        customers.removeAll { $0.id == customer.id }
    }
}

