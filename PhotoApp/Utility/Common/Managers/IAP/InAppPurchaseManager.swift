//
//  InAppPurchaseManager.swift
//  PhotoApp
//
//  Created by Ali on 5.12.2021.
//

import StoreKit
import SVProgressHUD

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

class InAppPurchaseManager: NSObject  {
    
    static let premiumYearly = "yearly2"
    static let premiumMonthly = "monthly"
    static let premiumWeekly = "weekly"

    private var productIdentifiers: Set<ProductIdentifier> {
        return Set(Constants().inAppPurchaseData?.productIdentifiers ?? [InAppPurchaseManager.premiumMonthly, InAppPurchaseManager.premiumYearly])
    }

    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    var products: [SKProduct] = []

    var weeklyGift: SKProduct?
    
    static let shared: InAppPurchaseManager = InAppPurchaseManager()
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        
        requestProducts { (success, products) in
            guard success, let products = products else { return }
            self.products = products
        }
    }
}

// MARK: - StoreKit API
extension InAppPurchaseManager {
    
    public func requestProducts(withIdentifiers identifiers: Set<String>? = nil, _ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: identifiers ?? self.productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }

    public func requestReceiptRefresh() {
        let receiptRefreshRequest = SKReceiptRefreshRequest()
        receiptRefreshRequest.cancel()
        receiptRefreshRequest.delegate = self
        receiptRefreshRequest.start()
    }
    
    public func buyProduct(_ product: SKProduct) {
        SVProgressHUD.show()
        
        guard InAppPurchaseManager.canMakePayments() else {
            SVProgressHUD.dismiss()
            return
        }
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SVProgressHUD.show()
        guard InAppPurchaseManager.canMakePayments() else {
            SVProgressHUD.dismiss()
            return
        }

        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func receiptValidation(for environment: String = "Production") {

        guard LocalStorageManager.shared.isPremiumUser else { return }

        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
        FileManager.default.fileExists(atPath: appStoreReceiptURL.path) else {
            self.requestReceiptRefresh()
            return
        }

        do {
            let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
            print(receiptData)

            let receiptString = receiptData.base64EncodedString(options: [])

            // Read receiptData
            let jsonDict: [String: AnyObject] = ["receipt-data" : receiptString as AnyObject, "password" : "aab0eaf902834be29aa189230bab5da4" as AnyObject]

            do {
                let requestData = try JSONSerialization.data(withJSONObject: jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted)
                let verifyUrlString = environment == "Production" ? "https://buy.itunes.apple.com/verifyReceipt" : "https://sandbox.itunes.apple.com/verifyReceipt"
                let storeURL = URL(string: verifyUrlString)!
                var storeRequest = URLRequest(url: storeURL)
                storeRequest.httpMethod = "POST"
                storeRequest.httpBody = requestData

                let session = URLSession(configuration: URLSessionConfiguration.default)
                let task = session.dataTask(with: storeRequest, completionHandler: { [weak self] (data, response, error) in
                    guard let data = data, let self = self, error == nil else {return}

                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                        print("=======>",jsonResponse)
                        if let jsonDict = jsonResponse as? NSDictionary {
                            if (jsonDict["status"] as? Int) == 21007 {
                                print("---retrying with Sandbox environment")
                                self.receiptValidation(for: "Sandbox")
                                return
                            }
                        }
                        if let date = self.getExpirationDateFromResponse(jsonResponse as! NSDictionary) {
                            LocalStorageManager.shared.purchaseExpirationDate = date
                            LocalStorageManager.shared.isPremiumUser = date > Date()
                        }

                        if environment == "Sandbox" {
                            LocalStorageManager.shared.purchaseExpirationDate = Date().addingTimeInterval(60*60)
                            LocalStorageManager.shared.isPremiumUser = true
                        }

                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                        }
                    } catch let parseError {
                        print(parseError)
                    }
                })
                task.resume()
            } catch let parseError {
                print(parseError)

                SVProgressHUD.dismiss()
            }
        }
        catch {
            print("Couldn't read receipt data with error: " + error.localizedDescription)
            SVProgressHUD.dismiss()
        }
        

    }

    func requestDidFinish(_ request: SKRequest) {
        receiptValidation()
    }
    
    func getExpirationDateFromResponse(_ jsonResponse: NSDictionary) -> Date? {
        
        if let receiptInfo: NSArray = jsonResponse["latest_receipt_info"] as? NSArray {
            
            let lastReceipt = receiptInfo.lastObject as! NSDictionary
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
            
            if let expiresDate = lastReceipt["expires_date"] as? String {
                return formatter.date(from: expiresDate)
            }
            
            return nil
        }
        else {
            return nil
        }
    }
}

// MARK: - SKProductsRequestDelegate
extension InAppPurchaseManager: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products.sorted { $0.price.floatValue < $1.price.floatValue }
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

// MARK: - SKPaymentTransactionObserver
extension InAppPurchaseManager: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restored(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("Transaction completed successfully!")
        SVProgressHUD.dismiss()
    
        LocalStorageManager.shared.isPremiumUser = true
        
        receiptValidation()
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restored(transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
        SVProgressHUD.dismiss()
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        SVProgressHUD.dismiss()
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}

extension SKProduct {

    func getLocalizedPrice(duration: Int = 1) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        let durationPrice = NSNumber(value: (self.price.floatValue / Float(duration)) - (duration > 1 ? 0.01 : 0.00))
        return formatter.string(from: durationPrice) ?? "?"
    }
    
    @available(iOS 11.2, *)
    func getIntroductoryPeriodInDays() -> Int {
        if let period = self.introductoryPrice?.subscriptionPeriod {
            return period.numberOfUnits * period.unit.daysEquivalent
        } else {
            return 0
        }
    }
}

extension SKProduct.PeriodUnit {
    var daysEquivalent: Int {
        switch self {
        case .day:
            return 1
        case .week:
            return 7
        case .month:
            return 30
        case .year:
            return 365
        }
    }
}

extension SKProduct.PeriodUnit {
    func description(capitalizeFirstLetter: Bool = false, numberOfUnits: Int? = nil) -> String {
        let period:String = {
            switch self {
            case .day: return "day"
            case .week: return "week"
            case .month: return "month"
            case .year: return "year"
            }
        }()

        var numUnits = ""
        var plural = ""
        if let numberOfUnits = numberOfUnits {
            numUnits = "\(numberOfUnits) " // Add space for formatting
            plural = numberOfUnits > 1 ? "s" : ""
        }
        return "\(numUnits)\(capitalizeFirstLetter ? period.capitalized : period)\(plural)"
    }
}

