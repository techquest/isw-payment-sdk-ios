package com.interswitchng.sdk.payment.ios;

import com.interswitchng.sdk.auth.Passport;
import com.interswitchng.sdk.model.RequestOptions;
import com.interswitchng.sdk.payment.IswCallback;
import com.interswitchng.sdk.payment.Payment;
import com.interswitchng.sdk.payment.model.AuthorizeOtpRequest;
import com.interswitchng.sdk.payment.model.AuthorizeOtpResponse;
import com.interswitchng.sdk.payment.model.PurchaseRequest;
import com.interswitchng.sdk.payment.model.PurchaseResponse;
import com.interswitchng.sdk.util.RandomString;
import com.interswitchng.sdk.util.StringUtils;
import org.robovm.apple.coregraphics.CGRect;
import org.robovm.apple.foundation.NSAttributedString;
import org.robovm.apple.uikit.*;
import org.robovm.objc.annotation.CustomClass;

/**
 * Created by crownus on 9/8/15.
 */
@CustomClass("PaymentViewController")
public class PaymentViewController extends UIViewController implements UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    private final UIButton payNow;
    private UITextField customerId;
    private UITextField amount;
    private UITextField pan;
    private UITextField pin;
    private UITextField expiry;
    //    private UIPickerView pickerView;
    private UIActivityIndicatorView activityIndicator;
    private String otpTransactionIdentifier;
    private String transactionIdentifier;
    private String[] data;
    private RequestOptions options = RequestOptions.builder().setClientId("IKIA3E267D5C80A52167A581BBA04980CA64E7B2E70E").setClientSecret("SagfgnYsmvAdmFuR24sKzMg7HWPmeh67phDNIiZxpIY=").build();


    public PaymentViewController() {
        // Get the view of this view controller.
        UIView view = getView();

        // Setup background.
        view.setBackgroundColor(UIColor.white());
//
//        // Setup label.
//        label = new UILabel(new CGRect(20, 250, 280, 44));
//        label.setFont(UIFont.getSystemFont(24));
//        label.setTextAlignment(NSTextAlignment.Center);
//        view.addSubview(label);

        customerId = new UITextField(new CGRect(20, 100, 200, 30));
        customerId.setPlaceholder("Customer ID");
        customerId.setBorderStyle(UITextBorderStyle.Line);
        customerId.setText("1407002510");
        view.addSubview(customerId);

        amount = new UITextField(new CGRect(20, 140, 200, 30));
        amount.setPlaceholder("Amount");
        amount.setBorderStyle(UITextBorderStyle.Line);
        amount.setText("100");
        view.addSubview(amount);

        pan = new UITextField(new CGRect(20, 180, 200, 30));
        pan.setPlaceholder("Card No");
        pan.setBorderStyle(UITextBorderStyle.Line);
        pan.setText("5060990580000217499");
        view.addSubview(pan);

        pin = new UITextField(new CGRect(20, 220, 200, 30));
        pin.setPlaceholder("Card Pin");
        pin.setBorderStyle(UITextBorderStyle.Line);
        pin.setSecureTextEntry(true);
        pin.setText("1111");
        view.addSubview(pin);

        expiry = new UITextField(new CGRect(20, 260, 200, 30));
        expiry.setPlaceholder("Expiry");
        expiry.setBorderStyle(UITextBorderStyle.Line);
        expiry.setText("2004");
        view.addSubview(expiry);

        // Setup payNow.
        payNow = UIButton.create(UIButtonType.RoundedRect);
        payNow.setFrame(new CGRect(20, 300, 40, 40));
        payNow.setTitle("Pay", UIControlState.Normal);
        payNow.getTitleLabel().setFont(UIFont.getBoldSystemFont(22));

        payNow.addOnTouchUpInsideListener(new UIControl.OnTouchUpInsideListener() {
            @Override
            public void onTouchUpInside(UIControl control, UIEvent event) {
                Payment.overrideApiBase("https://qa.interswitchng.com"); // used to override the payment api base url.
                Passport.overrideApiBase("https://qa.interswitchng.com/passport"); //used to override the payment api base url.
//                Passport.overrideApiBase("http://172.25.20.91:6060/passport");
//                Payment.overrideApiBase("http://172.25.20.56:9080");
                if (!customerId.hasText()) {
                    showError("Customer ID is required");
                } else if (!amount.hasText()) {
                    showError("Amount is required");
                } else if (!pan.hasText()) {
                    showError("Card No is required");
                } else if (!pin.hasText()) {
                    showError("Card Pin is required");
                } else if (!expiry.hasText()) {
                    showError("Expiry is required");
                } else {
                    //send payment
                    final PurchaseRequest request = new PurchaseRequest();
                    request.setCustomerId(customerId.getText());
                    request.setAmount(amount.getText());
                    request.setPan(pan.getText());
                    request.setPinData(pin.getText().toString());
                    request.setExpiryDate(expiry.getText());
                    request.setRequestorId("11179920172");
                    request.setCurrency("NGN");
                    request.setTransactionRef(RandomString.numeric(12));
                    activityIndicator.startAnimating();
                    UIApplication.getSharedApplication().setNetworkActivityIndicatorVisible(true);
                    new PaymentSDK(options).purchase(request, new IswCallback<PurchaseResponse>() {
                        @Override
                        public void onError(Exception error) {
                            activityIndicator.stopAnimating();
                            UIApplication.getSharedApplication().setNetworkActivityIndicatorVisible(false);
                            showError(error.getMessage());
                        }

                        @Override
                        public void onSuccess(PurchaseResponse response) {
                            activityIndicator.stopAnimating();
                            UIApplication.getSharedApplication().setNetworkActivityIndicatorVisible(false);
                            transactionIdentifier = response.getTransactionIdentifier();
                            otpTransactionIdentifier = response.getOtpTransactionIdentifier();
                            if (StringUtils.hasText(otpTransactionIdentifier)) {
                                handleOTP(response.getMessage());
                            } else {
                                showSuccess("Ref: " + transactionIdentifier);
                            }

                        }
                    });
                }
            }
        });
        view.addSubview(payNow);
//
//        List<String> list = new ArrayList<>();
//        list.add("One");
//        list.add("Two");
//        list.add("Three");
//        list.add("Four");
//        list.add("Five");
//        data = new String[list.size()];
//        data = list.toArray(data);
//
//        pickerView = new UIPickerView(new CGRect(20, 340, 300, 30));
//        pickerView.setDelegate(this);
//        pickerView.setDataSource(this);
//        view.addSubview(pickerView);

        activityIndicator = new UIActivityIndicatorView(new CGRect(0, 0, 40, 40));
        activityIndicator.setActivityIndicatorViewStyle(UIActivityIndicatorViewStyle.Gray);
        activityIndicator.setCenter(view.getCenter());
        view.addSubview(activityIndicator);
        activityIndicator.bringSubviewToFront(view);
    }

    private void showError(String message) {
        UIAlertView alertView = new UIAlertView();
        alertView.setTitle("Error");
        alertView.addButton("OK");
        alertView.setMessage(message);
        alertView.show();
    }

    private void showSuccess(String message) {
        UIAlertView alertView = new UIAlertView();
        alertView.setTitle("Success");
        alertView.addButton("OK");
        alertView.setMessage(message);
        alertView.show();
    }

    private void handleOTP(String message) {
        UIAlertView alertView = new UIAlertView();
        alertView.setTitle("OTP");
        alertView.addButton("OK");
        alertView.addButton("Cancel");
        alertView.setMessage(message);
        alertView.setDelegate(this);
        alertView.setCancelButtonIndex(1);
        alertView.setAlertViewStyle(UIAlertViewStyle.PlainTextInput);
        alertView.show();
    }

    @Override
    public void clicked(UIAlertView alertView, long buttonIndex) {
        if (buttonIndex == 0 && StringUtils.hasText(alertView.getTextField(0).getText())) {
            String otp = alertView.getTextField(0).getText();
            AuthorizeOtpRequest request = new AuthorizeOtpRequest();
            request.setOtpTransactionIdentifier(otpTransactionIdentifier);
            request.setOtp(otp);
            activityIndicator.startAnimating();
            UIApplication.getSharedApplication().setNetworkActivityIndicatorVisible(true);
            System.out.println(otp);
            new PaymentSDK(options).authorizeOtp(request, new IswCallback<AuthorizeOtpResponse>() {
                @Override
                public void onError(Exception error) {
                    activityIndicator.stopAnimating();
                    UIApplication.getSharedApplication().setNetworkActivityIndicatorVisible(false);
                    showError(error.getMessage());
                }

                @Override
                public void onSuccess(AuthorizeOtpResponse otpResponse) {
                    activityIndicator.stopAnimating();
                    UIApplication.getSharedApplication().setNetworkActivityIndicatorVisible(false);
                    showSuccess("Ref: " + transactionIdentifier);
                }
            });
        }else{
            activityIndicator.stopAnimating();
            UIApplication.getSharedApplication().setNetworkActivityIndicatorVisible(false);
        }


    }

    @Override
    public void cancel(UIAlertView alertView) {

    }

    @Override
    public void willPresent(UIAlertView alertView) {

    }

    @Override
    public void didPresent(UIAlertView alertView) {

    }

    @Override
    public void willDismiss(UIAlertView alertView, long buttonIndex) {

    }

    @Override
    public void didDismiss(UIAlertView alertView, long buttonIndex) {

    }

    @Override
    public boolean shouldEnableFirstOtherButton(UIAlertView alertView) {
        return false;
    }

    @Override
    public long getNumberOfComponents(UIPickerView pickerView) {
        return 1;
    }

    @Override
    public long getNumberOfRows(UIPickerView pickerView, long component) {
        return data.length;
    }

    @Override
    public double getComponentWidth(UIPickerView pickerView, long component) {
        return 200;
    }

    @Override
    public double getRowHeight(UIPickerView pickerView, long component) {
        return 36.0;
    }

    @Override
    public String getRowTitle(UIPickerView pickerView, long row, long component) {
        return data[((int) row)];
    }

    @Override
    public NSAttributedString getAttributedRowTitle(UIPickerView pickerView, long row, long component) {
//        String title = data[((int) row)];
//        NSAttributedString attributedString = new NSAttributedString(title);
//        return attributedString;
        return null;
    }

    @Override
    public UIView getRowView(UIPickerView pickerView, long row, long component, UIView view) {
        return null;
    }

    @Override
    public void didSelectRow(UIPickerView pickerView, long row, long component) {
        System.out.println(data[((int) row)]);
    }
}
