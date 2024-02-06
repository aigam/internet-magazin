import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/address/saved_address_list_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/address/saved_billing_address_list_screen.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../../../provider/cart_provider.dart';

class ShippingDetailsWidget extends StatefulWidget {
  final String? groupId;
  final bool hasPhysical;
  final bool billingAddress;
  final double amount;
  const ShippingDetailsWidget(
      {Key? key,
      required this.groupId,
      required this.hasPhysical,
      required this.billingAddress,
      required this.amount})
      : super(key: key);

  @override
  ShippingDetailsWidgetState createState() => ShippingDetailsWidgetState();
}

class ShippingDetailsWidgetState extends State<ShippingDetailsWidget> {
  InAppWebViewGroupOptions? options;
  var inner = "";

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }

    options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          transparentBackground: true, useShouldOverrideUrlLoading: true),
      android: AndroidInAppWebViewOptions(useHybridComposition: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PvzModel pvz = Provider.of<CartProvider>(context, listen: true).pvz;

    return Consumer<OrderProvider>(builder: (context, shipping, _) {
      return Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
        return Container(
          padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall,
              Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall, 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.hasPhysical
                    ? Card(
                        child: Container(
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Dimensions.paddingSizeDefault),
                            color: Theme.of(context).cardColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Row(
                                    children: [
                                      SizedBox(
                                          width: 18,
                                          child:
                                              Image.asset(Images.deliveryTo)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: Dimensions
                                                .paddingSizeExtraSmall),
                                        child: Text(
                                            Provider.of<CartProvider>(context,
                                                        listen: false)
                                                    .sdek
                                                ? 'Выберите пункт самовывоза'
                                                : '${getTranslated('delivery_to', context)}',
                                            style: titilliumRegular.copyWith(
                                                fontWeight: FontWeight.w600)),
                                      ),
                                    ],
                                  )),
                                  if (!Provider.of<CartProvider>(context,
                                          listen: false)
                                      .sdek)
                                    InkWell(
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const SavedAddressListScreen())),
                                      child: SizedBox(
                                          width: 20,
                                          child: Image.asset(Images.edit,
                                              scale: 3)),
                                    ),
                                ],
                              ),
                              const SizedBox(
                                height: Dimensions.paddingSizeDefault,
                              ),
                              !Provider.of<CartProvider>(context, listen: false)
                                      .sdek
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          Text(
                                            (Provider.of<OrderProvider>(context,
                                                                listen: false)
                                                            .addressIndex ==
                                                        null ||
                                                    Provider.of<ProfileProvider>(
                                                            context,
                                                            listen: false)
                                                        .addressList
                                                        .isEmpty)
                                                ? '${getTranslated('address_type', context)}'
                                                : Provider.of<ProfileProvider>(
                                                        context,
                                                        listen: false)
                                                    .addressList[Provider.of<
                                                                OrderProvider>(
                                                            context,
                                                            listen: false)
                                                        .addressIndex!]
                                                    .addressType!
                                                    .capitalize(),
                                            style: titilliumBold.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeLarge),
                                            maxLines: 3,
                                            overflow: TextOverflow.fade,
                                          ),
                                          const Divider(),
                                          (Provider.of<OrderProvider>(context,
                                                              listen: false)
                                                          .addressIndex ==
                                                      null ||
                                                  Provider.of<ProfileProvider>(
                                                          context,
                                                          listen: false)
                                                      .addressList
                                                      .isEmpty)
                                              ? Text(
                                                  getTranslated(
                                                          'add_your_address',
                                                          context) ??
                                                      '',
                                                  style:
                                                      titilliumRegular.copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeSmall),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.fade,
                                                )
                                              : Column(
                                                  children: [
                                                    AddressInfoItem(
                                                        icon: Images.user,
                                                        title: profileProvider
                                                                .addressList[
                                                                    shipping
                                                                        .addressIndex!]
                                                                .contactPersonName ??
                                                            ''),
                                                    AddressInfoItem(
                                                        icon: Images.callIcon,
                                                        title: profileProvider
                                                                .addressList[
                                                                    shipping
                                                                        .addressIndex!]
                                                                .phone ??
                                                            ''),
                                                    AddressInfoItem(
                                                        icon: Images.address,
                                                        title: profileProvider
                                                                .addressList[
                                                                    shipping
                                                                        .addressIndex!]
                                                                .address ??
                                                            ''),
                                                  ],
                                                ),
                                        ])
                                  : GestureDetector(
                                      onTap: () {
                                        var _isLoading = false;

                                        showModalBottomSheet(
                                            backgroundColor: Colors.white,
                                            useSafeArea: true,
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (_) {
                                              return SafeArea(
                                                  top: true,
                                                  child: StatefulBuilder(
                                                      builder:
                                                          (context, state) {
                                                    return Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          inner == ""
                                                              ? InAppWebView(
                                                                  initialUrlRequest:
                                                                      URLRequest(
                                                                          url: Uri.parse(
                                                                              "https://elisirclub.ru/sdek_map")),
                                                                  initialOptions:
                                                                      options,
                                                                  onLoadStop:
                                                                      (controller,
                                                                          url) async {
                                                                    var html = await controller
                                                                        .evaluateJavascript(
                                                                            source:
                                                                                "window.document.getElementsByTagName('html')[0].outerHTML;");

                                                                    state(() {
                                                                      _isLoading =
                                                                          true;
                                                                    });

                                                                    if (html !=
                                                                        "") {
                                                                      setState(
                                                                          () {
                                                                        inner =
                                                                            html;
                                                                      });
                                                                    }
                                                                  },
                                                                  onConsoleMessage:
                                                                      (controller,
                                                                          message) {
                                                                    if (message
                                                                        .message
                                                                        .contains(
                                                                            "ПВЗ = ")) {
                                                                      var mes = message
                                                                          .message
                                                                          .replaceAll(
                                                                              "ПВЗ = ",
                                                                              "")
                                                                          .split(
                                                                              "&");
                                                                      var arr =
                                                                          PvzModel();

                                                                      for (var i
                                                                          in mes) {
                                                                        final List<String>
                                                                            str =
                                                                            i.split("=");

                                                                        if (str
                                                                            .isNotEmpty) {
                                                                          if (str.first ==
                                                                              "tarif") {
                                                                            arr.tariffId =
                                                                                str.last;
                                                                          } else if (str.first ==
                                                                              "price") {
                                                                            arr.price =
                                                                                double.parse(str.last);
                                                                          } else if (str.first ==
                                                                              "term") {
                                                                            arr.term =
                                                                                str.last;
                                                                          } else if (str.first ==
                                                                              "id") {
                                                                            arr.id =
                                                                                str.last;
                                                                          } else if (str.first ==
                                                                              "address") {
                                                                            arr.address =
                                                                                str.last;
                                                                          }
                                                                        }
                                                                      }

                                                                      Provider.of<CartProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .setSdekPvz(
                                                                              arr);
                                                                      Provider.of<CartProvider>(context, listen: false).addShippingMethod(
                                                                          context,
                                                                          Provider.of<CartProvider>(context, listen: false)
                                                                              .sdekId,
                                                                          widget
                                                                              .groupId);
                                                                    }
                                                                  },
                                                                )
                                                              : InAppWebView(
                                                                  initialData:
                                                                      InAppWebViewInitialData(
                                                                          data:
                                                                              inner),
                                                                  initialOptions:
                                                                      options,
                                                                  onLoadStop:
                                                                      (controller,
                                                                          url) async {
                                                                    state(() {
                                                                      _isLoading =
                                                                          true;
                                                                    });
                                                                  },
                                                                  onConsoleMessage:
                                                                      (controller,
                                                                          message) {
                                                                    if (message
                                                                        .message
                                                                        .contains(
                                                                            "ПВЗ = ")) {
                                                                      var mes = message
                                                                          .message
                                                                          .replaceAll(
                                                                              "ПВЗ = ",
                                                                              "")
                                                                          .split(
                                                                              "&");
                                                                      var arr =
                                                                          PvzModel();

                                                                      for (var i
                                                                          in mes) {
                                                                        final List<String>
                                                                            str =
                                                                            i.split("=");

                                                                        if (str
                                                                            .isNotEmpty) {
                                                                          if (str.first ==
                                                                              "tarif") {
                                                                            arr.tariffId =
                                                                                str.last;
                                                                          } else if (str.first ==
                                                                              "price") {
                                                                            arr.price =
                                                                                double.parse(str.last);
                                                                          } else if (str.first ==
                                                                              "term") {
                                                                            arr.term =
                                                                                str.last;
                                                                          } else if (str.first ==
                                                                              "id") {
                                                                            arr.id =
                                                                                str.last;
                                                                          } else if (str.first ==
                                                                              "address") {
                                                                            arr.address =
                                                                                str.last;
                                                                          }
                                                                        }
                                                                      }

                                                                      Provider.of<CartProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .setSdekPvz(
                                                                              arr);
                                                                      Provider.of<CartProvider>(context, listen: false).addShippingMethod(
                                                                          context,
                                                                          Provider.of<CartProvider>(context, listen: false)
                                                                              .sdekId,
                                                                          widget
                                                                              .groupId);
                                                                    }
                                                                  },
                                                                ),
                                                          if (!_isLoading)
                                                            CircularProgressIndicator(
                                                                valueColor: AlwaysStoppedAnimation<
                                                                    Color>(Theme.of(
                                                                        context)
                                                                    .primaryColor)),
                                                        ]);
                                                  }));
                                            });
                                      },
                                      child: Text(
                                        pvz.address != null && pvz.address == ""
                                            ? "Выбрать пункт выдачи"
                                            : (pvz.address ??
                                                "Выбрать пункт выдачи"),
                                        style:
                                            const TextStyle(color: Colors.blue),
                                      ))
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
                SizedBox(
                    height:
                        widget.hasPhysical ? Dimensions.paddingSizeSmall : 0),
                widget.billingAddress
                    ? Card(
                        child: Container(
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Dimensions.paddingSizeDefault),
                            color: Theme.of(context).cardColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Row(
                                    children: [
                                      SizedBox(
                                          width: 18,
                                          child: Image.asset(Images.billingTo)),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                  .paddingSizeExtraSmall),
                                          child: Text(
                                              '${getTranslated('billing_to', context)}',
                                              style: titilliumRegular.copyWith(
                                                  fontWeight:
                                                      FontWeight.w600))),
                                    ],
                                  )),
                                  InkWell(
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const SavedBillingAddressListScreen())),
                                    child: SizedBox(
                                        width: 20,
                                        child:
                                            Image.asset(Images.edit, scale: 3)),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: Dimensions.paddingSizeDefault,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (Provider.of<OrderProvider>(context)
                                                    .billingAddressIndex ==
                                                null ||
                                            Provider.of<ProfileProvider>(
                                                    context,
                                                    listen: false)
                                                .billingAddressList
                                                .isEmpty)
                                        ? '${getTranslated('address_type', context)}'
                                        : Provider.of<ProfileProvider>(context,
                                                listen: false)
                                            .billingAddressList[
                                                Provider.of<OrderProvider>(
                                                        context,
                                                        listen: false)
                                                    .billingAddressIndex!]
                                            .addressType!
                                            .capitalize(),
                                    style: titilliumBold.copyWith(
                                        fontSize: Dimensions.fontSizeLarge),
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                  ),
                                  const Divider(),
                                  (Provider.of<OrderProvider>(context)
                                                  .billingAddressIndex ==
                                              null ||
                                          Provider.of<ProfileProvider>(context,
                                                  listen: false)
                                              .billingAddressList
                                              .isEmpty)
                                      ? Text(
                                          getTranslated(
                                              'add_your_address', context)!,
                                          style: titilliumRegular.copyWith(
                                              fontSize:
                                                  Dimensions.fontSizeSmall),
                                          maxLines: 3,
                                          overflow: TextOverflow.fade,
                                        )
                                      : Column(
                                          children: [
                                            AddressInfoItem(
                                                icon: Images.user,
                                                title: profileProvider
                                                        .billingAddressList[shipping
                                                            .billingAddressIndex!]
                                                        .contactPersonName ??
                                                    ''),
                                            AddressInfoItem(
                                                icon: Images.callIcon,
                                                title: profileProvider
                                                        .billingAddressList[shipping
                                                            .billingAddressIndex!]
                                                        .phone ??
                                                    ''),
                                            AddressInfoItem(
                                                icon: Images.address,
                                                title: profileProvider
                                                        .billingAddressList[shipping
                                                            .billingAddressIndex!]
                                                        .address ??
                                                    ''),
                                          ],
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
              ]),
        );
      });
    });
  }
}

class AddressInfoItem extends StatelessWidget {
  final String? icon;
  final String? title;
  const AddressInfoItem({Key? key, this.icon, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeExtraSmall),
      child: Row(
        children: [
          SizedBox(width: 18, child: Image.asset(icon!)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeSmall),
              child: Text(title ?? '',
                  style: textRegular.copyWith(),
                  maxLines: 2,
                  overflow: TextOverflow.fade),
            ),
          )
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class PvzModel {
  String? tariffId;
  double? price;
  String? term;
  String? id;
  String? address;

  PvzModel({this.tariffId, this.price, this.term, this.id, this.address});

  PvzModel.fromJson(Map<String, dynamic> json) {
    tariffId = json['tariffId'];
    price = json['price'];
    term = json['term'];
    id = json['id'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tariffId'] = tariffId;
    data['price'] = price;
    data['term'] = term;
    data['id'] = id;
    data['address'] = address;
    return data;
  }
}
