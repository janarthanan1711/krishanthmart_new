import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/views/orders/refund_request.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../helpers/main_helpers.dart';
import '../../models/order_detail_model.dart';
import '../../repositories/order_repositories.dart';
import '../../repositories/refund_request_repository.dart';
import '../../utils/app_config.dart';
import '../../utils/btn_elements.dart';
import '../../utils/colors.dart';
import '../../utils/device_info.dart';
import '../../utils/shared_value.dart';
import '../../utils/shimmer_utils.dart';
import '../../utils/system_config.dart';
import '../../utils/toast_component.dart';
import '../auth/components/loading_widget.dart';
import '../mainpage/components/box_decorations.dart';
import '../mainpage/main_page.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'components/confirm_dialog.dart';
import 'components/info_dialog.dart';

class OrderDetails extends StatefulWidget {
  int? id;
  final bool from_notification;
  bool go_back;

  OrderDetails(
      {Key? key, this.id, this.from_notification = false, this.go_back = true})
      : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final ScrollController _mainScrollController = ScrollController();
  final _steps = [
    'pending',
    'confirmed',
    'on_delivery',
    'picked_up',
    'on_the_way',
    'delivered'
  ];

  TextEditingController _refundReasonController = TextEditingController();
  bool _showReasonWarning = false;
  TextEditingController cancelController = TextEditingController();

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? pSend =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    pSend?.send([id, status, progress]);
  }

  //init
  int _stepIndex = 0;
  final ReceivePort _port = ReceivePort();
  DetailedOrder? _orderDetails;
  final List<dynamic> _orderedItemList = [];
  bool _orderItemsInit = false;

  @override
  void initState() {
    fetchAll();

    var k = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');

    _port.listen(
      (dynamic data) {
        if (data[2] >= 100) {
          ToastComponent.showDialog("File has downloaded successfully.",
              gravity: Toast.center, duration: Toast.lengthLong);
        }
      },
    );

    FlutterDownloader.registerCallback(downloadCallback);

    super.initState();

    print(widget.id);
  }

  //
  // @override
  // void dispose() {
  //   super.dispose();
  // }

  Future<void> _downloadInvoice(id) async {
    var folder = await createFolder();
    try {
      String? _taskid = await FlutterDownloader.enqueue(
          url: AppConfig.BASE_URL + "/invoice/download/$id",
          saveInPublicStorage: true,
          savedDir: folder,
          headers: {
            "Authorization": "Bearer ${access_token.$}",
            "Currency-Code": SystemConfig.systemCurrency!.code!,
            "Currency-Exchange-Rate":
                SystemConfig.systemCurrency!.exchangeRate.toString(),
            "App-Language": app_language.$!,
            // "System-Key": AppConfig.system_key
          }
          );
      // FlutterDownloader.loadTasks();
      await Future.delayed(Duration(seconds: 1));
      FlutterDownloader.open(taskId: _taskid!);
    } on Exception catch (e) {
      print("e.toString()");
      print(e.toString());
    }
  }

  Future<String> createFolder() async {
    final Directory? tempDir = await getExternalStorageDirectory();
    print("directory path;;;;;;;;;;;;;;;;;;${tempDir!.path}");
    final filePath = Directory("${tempDir.path}/files");
    if (await filePath.exists()) {
      return filePath.path;
    } else {
      await filePath.create(recursive: true);
      return filePath.path;
    }
    // var mPath = "storage/emulated/0/Download/";
    // if (Platform.isIOS) {
    //   var iosPath = await getApplicationDocumentsDirectory();
    //   mPath = iosPath.path;
    // }
    // // print("path = $mPath");
    // final dir = Directory(mPath);
    //
    // var status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   await Permission.storage.request();
    // }
    // if ((await dir.exists())) {
    //   return dir.path;
    // } else {
    //   await dir.create();
    //   return dir.path;
    // }
  }


  fetchAll() {
    fetchOrderDetails();
    fetchOrderedItems();
  }

  fetchOrderDetails() async {
    var orderDetailsResponse =
        await OrderRepository().getOrderDetails(id: widget.id);

    if (orderDetailsResponse.detailed_orders.length > 0) {
      _orderDetails = orderDetailsResponse.detailed_orders[0];
      setStepIndex(_orderDetails!.delivery_status);
    }

    setState(() {});
  }

  setStepIndex(key) {
    _stepIndex = _steps.indexOf(key);
    setState(() {});
  }

  fetchOrderedItems() async {
    var orderItemResponse =
        await OrderRepository().getOrderItems(id: widget.id);
    _orderedItemList.addAll(orderItemResponse.ordered_items);
    _orderItemsInit = true;

    setState(() {});
  }

  reset() {
    _stepIndex = 0;
    _orderDetails = null;
    _orderedItemList.clear();
    _orderItemsInit = false;
    setState(() {});
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }

  _onPressCancelOrder(id,reason) async {
    Loading.show(context);
    var response = await OrderRepository().cancelOrder(id: id,reason: reason);
    Loading.close();
    if (response.result) {
      _onPageRefresh();
    }
    ToastComponent.showDialog(response.message);
  }

  _onPressReorder(id) async {
    Loading.show(context);
    var response = await OrderRepository().reOrder(id: id);
    Loading.close();
    Widget success = const SizedBox.shrink(), failed = const SizedBox.shrink();
    print(response.successMsgs.toString());
    print(response.failedMsgs.toString());
    if (response.successMsgs!.isNotEmpty) {
      success = Text(
        response.successMsgs?.join("\n") ?? "",
        style: TextStyle(fontSize: 14, color: MyTheme.green_light),
      );
    }
    if (response.failedMsgs!.isNotEmpty) {
      failed = Text(
        response.failedMsgs?.join("\n") ?? "",
        style: const TextStyle(fontSize: 14, color: Colors.red),
      );
    }

    InfoDialog.show(
        title: AppLocalizations.of(context)!.info_ucf,
        content: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              success,
              const SizedBox(
                height: 3,
              ),
              failed
            ],
          ),
        ));
  }

  _showCancelDialog(id) {
    /* return showDialog(
      context: context,
      builder: (BuildContext context) {
        return  AlertDialog(
          title: Text("Please ensure us."),
            content: Row(
              children: [
                SizedBox(
                  width: DeviceInfo(context).width! * 0.6,
                    child: Text("Do you want to cancel this order?"),)
              ],
            ),
          actions: [
            Btn.basic(
              color: MyTheme.font_grey,
              onPressed: ,
              child: Text(,style: TextStyle(fontSize: 14,color: MyTheme.white),),
            ),
            Btn.basic(
              color: Colors.red,
              onPressed: ,
              child: Text(,style: TextStyle(fontSize: 14,color: MyTheme.white),),
            ),
          ],
        );
      },);
    */
    return ConfirmDialog.show(
      context,
      title: "Please ensure us.",
      message: "We'd love to hear why your thinking about cancelling.",
      yesText: "Submit",
      noText: "Cancel",
      controller: cancelController,
      pressYes: () {
         if(cancelController.text != ""){
           _onPressCancelOrder(id,cancelController.text);
         }else{
           print("Failed");
         }

      },
    );
  }

  onPressOfflinePaymentButton() {
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    // return Checkout(
    //   order_id: widget.id,
    //   title: AppLocalizations.of(context)!.checkout_ucf,
    //   list: "offline",
    //   paymentFor: PaymentFor.ManualPayment,
    //   //offLinePaymentFor: OffLinePaymentFor.Order,
    //   rechargeAmount:
    //   double.parse(_orderDetails!.plane_grand_total.toString()),
    // );
    // })).then((value) {
    //   onPopped(value);
    // });
  }

  onTapAskRefund(item_id, item_name, order_code) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 10),
              contentPadding: const EdgeInsets.only(
                  top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)!.product_name_ucf,
                                style: const TextStyle(
                                    color: MyTheme.font_grey, fontSize: 12)),
                            Container(
                              width: 225,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(item_name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        color: MyTheme.font_grey,
                                        fontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)!.order_code_ucf,
                                style: const TextStyle(
                                    color: MyTheme.font_grey, fontSize: 12)),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(order_code,
                                  style: const TextStyle(
                                      color: MyTheme.font_grey, fontSize: 13)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Text(
                                "${AppLocalizations.of(context)!.reason_ucf} *",
                                style: const TextStyle(
                                    color: MyTheme.font_grey, fontSize: 12)),
                            _showReasonWarning
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                    ),
                                    child: Text(
                                        AppLocalizations.of(context)!
                                            .reason_cannot_be_empty,
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 12)),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: SizedBox(
                          height: 55,
                          child: TextField(
                            controller: _refundReasonController,
                            autofocus: false,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!
                                    .enter_reason_ucf,
                                hintStyle: const TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.textfield_grey),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 0.5),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 1.0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    left: 8.0, top: 16.0, bottom: 16.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Btn.minWidthFixHeight(
                        minWidth: 75,
                        height: 30,
                        color: const Color.fromRGBO(253, 253, 253, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyTheme.light_grey, width: 1.0)),
                        child: Text(
                          AppLocalizations.of(context)!.close_all_capital,
                          style: const TextStyle(
                            color: MyTheme.font_grey,
                          ),
                        ),
                        onPressed: () {
                          _refundReasonController.clear();
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: Btn.minWidthFixHeight(
                        minWidth: 75,
                        height: 30,
                        color: MyTheme.accent_color,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyTheme.light_grey, width: 1.0)),
                        child: Text(
                          AppLocalizations.of(context)!.submit_ucf,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          onPressSubmitRefund(item_id, setState);
                        },
                      ),
                    )
                  ],
                )
              ],
            );
          });
        });
  }

  shoWReasonWarning(setState) {
    setState(() {
      _showReasonWarning = true;
    });
    Timer timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _showReasonWarning = false;
      });
    });
  }

  onPressSubmitRefund(item_id, setState) async {
    var reason = _refundReasonController.text.toString();

    if (reason == "") {
      shoWReasonWarning(setState);
      return;
    }

    var refundRequestSendResponse = await RefundRequestRepository()
        .getRefundRequestSendResponse(id: item_id, reason: reason);

    if (refundRequestSendResponse.result == false) {
      ToastComponent.showDialog(refundRequestSendResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    Navigator.of(context, rootNavigator: true).pop();
    _refundReasonController.clear();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        refundRequestSendResponse.message,
        style: const TextStyle(color: MyTheme.font_grey),
      ),
      backgroundColor: MyTheme.soft_accent_color,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.show_request_list_ucf,
        onPressed: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return RefundRequest();
          // })).then((value) {
          //   onPopped(value);
          // });
          Get.to(() => RefundRequest())?.then((value) => onPopped(value));
        },
        textColor: MyTheme.accent_color,
        disabledTextColor: Colors.grey,
      ),
    ));

    reset();
    fetchAll();
    setState(() {});
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.from_notification || widget.go_back == false) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return MainPage();
          }));
          return Future<bool>.value(false);
        } else {
          return Future<bool>.value(true);
        }
      },
      child: Directionality(
        textDirection:
            app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(context),
          body: RefreshIndicator(
            color: MyTheme.accent_color,
            backgroundColor: Colors.white,
            onRefresh: _onPageRefresh,
            child: CustomScrollView(
              controller: _mainScrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 20.0),
                      child: _orderDetails != null
                          ? buildTimeLineTiles()
                          : buildTimeLineShimmer()),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18.0, bottom: 20.0),
                    child: _orderDetails != null
                        ? buildOrderDetailsTopCard()
                        : ShimmerHelper().buildBasicShimmer(height: 150.0),
                  ),
                ])),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.ordered_product_ucf,
                      style: const TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 18.0, right: 18.0, top: 14.0),
                      child: _orderedItemList.isEmpty && _orderItemsInit
                          ? ShimmerHelper().buildBasicShimmer(height: 100.0)
                          : (_orderedItemList.isNotEmpty
                              ? buildOrderdProductList()
                              : Container(
                                  height: 100,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .ordered_product_ucf,
                                    style: const TextStyle(
                                        color: MyTheme.font_grey),
                                  ),
                                )))
                ])),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 75,
                        ),
                        buildBottomSection()
                      ],
                    ),
                  )
                ])),
                SliverList(
                    delegate:
                        SliverChildListDelegate([buildPaymentButtonSection()]))
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildBottomSection() {
    return Expanded(
      child: _orderDetails != null
          ? Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)!.sub_total_all_capital,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          convertPrice(_orderDetails!.subtotal!),
                          style: const TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)!.tax_all_capital,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          convertPrice(_orderDetails!.tax!),
                          style: const TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)!
                                .shipping_cost_all_capital,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          convertPrice(_orderDetails!.shipping_cost!),
                          style: const TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)!.discount_all_capital,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          convertPrice(_orderDetails!.coupon_discount!),
                          style: const TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
                const Divider(),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: Text(
                            AppLocalizations.of(context)!
                                .grand_total_all_capital,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          convertPrice(_orderDetails!.grand_total!),
                          style: const TextStyle(
                              color: MyTheme.accent_color,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
              ],
            )
          : ShimmerHelper().buildBasicShimmer(height: 100.0),
    );
  }

  buildTimeLineShimmer() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ShimmerHelper().buildBasicShimmer(height: 40, width: 40.0),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ShimmerHelper().buildBasicShimmer(height: 20, width: 250.0),
        )
      ],
    );
  }

  buildTimeLineTiles() {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            isFirst: true,
            startChild: SizedBox(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width:
                        _orderDetails!.delivery_status == "pending" ? 36 : 30,
                    height:
                        _orderDetails!.delivery_status == "pending" ? 36 : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.redAccent, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: const Icon(
                      Icons.list_alt,
                      color: Colors.redAccent,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.medium_grey_50),
                  ),
                  const Spacer(),
                  Text(
                    AppLocalizations.of(context)!.order_placed,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: MyTheme.font_grey),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 0 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.only(left: 4),
              iconStyle: _stepIndex >= 0
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            afterLineStyle: _stepIndex >= 1
                ? const LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            startChild: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width:
                        _orderDetails!.delivery_status == "confirmed" ? 36 : 30,
                    height:
                        _orderDetails!.delivery_status == "confirmed" ? 36 : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.blue, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: const Icon(
                      Icons.thumb_up_sharp,
                      color: Colors.blue,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.medium_grey_50),
                  ),
                  const Spacer(),
                  Text(
                    AppLocalizations.of(context)!.confirmed_ucf,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: MyTheme.font_grey),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 1 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.only(left: 4),
              iconStyle: _stepIndex >= 1
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 1
                ? const LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
            afterLineStyle: _stepIndex >= 2
                ? const LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            startChild: SizedBox(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: _orderDetails!.delivery_status == "on_the_way"
                        ? 36
                        : 30,
                    height: _orderDetails!.delivery_status == "on_the_way"
                        ? 36
                        : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.amber, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: const Icon(
                      Icons.local_shipping_outlined,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.medium_grey_50),
                  ),
                  const Spacer(),
                  Text(
                    AppLocalizations.of(context)!.on_the_way_ucf,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: MyTheme.font_grey),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 2 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.only(left: 4),
              iconStyle: _stepIndex >= 2
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 2
                ? const LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
            afterLineStyle: _stepIndex >= 5
                ? const LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
          TimelineTile(
            axis: TimelineAxis.vertical,
            alignment: TimelineAlign.end,
            isLast: true,
            startChild: SizedBox(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width:
                        _orderDetails!.delivery_status == "delivered" ? 36 : 30,
                    height:
                        _orderDetails!.delivery_status == "delivered" ? 36 : 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.purple, width: 2),

                      //shape: BoxShape.rectangle,
                    ),
                    child: const Icon(
                      Icons.done_all,
                      color: Colors.purple,
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width * .4,
                        color: MyTheme.medium_grey_50),
                  ),
                  const Spacer(),
                  Text(
                    AppLocalizations.of(context)!.delivered_ucf,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: MyTheme.font_grey),
                  )
                ],
              ),
            ),
            indicatorStyle: IndicatorStyle(
              color: _stepIndex >= 5 ? Colors.green : MyTheme.medium_grey,
              padding: const EdgeInsets.only(left: 4),
              iconStyle: _stepIndex >= 5
                  ? IconStyle(
                      color: Colors.white, iconData: Icons.check, fontSize: 16)
                  : null,
            ),
            beforeLineStyle: _stepIndex >= 5
                ? const LineStyle(
                    color: Colors.green,
                    thickness: 5,
                  )
                : LineStyle(
                    color: MyTheme.medium_grey,
                    thickness: 4,
                  ),
          ),
        ],
      ),
    );
  }

  buildOrderDetailsTopCard() {
    return Container(
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.order_code_ucf,
                  style: const TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  AppLocalizations.of(context)!.shipping_method_ucf,
                  style: const TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    _orderDetails!.code!,
                    style: const TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    _orderDetails!.shipping_type_string!,
                    style: const TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.order_date_ucf,
                  style: const TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  AppLocalizations.of(context)!.payment_method_ucf,
                  style: const TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    _orderDetails!.date!,
                    style: const TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _orderDetails!.payment_type!,
                    style: const TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.payment_status_ucf,
                  style: const TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  AppLocalizations.of(context)!.delivery_status_ucf,
                  style: const TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      _orderDetails!.payment_status_string!,
                      style: const TextStyle(
                        color: MyTheme.grey_153,
                      ),
                    ),
                  ),
                  buildPaymentStatusCheckContainer(
                      _orderDetails!.payment_status),
                  const Spacer(),
                  Text(
                    _orderDetails!.delivery_status_string!,
                    style: const TextStyle(
                      color: MyTheme.grey_153,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  _orderDetails!.shipping_address != null
                      ? AppLocalizations.of(context)!.shipping_address_ucf
                      : AppLocalizations.of(context)!.pickup_point_ucf,
                  style: const TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  AppLocalizations.of(context)!.total_amount_ucf,
                  style: const TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  _orderDetails!.shipping_address != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _orderDetails!.shipping_address!.name != null
                                ? Text(
                                    "${AppLocalizations.of(context)!.name_ucf}: ${_orderDetails!.shipping_address!.name}",
                                    maxLines: 3,
                                    style: const TextStyle(
                                      color: MyTheme.grey_153,
                                    ),
                                  )
                                : Container(),
                            _orderDetails!.shipping_address!.email != null
                                ? Text(
                                    "${AppLocalizations.of(context)!.email_ucf}: ${_orderDetails!.shipping_address!.email}",
                                    maxLines: 3,
                                    style: const TextStyle(
                                      color: MyTheme.grey_153,
                                    ),
                                  )
                                : Container(),
                            Text(
                              "${AppLocalizations.of(context)!.address_ucf}: ${_orderDetails!.shipping_address!.address}",
                              maxLines: 3,
                              style: const TextStyle(
                                color: MyTheme.grey_153,
                              ),
                            ),
                            Text(
                              "${AppLocalizations.of(context)!.city_ucf}: ${_orderDetails!.shipping_address!.city}",
                              maxLines: 3,
                              style: const TextStyle(
                                color: MyTheme.grey_153,
                              ),
                            ),
                            Text(
                              "${AppLocalizations.of(context)!.country_ucf}: ${_orderDetails!.shipping_address!.country}",
                              maxLines: 3,
                              style: const TextStyle(
                                color: MyTheme.grey_153,
                              ),
                            ),
                            Text(
                              "${AppLocalizations.of(context)!.state_ucf}: ${_orderDetails!.shipping_address!.state}",
                              maxLines: 3,
                              style: const TextStyle(
                                color: MyTheme.grey_153,
                              ),
                            ),
                            Text(
                              "${AppLocalizations.of(context)!.phone_ucf}: ${_orderDetails!.shipping_address!.phone ?? ''}",
                              maxLines: 3,
                              style: const TextStyle(
                                color: MyTheme.grey_153,
                              ),
                            ),
                            Text(
                              "${AppLocalizations.of(context)!.postal_code}: ${_orderDetails!.shipping_address!.postal_code ?? ''}",
                              maxLines: 3,
                              style: const TextStyle(
                                color: MyTheme.grey_153,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _orderDetails!.pickupPoint!.name != null
                                ? Text(
                                    "${AppLocalizations.of(context)!.name_ucf}: ${_orderDetails!.pickupPoint!.name}",
                                    maxLines: 3,
                                    style: const TextStyle(
                                      color: MyTheme.grey_153,
                                    ),
                                  )
                                : Container(),
                            Text(
                              "${AppLocalizations.of(context)!.address_ucf}: ${_orderDetails!.pickupPoint!.address}",
                              maxLines: 3,
                              style: const TextStyle(
                                color: MyTheme.grey_153,
                              ),
                            ),
                            Text(
                              "${AppLocalizations.of(context)!.phone_ucf}: ${_orderDetails!.pickupPoint!.phone}",
                              maxLines: 3,
                              style: const TextStyle(
                                color: MyTheme.grey_153,
                              ),
                            ),
                          ],
                        ),
                  const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        convertPrice(_orderDetails!.grand_total!),
                        style: const TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      // Btn.basic(
                      //     // shape: RoundedRectangleBorder(side: Border()),
                      //
                      //     minWidth: 60,
                      //     // color: MyTheme.font_grey,
                      //     onPressed: () {
                      //       _onPressReorder(_orderDetails!.id);
                      //     },
                      //     child: Container(
                      //       padding: const EdgeInsets.all(8),
                      //       decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(8),
                      //           border: Border.all(color: MyTheme.light_grey)),
                      //       child: Row(
                      //         children: [
                      //           const Icon(
                      //             Icons.refresh,
                      //             color: MyTheme.grey_153,
                      //             size: 16,
                      //           ),
                      //           Text(
                      //             AppLocalizations.of(context)!.re_order_ucf,
                      //             style: const TextStyle(
                      //                 color: MyTheme.grey_153, fontSize: 14),
                      //           ),
                      //         ],
                      //       ),
                      //     )),
                      const SizedBox(
                        height: 8,
                      ),
                      Btn.basic(
                        // shape: RoundedRectangleBorder(side: Border()),

                        minWidth: 60,
                        // color: MyTheme.font_grey,
                        onPressed: () {
                          _downloadInvoice(_orderDetails!.id);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: MyTheme.medium_grey)),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.file_download_outlined,
                                color: MyTheme.grey_153,
                                size: 16,
                              ),
                              Text(
                                AppLocalizations.of(context)!.invoice_ucf,
                                style: const TextStyle(
                                    color: MyTheme.grey_153, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            if (_orderDetails!.delivery_status == "pending" &&
                _orderDetails!.payment_status == "unpaid")
              Btn.basic(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  minWidth: DeviceInfo(context).width,
                  color: MyTheme.font_grey,
                  onPressed: () {
                    _showCancelDialog(_orderDetails!.id);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.cancel_order_ucf,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ))
          ],
        ),
      ),
    );
  }

  buildOrderedProductItemsCard(index) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                _orderedItemList[index].product_name,
                maxLines: 2,
                style: const TextStyle(
                  color: MyTheme.font_grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    _orderedItemList[index].quantity.toString() + " x ",
                    style: const TextStyle(
                        color: MyTheme.font_grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  _orderedItemList[index].variation != "" &&
                          _orderedItemList[index].variation != null
                      ? Text(
                          _orderedItemList[index].variation,
                          style: const TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        )
                      : const Text(
                          "item",
                          style: TextStyle(
                              color: MyTheme.font_grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                  const Spacer(),
                  Text(
                    convertPrice(_orderedItemList[index].price),
                    style: const TextStyle(
                        color: MyTheme.accent_color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            _orderedItemList[index].refund_section &&
                    _orderedItemList[index].refund_button
                ? InkWell(
                    onTap: () {
                      onTapAskRefund(
                          _orderedItemList[index].id,
                          _orderedItemList[index].product_name,
                          _orderDetails!.code);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.ask_for_refund_ucf,
                            style: const TextStyle(
                                color: MyTheme.accent_color,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 2.0),
                            child: Icon(
                              Icons.rotate_left,
                              color: MyTheme.accent_color,
                              size: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
            _orderedItemList[index].refund_section &&
                    _orderedItemList[index].refund_label != ""
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.refund_status_ucf,
                            style: const TextStyle(color: MyTheme.font_grey),
                          ),
                          Text(
                            _orderedItemList[index].refund_label,
                            style: TextStyle(
                                color: getRefundRequestLabelColor(
                                    _orderedItemList[index]
                                        .refund_request_status)),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  getRefundRequestLabelColor(status) {
    if (status == 0) {
      return Colors.blue;
    } else if (status == 2) {
      return Colors.orange;
    } else if (status == 1) {
      return Colors.green;
    } else {
      return MyTheme.font_grey;
    }
  }

  buildOrderdProductList() {
    return Container(
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: SingleChildScrollView(
        child: ListView.separated(
          separatorBuilder: (context, index) =>
              Divider(color: MyTheme.medium_grey),
          itemCount: _orderedItemList.length,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return buildOrderedProductItemsCard(index);
          },
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      // centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
            icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.dark_grey),
            onPressed: () {
              if (widget.from_notification || widget.go_back == false) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MainPage();
                }));
              } else {
                return Navigator.of(context).pop();
              }
            }),
      ),
      title: Text(
        AppLocalizations.of(context)!.order_details_ucf,
        style: TextStyle(
            fontSize: 16,
            color: MyTheme.dark_font_grey,
            fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildPaymentButtonSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _orderDetails != null && _orderDetails!.manually_payable!
              ? Btn.basic(
                  color: MyTheme.soft_accent_color,
                  child: Text(
                    AppLocalizations.of(context)!.make_offline_payment_ucf,
                    style: const TextStyle(color: MyTheme.font_grey),
                  ),
                  onPressed: () {
                    onPressOfflinePaymentButton();
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  Container buildPaymentStatusCheckContainer(String? payment_status) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: payment_status == "paid" ? Colors.green : Colors.red),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Icon(payment_status == "paid" ? Icons.check : Icons.check,
            color: Colors.white, size: 10),
      ),
    );
  }
}
