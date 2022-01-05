//
//  SubscriptionModel.swift
//  PhotoApp
//
//  Created by Ali on 5.01.2022.
//

import Foundation
import Purchases

struct SubscriptionModel {
    var id: Int?
    var mainTitle: String?
    var subTitle: String?
    var price: String?
    var isDeal: Bool?
    var dealTitle: String?
    var package: Purchases.Package
    
    init(id: Int?, mainTitle: String, subtitle: String, price: String, isDeal: Bool, package: Purchases.Package, dealTitle: String) {
        self.id = id
        self.mainTitle = mainTitle
        self.subTitle = subtitle
        self.price = price
        self.isDeal = isDeal
        self.package = package
        self.dealTitle = dealTitle
    }
}

