//
//  ViewController.swift
//  CardDemo
//
//  Created by Efe Ariaroo on 4/22/16.
//  Copyright © 2016 Interswitch Limited. All rights reserved.
//

import UIKit
import PaymentSDK

class ViewController: UIViewController, UIAlertViewDelegate {
    
    var customerId: UITextField
    var amount: UITextField
    var pan: UITextField
    var cvv2Field : UITextField
    var pin: UITextField
    var expiry: UITextField
    
    var activityIndicator: UIActivityIndicatorView
    var otpTransactionIdentifier: String = ""
    
    let clientId = "IKIA7B379B0114CA57FAF8E19F5CC5063ED2220057EF"
    let clientSecret = "MiunSQ5S/N219UCVP1Lt2raPfwK9lMoiV/PdBX5v/R4="
    
    let yourRequestorId = "12345678901"     //Specify your own requestorId here
    
    let sdk : PaymentSDK
    
    
    required init?(coder aDecoder: NSCoder) {
        customerId = UITextField(frame: CGRect(x: 20, y: 100, width: 200, height: 30))
        amount = UITextField(frame: CGRect(x: 20, y: 140, width: 200, height: 30))
        
        pan = UITextField(frame: CGRect(x: 20, y: 180, width: 200, height: 30))
        cvv2Field = UITextField()
        pin = UITextField(frame: CGRect(x: 20, y: 220, width: 200, height: 30))
        expiry = UITextField(frame: CGRect(x: 20, y: 260, width: 200, height: 30))
        
        activityIndicator = UIActivityIndicatorView()

        sdk = PaymentSDK(clientId: clientId, clientSecret: clientSecret)
        
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Passport.overrideApiBase("https://qa.interswitchng.com/passport")
        Payment.overrideApiBase("https://qa.interswitchng.com")
        
        view.backgroundColor = UIColor.white
        
        let screenWidth = self.view.bounds.width
        let yTopMargin : CGFloat = 10.0
        let textfieldsWidth : CGFloat = 250
        let textfieldsHeight : CGFloat = 40
        
        let XPosition : CGFloat = (screenWidth - textfieldsWidth)/2
        
        //--
        let headerLabel = UILabel()
        headerLabel.text = "Card payment demo"
        
        headerLabel.frame = CGRect(x: XPosition, y: 50, width: 250, height: 40)
        headerLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        headerLabel.textAlignment = .center
        view.addSubview(headerLabel)
        
        customerId.frame = CGRect(x: XPosition, y: 130, width: textfieldsWidth, height: textfieldsHeight)
        customerId.placeholder = "Customer ID"
        customerId.borderStyle = UITextBorderStyle.line
        customerId.text = "1407002510"   // This should be a value that identifies your customer uniquely e.g email or phone number etc
        view.addSubview(customerId)
        
        amount.frame = CGRect(x: XPosition, y: 170 + yTopMargin, width: textfieldsWidth, height: textfieldsHeight)
        amount.placeholder = "Amount"
        amount.borderStyle = UITextBorderStyle.line
        amount.keyboardType = .decimalPad
        amount.text = "100"
        view.addSubview(amount)
        
        pan.frame = CGRect(x: XPosition, y: 210 + 2 * yTopMargin, width: textfieldsWidth, height: textfieldsHeight)
        pan.placeholder = "Card Number"
        pan.borderStyle = UITextBorderStyle.line
        pan.keyboardType = .numberPad
        pan.text = "5060990580000217499"
        view.addSubview(pan)
        
        
        cvv2Field.frame = CGRect(x: XPosition, y: 250 + 3 * yTopMargin, width: textfieldsWidth, height: textfieldsHeight)
        cvv2Field.placeholder = "CVV"
        cvv2Field.borderStyle = UITextBorderStyle.line
        cvv2Field.keyboardType = .numberPad
        cvv2Field.text = "111"
        view.addSubview(cvv2Field)
        
        pin.frame = CGRect(x: XPosition, y: 290 + 4 * yTopMargin, width: textfieldsWidth, height: textfieldsHeight)
        pin.placeholder = "Card PIN"
        pin.borderStyle = UITextBorderStyle.line
        pin.keyboardType = .numberPad
        pin.text = "1111"
        view.addSubview(pin)
        
        expiry.frame = CGRect(x: XPosition, y: 330 + 5 * yTopMargin, width: textfieldsWidth, height: textfieldsHeight)
        expiry.placeholder = "Expiry (format: YYMM)"
        expiry.borderStyle = UITextBorderStyle.line
        expiry.keyboardType = .numberPad
        expiry.text = "2004"
        view.addSubview(expiry)
        
        
        let payNow = UIButton(type: UIButtonType.roundedRect)
        payNow.frame = CGRect(x: XPosition, y: 380 + 6 * yTopMargin, width: textfieldsWidth, height: textfieldsHeight)
        //payNow.frame = CGRect(x: 20, y: 300, width: 40, height: 40)
        payNow.setTitle("Pay", for: UIControlState())
        payNow.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        styleButton(payNow)
        
        payNow.addTarget(self, action: #selector(ViewController.pay), for: UIControlEvents.touchUpInside)
        view.addSubview(payNow)
        
        activityIndicator.frame = CGRect(x: (screenWidth - 40)/2, y: 500, width: 40, height: textfieldsHeight)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.bringSubview(toFront: view)
    }
    
    func styleButton(_ theButton : UIButton) {
        theButton.layer.cornerRadius = 5.0
        theButton.backgroundColor  = UIColor.black
        theButton.setTitleColor(UIColor.white, for: UIControlState())
    }
    
    func pay(){
        if isOkToMakePaymentRequest() {
            let request = PurchaseRequest(customerId: customerId.text, amount: amount.text!, pan: pan.text!,
                                          pin: pin.text!, expiryDate: expiry.text!, cvv2: cvv2Field.text!,
                                          transactionRef: Payment.randomStringWithLength(12), requestorId: yourRequestorId)
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            activityIndicator.startAnimating()
            
            sdk.purchase(request, completionHandler:{(purchaseResponse: PurchaseResponse?, error: Error?) in
                guard error == nil else {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    self.showError((error?.localizedDescription)!)
                    return
                }
                
                guard let response = purchaseResponse else {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    self.showError((error?.localizedDescription)!)
                    return
                }
                
                guard let responseCode = response.responseCode else {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    self.showSuccess("Ref: " + response.transactionIdentifier)
                    return
                }
                
                if responseCode == PaymentSDK.SAFE_TOKEN_RESPONSE_CODE {
                    self.handleOTP(response.message, authData: request.authData, purchaseResponse: response)
                } else if (responseCode == PaymentSDK.CARDINAL_RESPONSE_CODE) {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    self.handleCardinal(request.authData, purchaseResponse: response)
                } else {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                }
            })
        }
    }
    
    func isOkToMakePaymentRequest() -> Bool {
        var isOk = false
        
        if !customerId.hasText {
            showError("Customer ID is required")
        } else if !amount.hasText {
            showError("Amount is required")
        } else if !pan.hasText {
            showError("PAN is required")
        } else if !cvv2Field.hasText {
            showError("CVV is required")
        } else if !pin.hasText {
            showError("PIN is required")
        } else {
            isOk = true
        }
        return isOk
    }
    
    func handleOTP(_ message: String, authData: String, purchaseResponse: PurchaseResponse){
        let alert = UIAlertController(title: "OTP", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (textField) -> Void in
            textField.placeholder = "Enter OTP"
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(cancel)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) -> Void in
            if ((alert.textFields?.first?.hasText) != nil){
                let otp = alert.textFields?.first?.text
                let otpReq = AuthorizePurchaseRequest()
                otpReq.paymentId = purchaseResponse.paymentId!
                otpReq.otp = otp!
                otpReq.authData = authData
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self.activityIndicator.startAnimating()
                
                self.sdk.authorizePurchase(otpReq, completionHandler: {(authorizePurchaseResponse: AuthorizePurchaseResponse?, error: Error?) in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                    
                    guard error == nil else {
                        self.showError((error?.localizedDescription)!)
                        return
                    }
                    
                    guard let authPurchaseResponse = authorizePurchaseResponse else {
                        self.showError("Otp validation was NOT successful")
                        return
                    }
                    self.showSuccess("Payment successful!\n Transation Id: \(authPurchaseResponse.transactionIdentifier)")
                })
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.activityIndicator.stopAnimating()
            }
        })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
    func handleCardinal(_ authData: String, purchaseResponse: PurchaseResponse) {
        let authorizeHandler = {() -> Void in
            self.navigationController?.popViewController(animated: true)
            
            let authorizeCardinalRequest = AuthorizePurchaseRequest()
            authorizeCardinalRequest.authData = authData
            authorizeCardinalRequest.paymentId = purchaseResponse.paymentId!
            authorizeCardinalRequest.transactionId = purchaseResponse.transactionId
            authorizeCardinalRequest.eciFlag = purchaseResponse.eciFlag!
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.activityIndicator.startAnimating()
            
            self.sdk.authorizePurchase(authorizeCardinalRequest, completionHandler:{(authorizePurchaseResponse: AuthorizePurchaseResponse?, error: Error?) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.activityIndicator.stopAnimating()
                
                guard error == nil else {
                    self.showError((error?.localizedDescription)!)
                    return
                }
                guard authorizePurchaseResponse != nil else {
                    self.showError("Authorization was NOT successful")
                    return
                }
                self.showSuccess("Payment successful!\n Transation Id: \(authorizePurchaseResponse!.transactionIdentifier)")
            })
        }
        let authorizePurchaseVc = AuthorizeViewController(response: purchaseResponse, authorizeHandler: authorizeHandler)
        self.navigationController?.pushViewController(authorizePurchaseVc, animated: true)
    }

    
    func showError(_ message: String){
        let alertView = UIAlertView()
        alertView.title = "Error"
        alertView.addButton(withTitle: "OK")
        alertView.message = message
        
        alertView.show()
    }
    
    func showSuccess(_ message: String){
        let alertView = UIAlertView()
        alertView.title = "Success"
        alertView.addButton(withTitle: "OK")
        alertView.message = message
        
        alertView.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
