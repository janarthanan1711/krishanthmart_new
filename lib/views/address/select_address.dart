import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:krishanthmart_new/views/address/address_page.dart';
import 'package:toast/toast.dart';
import '../../repositories/address_repositories.dart';
import '../../utils/btn_elements.dart';
import '../../utils/colors.dart';
import '../../utils/shared_value.dart';
import '../../utils/shimmer_utils.dart';
import '../../utils/toast_component.dart';
import '../../utils/useful_elements.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SelectAddress extends StatefulWidget {
  int? owner_id;
  SelectAddress({Key? key,this.owner_id}) : super(key: key);

  @override
  State<SelectAddress> createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  ScrollController _mainScrollController = ScrollController();

  // integer type variables
  int? _seleted_shipping_address = 0;

  // list type variables
  List<dynamic> _shippingAddressList = [];
  // List<PickupPoint> _pickupList = [];
  // List<City> _cityList = [];
  // List<Country> _countryList = [];

  // String _shipping_cost_string = ". . .";

  // Boolean variables
  bool isVisible = true;
  bool _faceData = false;

  //double variables
  double mWidth = 0;
  double mHeight = 0;



  fetchAll() {
    if (is_logged_in.$ == true) {
      fetchShippingAddressList();
      //fetchPickupPoints();
    }
    setState(() {});
  }

  fetchShippingAddressList() async {
    var addressResponse = await AddressRepository().getAddressList();
    _shippingAddressList.addAll(addressResponse.addresses);
    if (_shippingAddressList.length > 0) {
      _seleted_shipping_address = _shippingAddressList[0].id;

      _shippingAddressList.forEach((address) {
        if (address.set_default == 1) {
          _seleted_shipping_address = address.id;
        }
      });
    }
    _faceData = true;
    setState(() {});

    // getSetShippingCost();
  }



  reset() {
    _shippingAddressList.clear();
    _faceData = false;
    _seleted_shipping_address = 0;
  }

  Future<void> _onRefresh() async {
    reset();
    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  afterAddingAnAddress() {
    reset();
    fetchAll();
  }



  onPressProceed(context) async {


    if (_seleted_shipping_address == 0) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)!.choose_an_address_or_pickup_point,
          gravity: Toast.center,
          duration: Toast.lengthLong);
      return;
    }

    late var addressUpdateInCartResponse;

    if (_seleted_shipping_address != 0) {
      print("${_seleted_shipping_address}dddd");
      addressUpdateInCartResponse = await AddressRepository()
          .getAddressUpdateInCartResponse(
          address_id: _seleted_shipping_address);
    }
    if (addressUpdateInCartResponse.result == false) {
      ToastComponent.showDialog(addressUpdateInCartResponse.message,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    ToastComponent.showDialog(addressUpdateInCartResponse.message,
        gravity: Toast.center, duration: Toast.lengthLong);
    //
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return ShippingInfo();
    // })).then((value) {
    //   onPopped(value);
    // });
    // } else if (_seleted_shipping_pickup_point != 0) {
    //   print("Selected pickup point ");
    // } else {
    //   print("..........something is wrong...........");
    // }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    mHeight = MediaQuery.of(context).size.height;
    mWidth = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar:AppBar(
          elevation: 0,
          leading: UsefulElements.backButton(context),
          backgroundColor: MyTheme.white,title: buildAppbarTitle(context),),
        backgroundColor: Colors.white,
        bottomNavigationBar: buildBottomAppBar(context),
        body: buildBody(context),),
    );
  }

  RefreshIndicator buildBody(BuildContext context) {
    return RefreshIndicator(
      color: MyTheme.accent_color,
      backgroundColor: Colors.white,
      onRefresh: _onRefresh,
      displacement: 0,
      child: Container(
        child: buildBodyChildren(context),
      ),
    );
  }

  Widget buildBodyChildren(BuildContext context) {
    return buildShippingListContainer(context);
  }

  Container buildShippingListContainer(BuildContext context) {
    return Container(
      child: CustomScrollView(
        controller: _mainScrollController,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: buildShippingInfoList()

                ),
                buildAddOrEditAddress(context),
                const SizedBox(
                  height: 100,
                )
              ]))
        ],
      ),
    );
  }

  Widget buildAddOrEditAddress(BuildContext context) {
    return Container(
      height: 40,
      child: Center(
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Address(
                from_shipping_info: true,
              );
            })).then((value) {
              onPopped(value);
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations.of(context)!.to_add_or_edit_addresses_go_to_address_page,
              style: const TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  color: MyTheme.accent_color),
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        "${AppLocalizations.of(context)!.shipping_cost_ucf}",
        style: const TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildShippingInfoList() {
    if (is_logged_in.$ == false) {
      return SizedBox(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context)!.you_need_to_log_in,
                style: const TextStyle(color: MyTheme.font_grey),
              )));
    } else if (!_faceData && _shippingAddressList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_shippingAddressList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _shippingAddressList.length,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: buildShippingInfoItemCard(index),
            );
          },
        ),
      );
    } else if (_faceData && _shippingAddressList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                AppLocalizations.of(context)!.no_address_is_added,
                style: const TextStyle(color: MyTheme.font_grey),
              )));
    }
  }

  GestureDetector buildShippingInfoItemCard(index) {
    return GestureDetector(
      onTap: () {
        if (_seleted_shipping_address != _shippingAddressList[index].id) {
          _seleted_shipping_address = _shippingAddressList[index].id;

          // onAddressSwitch();
        }
        //detectShippingOption();
        setState(() {});
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: _seleted_shipping_address == _shippingAddressList[index].id
              ? const BorderSide(color: MyTheme.accent_color, width: 2.0)
              : BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: buildShippingInfoItemChildren(index),
        ),
      ),
    );
  }

  Column buildShippingInfoItemChildren(index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildShippingInfoItemAddress(index),
        buildShippingInfoItemCity(index),
        buildShippingInfoItemState(index),
        buildShippingInfoItemCountry(index),
        buildShippingInfoItemPostalCode(index),
        buildShippingInfoItemPhone(index),
      ],
    );
  }

  Padding buildShippingInfoItemPhone(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            child: Text(
              AppLocalizations.of(context)!.phone_ucf,
              style: const TextStyle(
                color: MyTheme.grey_153,
              ),
            ),
          ),
          Container(
            width: 200,
            child: Text(
              _shippingAddressList[index].phone,
              maxLines: 2,
              style: TextStyle(
                  color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildShippingInfoItemPostalCode(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            child: Text(
              AppLocalizations.of(context)!.postal_code,
              style: const TextStyle(
                color: MyTheme.grey_153,
              ),
            ),
          ),
          Container(
            width: 200,
            child: Text(
              _shippingAddressList[index].postal_code,
              maxLines: 2,
              style: TextStyle(
                  color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildShippingInfoItemCountry(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            child: Text(
              AppLocalizations.of(context)!.country_ucf,
              style: const TextStyle(
                color: MyTheme.grey_153,
              ),
            ),
          ),
          Container(
            width: 200,
            child: Text(
              _shippingAddressList[index].country_name,
              maxLines: 2,
              style: TextStyle(
                  color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildShippingInfoItemState(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            child: Text(
              AppLocalizations.of(context)!.state_ucf,
              style: const TextStyle(
                color: MyTheme.grey_153,
              ),
            ),
          ),
          Container(
            width: 200,
            child: Text(
              _shippingAddressList[index].state_name,
              maxLines: 2,
              style: TextStyle(
                  color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildShippingInfoItemCity(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            child: Text(
              AppLocalizations.of(context)!.city_ucf,
              style: const TextStyle(
                color: MyTheme.grey_153,
              ),
            ),
          ),
          Container(
            width: 200,
            child: Text(
              _shippingAddressList[index].city_name,
              maxLines: 2,
              style: TextStyle(
                  color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildShippingInfoItemAddress(index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            child: Text(
              AppLocalizations.of(context)!.address_ucf,
              style: const TextStyle(
                color: MyTheme.grey_153,
              ),
            ),
          ),
          Container(
            width: 175,
            child: Text(
              _shippingAddressList[index].address,
              maxLines: 2,
              style: TextStyle(
                  color: MyTheme.dark_grey, fontWeight: FontWeight.w600),
            ),
          ),
          const Spacer(),
          buildShippingOptionsCheckContainer(
              _seleted_shipping_address == _shippingAddressList[index].id)
        ],
      ),
    );
  }



  Container buildShippingOptionsCheckContainer(bool check) {
    return check
        ? Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0), color: Colors.green),
      child: const Padding(
        padding: EdgeInsets.all(3),
        child: Icon(Icons.check, color: Colors.white, size: 10),
      ),
    )
        : Container();
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        color: Colors.transparent,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Btn.minWidthFixHeight(
              minWidth: MediaQuery.of(context).size.width,
              height: 50,
              color: MyTheme.accent_color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              child: Text(
                AppLocalizations.of(context)!
                    .continue_to_delivery_info_ucf,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                onPressProceed(context);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget customAppBar(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: MyTheme.white,
              child: Row(
                children: [
                  buildAppbarBackArrow(),

                ],
              ),
            ),
            // container for gaping into title text and title-bottom buttons
            Container(
              padding: const EdgeInsets.only(top: 2),
              width: mWidth,
              color: MyTheme.light_grey,
              height: 1,
            ),
            //buildChooseShippingOption(context)
          ],
        ),
      ),
    );
  }

  SizedBox buildAppbarTitle(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: Text(
        AppLocalizations.of(context)!.shipping_info,
        style: TextStyle(
          fontSize: 16,
          color: MyTheme.dark_font_grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  SizedBox buildAppbarBackArrow() {
    return SizedBox(
      width: 40,
      child: UsefulElements.backButton(context),
    );
  }

}