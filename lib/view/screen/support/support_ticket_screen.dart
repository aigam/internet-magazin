import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/support_ticket_model.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/support_ticket_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/support/support_ticket_item.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/support/support_ticket_type_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';


class SupportTicketScreen extends StatefulWidget {
  const SupportTicketScreen({Key? key}) : super(key: key);
  @override
  State<SupportTicketScreen> createState() => _SupportTicketScreenState();
}

class _SupportTicketScreenState extends State<SupportTicketScreen> {
  @override
  void initState() {
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Provider.of<SupportTicketProvider>(context, listen: false).getSupportTicketList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: getTranslated('support_ticket', context)),
        bottomNavigationBar: Provider.of<AuthProvider>(context, listen: false).isLoggedIn()?
        SizedBox(height: 70,
          child: InkWell(
            onTap: () {showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (con) => const SupportTicketTypeWidget()
              );
            },
            child: Padding(padding: const EdgeInsets.all(8.0),
              child: CustomButton(radius: Dimensions.paddingSizeExtraSmall, buttonText: getTranslated('add_new_ticket', context)),)),):const SizedBox(),
      body: Provider.of<AuthProvider>(context, listen: false).isLoggedIn()? Provider.of<SupportTicketProvider>(context).supportTicketList != null ? Provider.of<SupportTicketProvider>(context).supportTicketList!.isNotEmpty ?
      Consumer<SupportTicketProvider>(
        builder: (context, support, child) {
            List<SupportTicketModel> supportTicketList = support.supportTicketList!.reversed.toList();
            return RefreshIndicator(onRefresh: () async => await support.getSupportTicketList(),
              child: ListView.builder(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                itemCount: supportTicketList.length,
                itemBuilder: (context, index) {

                  return SupportTicketWidget(supportTicketModel: supportTicketList[index]);

                },
              ),
            );
          },
        ) : const NoInternetOrDataScreen(isNoInternet: false, icon: Images.noTicket,
      message: 'no_ticket_created',) : const SupportTicketShimmer():const NotLoggedInWidget(),
      );
  }
}

class SupportTicketShimmer extends StatelessWidget {
  const SupportTicketShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      itemCount: 10,
      itemBuilder: (context, index) {

        return Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).hintColor, width: 0.2),
          ),
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).cardColor,
            highlightColor: Colors.grey[100]!,
            enabled: Provider.of<SupportTicketProvider>(context).supportTicketList == null,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(height: 10, width: 100, color: ColorResources.white),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Container(height: 15, color: ColorResources.white),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Row(children: [
                Container(height: 15, width: 15, color: ColorResources.white),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Container(height: 15, width: 50, color: ColorResources.white),
                const Expanded(child: SizedBox.shrink()),
                Container(height: 30, width: 70, color: ColorResources.white),
              ]),
            ]),
          ),
        );

      },
    );
  }
}

