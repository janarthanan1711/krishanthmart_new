import 'package:cc_avenue/cc_avenue.dart';
import 'package:flutter/services.dart';

class getCcAvenueRoute {
  Future<void> initPlatformState({
    required String amount,
    required String orderId,
    required String currencyType,
  }) async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      await CcAvenue.cCAvenueInit(
          transUrl: 'https://test.ccavenue.com/transaction/initTrans',
          accessCode: 'AVVU12KI44AY24UVYA',
          // amount: '10',
          amount: amount,
          cancelUrl: 'http://122.182.6.216/merchant/ccavResponseHandler.jsp',
          // currencyType: 'INR',
          currencyType: currencyType,
          merchantId: '2855325',
          // orderId: '519',
          orderId: orderId,
          redirectUrl: 'http://122.182.6.216/merchant/ccavResponseHandler.jsp',
          rsaKeyUrl: 'https://test.ccavenue.com/transaction/jsp/GetRSA.jsp');
    } on PlatformException {
      print('PlatformException');
    }
  }
}
