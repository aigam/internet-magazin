import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/support_ticket_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/support_ticket_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:provider/provider.dart';

class SupportConversationScreen extends StatelessWidget {
  final SupportTicketModel supportTicketModel;
  SupportConversationScreen({Key? key, required this.supportTicketModel}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Provider.of<SupportTicketProvider>(context, listen: false).getSupportTicketReplyList(context, supportTicketModel.id);
    }

    return Scaffold(
      appBar: CustomAppBar(title: supportTicketModel.subject,),
      body: Column(children: [

        Expanded(child: Consumer<SupportTicketProvider>(builder: (context, support, child) {
          return support.supportReplyList != null ? ListView.builder(
            itemCount: support.supportReplyList!.length,
            reverse: true,
            itemBuilder: (context, index) {
              bool isMe = support.supportReplyList![index].customerMessage != null;
              String? message = isMe ? support.supportReplyList![index].customerMessage : support.supportReplyList![index].adminMessage;
              String dateTime = DateConverter.localDateToIsoStringAMPM(DateTime.parse(support.supportReplyList![index].createdAt!));

              return Container(
                margin: isMe ?  const EdgeInsets.fromLTRB(50, 5, 10, 5) : const EdgeInsets.fromLTRB(10, 5, 50, 5),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  bottomLeft: isMe ? const Radius.circular(10) : const Radius.circular(0),
                  bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ), color: isMe ? Theme.of(context).primaryColor.withOpacity(.1) : Theme.of(context).highlightColor,
                ),
                child: Column(crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,mainAxisSize: MainAxisSize.min, children: [
                  Text(dateTime, style: titilliumRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall, color: ColorResources.getHint(context),)),


                  message != null ?
                  Text(message, style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault)) : const SizedBox.shrink(),
                ]),
              );
            },
          ) : const Center(child: CircularProgressIndicator());
        })),


        SizedBox(height: 60,
          child: Card(color: Theme.of(context).highlightColor,
            shadowColor: Colors.grey[200],
            elevation: 2,
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Row(children: [
                Expanded(child: TextField(
                  controller: _controller,
                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    expands: true,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      hintText: 'Type here...',
                      hintStyle: titilliumRegular.copyWith(color: ColorResources.hintTextColor),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                InkWell(onTap: () {
                    if(_controller.text.isNotEmpty){
                      Provider.of<SupportTicketProvider>(context, listen: false).sendReply(context,
                          supportTicketModel.id, _controller.text);
                      _controller.text = '';
                    }
                  },
                  child: Icon(Icons.send, color: Theme.of(context).primaryColor, size: Dimensions.iconSizeDefault,),
                ),
              ]),
            ),
          ),
        ),

      ]),
    );
  }
}
