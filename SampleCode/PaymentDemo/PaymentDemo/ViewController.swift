//
//  ViewController.swift
//  PaymentDemo
//
//  Created by Efe Ariaroo on 4/20/16.
//  Copyright © 2016 Interswitch Limited. All rights reserved.
//

import UIKit
import PaymentSDK


class ViewController: UIViewController {
    
    let yourClientId = "IKIA14BAEA0842CE16CA7F9FED619D3ED62A54239276"
    let yourClientSecret = "Z3HnVfCEadBLZ8SYuFvIQG52E472V3BQLh4XDKmgM2A="
    let theCustomerId = "" // This should be a value that identifies your customer uniquely e.g email or phone number etc
    let paymentDescription = "Payment for goods"
    let theAmount = "200"
    
    let theToken = "5060990580000217499"       //This should be a valid token value that was stored after a previously successful payment
    let theCardType = "verve"   //This should be a valid card type e.g mastercard, verve, visa etc
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Passport.overrideApiBase("https://sandbox.interswitchng.com/passport")
        Payment.overrideApiBase("https://sandbox.interswitchng.com")

        view.backgroundColor = UIColor.whiteColor()
        
        let screenWidth = self.view.bounds.width
        let yTopMargin:CGFloat = 10.0        //Set header
        let buttonsWidth:CGFloat = 250
        let buttonsHeight:CGFloat = 40
        
        let XPosition: CGFloat = (screenWidth - buttonsWidth)/2
        
        //--
        let headerLabel = UILabel()
        headerLabel.text = "Payment demo"
        
        headerLabel.frame = CGRectMake(XPosition, 80, 250, 40)
        headerLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        headerLabel.font = UIFont.boldSystemFontOfSize(16.0)
        headerLabel.textAlignment = .Center
        view.addSubview(headerLabel)
        
        
        //Pay with card button
        let payWithCardButton = UIButton(type: .System)
        payWithCardButton.frame = CGRectMake(XPosition, 150 + yTopMargin, buttonsWidth, buttonsHeight)
        payWithCardButton.setTitle("Pay With Card", forState: .Normal)
        styleButton(payWithCardButton)
        
        payWithCardButton.addTarget(self, action: #selector(ViewController.payWithCard), forControlEvents: .TouchUpInside)
        view.addSubview(payWithCardButton)
        
        
        //Pay with wallet button
        let payWithWalletButton = UIButton(type: .System)
        payWithWalletButton.frame = CGRectMake(XPosition, 190 + 2 * yTopMargin, buttonsWidth, buttonsHeight)
        payWithWalletButton.setTitle("Pay With Wallet", forState: .Normal)
        styleButton(payWithWalletButton)
        
        payWithWalletButton.addTarget(self, action: #selector(ViewController.payWithWallet), forControlEvents: .TouchUpInside)
        view.addSubview(payWithWalletButton)
        
        
        //Validate card button
        let validateCardButton = UIButton(type: .System)
        validateCardButton.frame = CGRectMake(XPosition, 230 + 3 * yTopMargin, buttonsWidth, buttonsHeight)
        validateCardButton.setTitle("Validate Card", forState: .Normal)
        styleButton(validateCardButton)
        
        validateCardButton.addTarget(self, action: #selector(ViewController.validateCard), forControlEvents: .TouchUpInside)
        view.addSubview(validateCardButton)
        
        
        //Pay with token button
        let payWithTokenButton = UIButton(type: .System)
        payWithTokenButton.frame = CGRectMake(XPosition, 270 + 4 * yTopMargin, buttonsWidth, buttonsHeight)
        payWithTokenButton.setTitle("Pay With Token", forState: .Normal)
        styleButton(payWithTokenButton)
        
        payWithTokenButton.addTarget(self, action: #selector(ViewController.payWithToken), forControlEvents: .TouchUpInside)
        view.addSubview(payWithTokenButton)
    }
    
    func styleButton(theButton : UIButton) {
        theButton.layer.cornerRadius = 5.0
        theButton.backgroundColor  = UIColor.blackColor()
        theButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }

    func payWithCard(){
        let payWithCard = PayWithCard(clientId: yourClientId, clientSecret: yourClientSecret,
                                      customerId: theCustomerId, description: paymentDescription,
                                      amount: theAmount, currency: "NGN")
        let vc = payWithCard.start({(purchaseResponse: PurchaseResponse?, error: NSError?) in
            guard error == nil else {
                let errMsg = (error?.localizedDescription)!
                self.showError(errMsg)
                return
            }
            guard let response = purchaseResponse else {
                let failureMsg = (error?.localizedFailureReason)!
                self.showError(failureMsg)
                return
            }
            
            //Handling success
            self.showSuccess("Ref: " + response.transactionIdentifier)
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func payWithWallet(){
        let payWithWallet = PayWithWallet(clientId: yourClientId, clientSecret: yourClientSecret,
                                          customerId: theCustomerId, description: paymentDescription,
                                          amount: theAmount, currency: "NGN")
        let vc = payWithWallet.start({(purchaseResponse: PurchaseResponse?, error: NSError?) in
            guard error == nil else {
                let errMsg = (error?.localizedDescription)!
                self.showError(errMsg)
                return
            }
            
            guard let response = purchaseResponse else {
                let failureMsg = (error?.localizedFailureReason)!
                self.showError(failureMsg)
                return
            }
            
            //Handling success
            self.showSuccess("Ref: " + response.transactionIdentifier)
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func validateCard() {
        let validateCard = ValidateCard(clientId: yourClientId, clientSecret: yourClientSecret,
                                        customerId: theCustomerId)
        let vc = validateCard.start({(validateCardResponse: ValidateCardResponse?, error: NSError?) in
            guard error == nil else {
                let errMsg = (error?.localizedDescription)!
                self.showError(errMsg)
                return
            }
            
            guard let response = validateCardResponse else {
                let failureMsg = (error?.localizedFailureReason)!
                self.showError(failureMsg)
                return
            }
            
            //Handling success
            var msg = response.message
            self.showSuccess(msg)
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func payWithToken(){
        let payWithToken = PayWithToken(clientId: yourClientId, clientSecret: yourClientSecret,
                                        customerId: theCustomerId, description: paymentDescription,
                                        amount: theAmount, token: theToken, currency: "NGN",
                                        expiryDate: "2004", cardType: theCardType, last4Digits: "7499")
        let vc = payWithToken.start({(purchaseResponse: PurchaseResponse?, error: NSError?) in
            guard error == nil else {
                let errMsg = (error?.localizedDescription)!
                self.showError(errMsg)
                return
            }
            
            guard let response = purchaseResponse else {
                let failureMsg = (error?.localizedFailureReason)!
                self.showError(failureMsg)
                return
            }
            
            self.showSuccess("Ref: " + response.transactionIdentifier)
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showError(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showSuccess(message: String){
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

