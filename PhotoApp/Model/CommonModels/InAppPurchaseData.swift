//
//  InAppPurchaseData.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import Foundation

class InAppPurchaseData: Codable {
    var productIdentifiers: [String]?
    var subscribeButtonTitle: String?
    var isWeeklyGiftActive: Bool?
}
