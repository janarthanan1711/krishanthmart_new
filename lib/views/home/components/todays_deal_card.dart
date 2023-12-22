import 'package:flutter/material.dart';
import '../../../utils/colors.dart';
import '../../../utils/shared_value.dart';
import '../../../utils/system_config.dart';
import '../../mainpage/components/box_decorations.dart';

class TodayDealCard extends StatelessWidget {
  var identifier;
  int? id;
  String? image;
  String? name;
  String? main_price;
  String? stroked_price;
  bool? has_discount;
  bool? is_wholesale;
  var discount;

  TodayDealCard(
      {super.key,
      this.identifier,
      this.id,
      this.image,
      this.name,
      this.has_discount,
      this.is_wholesale,
      this.main_price,
      this.discount,
      this.stroked_price});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecorations.buildBoxDecoration_1().copyWith(),
        margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 20),
        // color: Colors.white,
        child: Stack(
          children: [
            Column(children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6), bottom: Radius.zero),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.png',
                      image: image!,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Text(
                        name!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 14,
                            height: 1.2,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    has_discount!
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                            child: Text(
                              stroked_price!,
                              // SystemConfig.systemCurrency!.code != null
                              //     ? stroked_price!.replaceAll(
                              //         SystemConfig.systemCurrency!.code!,
                              //         SystemConfig.systemCurrency!.symbol!)
                              //     : stroked_price!,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: MyTheme.medium_grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                          )
                        : Container(
                            height: 20.0,
                          ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        main_price!,
                        // SystemConfig.systemCurrency!.code != null
                        //     ? main_price!.replaceAll(
                        //         SystemConfig.systemCurrency!.code!,
                        //         SystemConfig.systemCurrency!.symbol!)
                        //     : main_price!,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            // discount and wholesale
            Positioned.fill(
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (has_discount!)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: const BoxDecoration(
                          color: MyTheme.accent_color2,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6.0),
                            bottomLeft: Radius.circular(6.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x14000000),
                              offset: Offset(-1, 1),
                              blurRadius: 1,
                            ),
                          ],
                        ),
                        child: Text(
                          discount ?? "",
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xffffffff),
                            fontWeight: FontWeight.w700,
                            height: 1.8,
                          ),
                          textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false),
                          softWrap: false,
                        ),
                      ),
                    Visibility(
                      visible: whole_sale_addon_installed.$,
                      child: is_wholesale != null && is_wholesale!
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: const BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(6.0),
                                  bottomLeft: Radius.circular(6.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x14000000),
                                    offset: Offset(-1, 1),
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Text(
                                "Wholesale",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.w700,
                                  height: 1.8,
                                ),
                                textHeightBehavior: TextHeightBehavior(
                                    applyHeightToFirstAscent: false),
                                softWrap: false,
                              ),
                            )
                          : const SizedBox.shrink(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
