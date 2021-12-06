//
//  InAppPurchaseProduct.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import Foundation

class InAppPurchaseProduct: Codable {

    enum ProductType: String, Codable {
        case yearly
    }

    var type: ProductType?
    private var expirationDateString: String?

    var expirationDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        return dateFormatter.date(from: expirationDateString ?? "") ?? Date()
    }

    private enum CodingKeys: String, CodingKey { // IMPORTANT: enum cases should be exhaustive!
        case type = "productType"
        case expirationDateString = "expirationDate"
    }

}

