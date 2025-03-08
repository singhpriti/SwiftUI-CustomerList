//
//  CustomerModel.swift
//  CustomerList
//
//  Created by Preity Singh on 07/03/25.
//

// MARK: - Customer Response
struct CustomerResponse: Codable {
    let customer: [Customer]
}

// MARK: - Customer Model
struct Customer: Identifiable, Codable {
    let id: String
    let companyId: Int
    let displayName: String
    let emailAddress: String?
    let phone: String?
    let type: String
    let status: Int
    var isActive: Bool
    let createdOn: String
    let locations: [Location]
    let locationErrors: [LocationError]?
    
    enum CodingKeys: String, CodingKey {
        case id = "CustomerId"
        case companyId = "CompanyId"
        case displayName = "DisplayName"
        case emailAddress = "EmailAddress"
        case phone = "Phone"
        case type = "Type"
        case status = "Status"
        case isActive = "IsActive"
        case createdOn = "CreatedOn"
        case locations = "Locations"
        case locationErrors = "LocationErrors"
    }
}

// MARK: - Location Model
struct Location: Codable {
    let locationId: Int
    let city: String
    
    enum CodingKeys: String, CodingKey {
        case locationId = "LocationId"
        case city = "City"
    }
}

// MARK: - Location Error Model
struct LocationError: Codable {
    let errorType: String
    let errorMessage: String
   
   enum CodingKeys: String, CodingKey{
      case errorType = "ErrorType"
      case errorMessage = "ErrorMessage"
   }
}
