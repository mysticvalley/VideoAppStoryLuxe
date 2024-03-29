//
//  PKIAPHandler.swift
//
//  Created by Pramod Kumar on 13/07/2017.
//  Copyright © 2017 Pramod Kumar. All rights reserved.
//
import UIKit
import StoreKit

enum PKIAPHandlerAlertType {
    case setProductIds
    case disabled
    case restored
    case purchased

    var message: String{
        switch self {
        case .setProductIds: return "Product ids not set, call setProductIds method!"
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        }
    }
}


class PKIAPHandler: NSObject {

    //MARK:- Shared Object
    //MARK:-
    static let shared = PKIAPHandler()
    private override init() { }

    //MARK:- Properties
    //MARK:- Private
    fileprivate var productIds = [String]()
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var fetchProductComplition: (([SKProduct])->Void)?

    fileprivate var productToPurchase: SKProduct?
    fileprivate var purchaseProductCompletion: ((PKIAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)?

    //MARK:- Public
    var isLogEnabled: Bool = true
    var product_id: String?
    //MARK:- Methods
    //MARK:- Public

    //Set Product Ids
    func setProductIds(ids: [String]) {
        self.productIds = ids
    }

    //MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }

    func purchase(product: SKProduct, complition: @escaping ((PKIAPHandlerAlertType, SKProduct?, SKPaymentTransaction?)->Void)) {

        self.purchaseProductCompletion = complition
        self.productToPurchase = product

        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)

            log("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
        }
        else {
            complition(PKIAPHandlerAlertType.disabled, nil, nil)
        }
    }

    // RESTORE PURCHASE
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    func checkPurchsed(pId:String) ->  Bool {
        product_id = pId
        let defaults = UserDefaults.standard
        SKPaymentQueue.default().add(self)
    //Check if product is purchased
        let purchased = UserDefaults.standard.bool(forKey: product_id!)

        if (purchased){
    // Hide a view or show content depends on your requirement
            return true
        } else if (!defaults.bool(forKey: "stonerPurchased")) {
            print("false")
            return false
    }
        return false
    }

    // FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(complition: @escaping (([SKProduct])->Void)){

        self.fetchProductComplition = complition
        // Put here your IAP Products ID's
        if self.productIds.isEmpty {
            log(PKIAPHandlerAlertType.setProductIds.message)
            fatalError(PKIAPHandlerAlertType.setProductIds.message)
        }
        else {
            productsRequest = SKProductsRequest(productIdentifiers: Set(self.productIds))
            productsRequest.delegate = self
            productsRequest.start()
        }
    }

    //MARK:- Private
    fileprivate func log <T> (_ object: T) {
        if isLogEnabled {
            NSLog("\(object)")
        }
    }
}

//MARK:- Product Request Delegate and Payment Transaction Methods
extension PKIAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver{

    // REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {

        if (response.products.count > 0) {
            if let completion = self.fetchProductComplition {
                completion(response.products)
            }
        }
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if let completion = self.purchaseProductCompletion {
            completion(PKIAPHandlerAlertType.restored, nil, nil)

        }
    }

    // IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    log("Product purchase done")
                    print(trans.payment.productIdentifier)
                    let defaults = UserDefaults.standard
                     defaults.set(true, forKey: trans.payment.productIdentifier)
                 //   let purchased = UserDefaults.standard.bool(forKey: trans.payment.productIdentifier)
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if let completion = self.purchaseProductCompletion {
                        completion(PKIAPHandlerAlertType.purchased, self.productToPurchase, trans)
                    }
                    break

                case .failed:
                    log("Product purchase failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    log("Product restored")
                    AppUtils.sharedUtils.purchaseRestore = true
                    let defaults = UserDefaults.standard
                    defaults.set(true, forKey: trans.payment.productIdentifier)

                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break

                default: break
                }}}
    }
}
