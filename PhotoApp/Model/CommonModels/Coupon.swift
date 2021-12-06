//
//  Coupon.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import Foundation

class Coupon: Codable {
    var code: String?
    var canBeUsed: Bool?
    var products: [InAppPurchaseProduct]?
}

