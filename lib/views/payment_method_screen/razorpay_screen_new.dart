import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/utils/app_config.dart';
import 'package:krishanthmart_new/utils/colors.dart';
import 'package:krishanthmart_new/views/mainpage/main_page.dart';
import 'package:krishanthmart_new/views/orders/my_orders_page.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import '../../repositories/payment_repositories.dart';
import '../../utils/toast_component.dart';

class RazorpayScreenNew extends StatefulWidget {
  double? amount;
  String payment_type;
  String? payment_method_key;
  var package_id;

  RazorpayScreenNew(
      {Key? key,
      this.amount = 0.00,
      this.payment_type = "",
      this.package_id = "0",
      this.payment_method_key = ""})
      : super(key: key);

  @override
  State<RazorpayScreenNew> createState() => _RazorpayScreenNewState();
}

class _RazorpayScreenNewState extends State<RazorpayScreenNew> {
  final _razorpay = Razorpay();
  String apiKey = AppConfig.razorPayKey;
  String apiSecret = AppConfig.razorPaySecret;
  int orderId = 0;
  late Map<String, dynamic> paymentData;

  createOrder() async {
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponse(widget.payment_method_key);
    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      Navigator.of(context).pop();
      return;
    }
    orderId = orderCreateResponse.combined_order_id;
    setState(() {});
  }

  pay_by_wallet() async {
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponseFromWallet(
        widget.payment_method_key, widget.amount);

    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    Get.to(()=>OrderList(from_checkout: true,));
  }


  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.shimmer_highlighted,
      appBar: AppBar(
        backgroundColor: MyTheme.green,
        title: const Text(
          'Razorpay',
          style: TextStyle(color: MyTheme.white),
        ),
      ),
      body: InkWell(
        onTap: () {
          setState(() {
            paymentData = {
              'amount': widget.amount! * 100,
              'currency': 'INR',
              'receipt': 'order_receipt',
              'payment_capture': '1',
            };
          });
          initiatePayment();
        },
        child: Container(
          height: 80.h,
          width: Get.width,
          margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Card(
            child: Center(
              child: Text(
                "Checkout",
                style: TextStyle(
                    color: MyTheme.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    createOrder();
    Get.off(
      () => OrderList(
        from_checkout: false,
      ),
    );

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.offAll(() => MainPage());
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint(response.walletName);
    pay_by_wallet();
  }

  Future<void> initiatePayment() async {
    String apiUrl = 'https://api.razorpay.com/v1/orders';
    // Make the API request to create an order
    http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}',
      },
      body: jsonEncode(paymentData),
    );

    print("razorpay response body==============>${response.body}");

    if (response.statusCode == 200) {
      // Parse the response to get the order ID
      var responseData = jsonDecode(response.body);
      String orderId = responseData['id'];
      // Set up the payment options
      var options = {
        'key': apiKey,
        'amount': paymentData['amount'],
        'name': AppConfig.app_name,
        'order_id': orderId,
        'prefill': {
          'contact': '9025075398',
          'email': 'chandrunair44@gmail.com'
        },
        'external': {
          'wallets': ['paytm'] // optional, for adding support for wallets
        }
      };

      // Open the Razorpay payment form
      try {
        _razorpay.open(options);
      } catch (e) {
        debugPrint(e.toString());
      }
    } else {
      // Handle error response
      debugPrint('Error creating order: ${response.body}');
    }
  }
}
