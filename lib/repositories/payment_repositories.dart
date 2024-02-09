import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helpers/api_helpers.dart';
import '../helpers/middleware/banned_user.dart';
import '../models/bkash_begin_pay_response.dart';
import '../models/bkash_pay_response.dart';
import '../models/flutterwave_url_response.dart';
import '../models/iyzico_pay_response.dart';
import '../models/nagad_begin_response.dart';
import '../models/nagad_pay_response.dart';
import '../models/delivery_slot_model.dart';
import '../models/order_create_response.dart';
import '../models/payment_type_response.dart';
import '../models/paypal_pay_response.dart';
import '../models/paystack_pay_response.dart';
import '../models/razorpay_model.dart';
import '../models/ssl_commerz_begin_response.dart';
import '../utils/app_config.dart';
import '../utils/shared_value.dart';

class PaymentRepository {
  Future<dynamic> getPaymentResponseList({mode = "", list = "both"}) async {
    String url =
        ("${AppConfig.BASE_URL}/payment-types?mode=${mode}&list=${list}");

    final response = await ApiRequest.get(
        url: url,
        headers: {
          "App-Language": app_language.$!,
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        middleware: BannedUser());
    print("Payment Response List=============>${response.body}");

    return paymentTypeResponseFromJson(response.body);
  }

  Future<dynamic> getOrderCreateResponse(payment_method) async {
    var post_body = jsonEncode({"payment_type": "${payment_method}"});

    String url = ("${AppConfig.BASE_URL}/order/store");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        body: post_body,
        middleware: BannedUser());
    print("order Response=============>${response.body}");

    return orderCreateResponseFromJson(response.body);
  }

  Future<PaypalUrlResponse> getPaypalUrlResponse(String payment_type,
      int? combined_order_id, var package_id, double? amount) async {
    String url =
        ("${AppConfig.BASE_URL}/paypal/payment/url?payment_type=${payment_type}&combined_order_id=${combined_order_id}&amount=${amount}&user_id=${user_id.$}&package_id=$package_id");
    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });
    return paypalUrlResponseFromJson(response.body);
  }

  Future<FlutterwaveUrlResponse> getFlutterwaveUrlResponse(String payment_type,
      int? combined_order_id, var package_id, double? amount) async {
    String url =
        ("${AppConfig.BASE_URL}/flutterwave/payment/url?payment_type=${payment_type}&combined_order_id=${combined_order_id}&amount=${amount}&user_id=${user_id.$}&package_id=$package_id");

    final response = await ApiRequest.get(url: url, headers: {
      "App-Language": app_language.$!,
    });

    return flutterwaveUrlResponseFromJson(response.body);
  }

  Future<dynamic> getOrderCreateResponseFromWallet(
      payment_method, double? amount) async {
    String url = ("${AppConfig.BASE_URL}/payments/pay/wallet");

    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_method}",
      "amount": "${amount}"
    });

    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body,
        middleware: BannedUser());

    return orderCreateResponseFromJson(response.body);
  }

  Future<dynamic> getOrderCreateResponseFromCod(payment_method) async {
    var post_body = jsonEncode(
        {"user_id": "${user_id.$}", "payment_type": "${payment_method}"});

    String url = ("${AppConfig.BASE_URL}/payments/pay/cod");

    print(url);
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body,
        middleware: BannedUser());
    print(response.body);

    return orderCreateResponseFromJson(response.body);
  }

  Future<dynamic> getOrderCreateResponseFromManualPayment(
      payment_method) async {
    var post_body = jsonEncode(
        {"user_id": "${user_id.$}", "payment_type": "${payment_method}"});

    String url = ("${AppConfig.BASE_URL}/payments/pay/manual");

    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body,
        middleware: BannedUser());

    return orderCreateResponseFromJson(response.body);
  }

  Future<RazorpayPaymentSuccessResponse> getRazorpayPaymentSuccessResponse(
      payment_type,
      double? amount,
      int? combined_order_id,
      String? payment_details) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_type}",
      "combined_order_id": "${combined_order_id}",
      "amount": "${amount}",
      "payment_details": "${payment_details}"
    });

    String url = ("${AppConfig.BASE_URL}/razorpay/success");

    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!
        },
        body: post_body);

    print("Razorpay payment setup datasssss================>${response.body}");

    return razorpayPaymentSuccessResponseFromJson(response.body);
  }

  Future<PaystackPaymentSuccessResponse> getPaystackPaymentSuccessResponse(
      payment_type,
      double? amount,
      int? combined_order_id,
      Map<String, dynamic> payment_details) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_type}",
      "combined_order_id": "${combined_order_id}",
      "amount": "${amount}",
      "payment_details": "${payment_details}"
    });

    String url = ("${AppConfig.BASE_URL}/paystack/success");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body);

    return paystackPaymentSuccessResponseFromJson(response.body);
  }

  Future<IyzicoPaymentSuccessResponse> getIyzicoPaymentSuccessResponse(
      payment_type,
      double? amount,
      int? combined_order_id,
      String? payment_details) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_type}",
      "combined_order_id": "${combined_order_id}",
      "amount": "${amount}",
      "payment_details": "${payment_details}"
    });

    String url = ("${AppConfig.BASE_URL}/paystack/success");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body);

    return iyzicoPaymentSuccessResponseFromJson(response.body);
  }

  Future<BkashBeginResponse> getBkashBeginResponse(String payment_type,
      int? combined_order_id, var package_id, double? amount) async {
    String url =
        ("${AppConfig.BASE_URL}/bkash/begin?payment_type=${payment_type}&combined_order_id=${combined_order_id}&amount=${amount}&user_id=${user_id.$}&package_id=${package_id}");

    print(url.toString());
    final response = await ApiRequest.get(
      url: url,
      headers: {"Authorization": "Bearer ${access_token.$}"},
    );

    return bkashBeginResponseFromJson(response.body);
  }

  Future<BkashPaymentProcessResponse> getBkashPaymentProcessResponse({
    required payment_type,
    required double? amount,
    required int? combined_order_id,
    required String? payment_id,
    required String? token,
    required String package_id,
  }) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "${payment_type}",
      "combined_order_id": "${combined_order_id}",
      "package_id": "${package_id}",
      "amount": "${amount}",
      "payment_id": "${payment_id}",
      "token": "${token}"
    });

    String url = ("${AppConfig.BASE_URL}/bkash/api/success");
    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        body: post_body);

    return bkashPaymentProcessResponseFromJson(response.body);
  }

  Future<SslcommerzBeginResponse> getSslcommerzBeginResponse(
      String payment_type,
      int? combined_order_id,
      var package_id,
      double? amount) async {
    String url =
        ("${AppConfig.BASE_URL}/sslcommerz/begin?payment_type=${payment_type}&combined_order_id=${combined_order_id}&amount=${amount}&user_id=${user_id.$}&package_id=$package_id");

    final response = await ApiRequest.get(
      url: url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!
      },
    );

    return sslcommerzBeginResponseFromJson(response.body);
  }

  Future<NagadBeginResponse> getNagadBeginResponse(String payment_type,
      int? combined_order_id, var package_id, double? amount) async {
    String url =
        ("${AppConfig.BASE_URL}/nagad/begin?payment_type=${payment_type}&combined_order_id=${combined_order_id}&amount=${amount}&user_id=${user_id.$}&package_id=$package_id");

    final response = await ApiRequest.get(
      url: url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$!
      },
    );

    return nagadBeginResponseFromJson(response.body);
  }

  Future<NagadPaymentProcessResponse> getNagadPaymentProcessResponse(
      payment_type,
      double? amount,
      int? combined_order_id,
      String? payment_details) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "payment_type": "$payment_type",
      "combined_order_id": "$combined_order_id",
      "amount": "$amount",
      "payment_details": "$payment_details"
    });

    String url = ("${AppConfig.BASE_URL}/nagad/process");

    final response = await ApiRequest.post(
        url: url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$!,
        },
        body: post_body);

    return nagadPaymentProcessResponseFromJson(response.body);
  }

  Future<String> getCCAVenuePaymentUrl() async {
    // Replace these values with actual data from your app
    String merchantId = 'YOUR_MERCHANT_ID';
    String accessCode = 'YOUR_ACCESS_CODE';
    String orderId = '123456';
    double amount = 100.0;

    // Construct the payment request
    var paymentRequest = {
      'merchant_id': merchantId,
      'access_code': accessCode,
      'order_id': orderId,
      'amount': amount.toString(),
      // Add other necessary parameters
    };

    var response = await http.post(Uri.parse(''), body: paymentRequest);

    // Parse the response to get the payment URL
    var responseBody = response.body;
    // Extract the payment URL based on the actual response structure
    String paymentUrl = parsePaymentUrl(responseBody);

    return paymentUrl;
  }

  String parsePaymentUrl(String responseBody) {
    // Replace this with the actual logic to extract the payment URL
    // from the CCAvenue API response
    // This might involve parsing JSON or XML depending on the response format
    // Consult CCAvenue's documentation for the actual structure of the response
    // Example assuming JSON response: return jsonDecode(responseBody)['payment_url'];

    // Placeholder example
    return 'https://example.com/payment';
  }

  Future deliverySlotRepository() async {
    String url = ("${AppConfig.BASE_URL}/get-time-based-delivery");

    final response = await ApiRequest.get(
      url: url,
      headers: {"App-Language": app_language.$!},
    );
    // print("delivery response========>${response.body}");
    List<TimeDelivery> timeDeliveries = (json.decode(response.body)['data'] as List)
        .map((item) => TimeDelivery.fromJson(item))
        .toList();
    return timeDeliveries;
  }
}
