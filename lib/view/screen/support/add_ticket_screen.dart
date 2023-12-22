import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/support_ticket_body.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/support_ticket_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/support/support_ticket_type_widget.dart';
import 'package:provider/provider.dart';

class AddTicketScreen extends StatefulWidget {
  final TicketModel ticketModel;
  const AddTicketScreen({Key? key, required this.ticketModel}) : super(key: key);

  @override
  AddTicketScreenState createState() => AddTicketScreenState();
}

class AddTicketScreenState extends State<AddTicketScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _subjectNode = FocusNode();
  final FocusNode _descriptionNode = FocusNode();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated('add_new_ticket', context),),
      body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge), children: [

        Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeTwelve),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(.125),
                border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.15)),
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeEight)),
            margin:  const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
            child: Row(children: [
              SizedBox(width: 20, child: Image.asset(widget.ticketModel.icon)),
              Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: Text(getTranslated(widget.ticketModel.title, context)!, style: textBold))])),

        CustomTextField(
          focusNode: _subjectNode,
          nextFocus: _descriptionNode,
          required: true,
          inputAction: TextInputAction.next,
          labelText: '${getTranslated('subject', context)}',
          hintText: getTranslated('write_your_subject', context),
          controller: _subjectController,),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        CustomTextField(
          required: true,
          focusNode: _descriptionNode,
          inputAction: TextInputAction.newline,
          hintText: getTranslated('issue_description', context),
          inputType: TextInputType.multiline,
          controller: _descriptionController,
          labelText: '${getTranslated('description', context)}',
          maxLines: 5,
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),


      ]),
      bottomNavigationBar: Provider.of<SupportTicketProvider>(context).isLoading ?
      Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))) :
      Container(color: Theme.of(context).cardColor,
        child: Builder(key: _scaffoldKey,
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
            child: CustomButton(
                buttonText: getTranslated('submit', context),
                onTap: () {
                  if (_subjectController.text.isEmpty) {
                    showCustomSnackBar('Subject box should not be empty', context);
                  } else if (_descriptionController.text.isEmpty) {
                    showCustomSnackBar('Description box should not be empty', context);
                  } else {
                    SupportTicketBody supportTicketModel = SupportTicketBody('${getTranslated(widget.ticketModel.title, context)}',
                        _subjectController.text, _descriptionController.text);
                    Provider.of<SupportTicketProvider>(context, listen: false).sendSupportTicket(supportTicketModel, callback, context);
                  }
                }),
          ),
        ),
      ),
    );
  }

  void callback (bool isSuccess, String? message) {
    if (kDebugMode) {
      print(message);
    }
    if (isSuccess) {
      _subjectController.text = '';
      _descriptionController.text = '';
      Navigator.of(context).pop();
    } else {}
  }
}
