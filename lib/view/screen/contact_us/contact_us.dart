import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:provider/provider.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(centerTitle: true,title: '${getTranslated('contact_us', context)}'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(width: MediaQuery.of(context).size.width/2,child: Image.asset(Images.contactUsBg)),
            CustomTextField(prefixIcon: Images.user,
            controller: fullNameController,
            required: true,
            labelText: getTranslated('full_name', context),
            hintText: getTranslated('enter_full_name', context),),
            const SizedBox(height: Dimensions.paddingSizeDefault,),

            CustomTextField(hintText: getTranslated('email', context),
            prefixIcon: Images.email,
              required: true,
            labelText: getTranslated('email', context),
            controller: emailController,),
            const SizedBox(height: Dimensions.paddingSizeDefault,),


            CustomTextField(showCodePicker: true,
            hintText: '123 456 789',
              required: true,
            labelText: getTranslated('mobile', context),
            isAmount: true,
            inputType: TextInputType.phone,
            controller: phoneController,),
            const SizedBox(height: Dimensions.paddingSizeDefault,),


            CustomTextField(
              required: true,
              labelText: getTranslated('subject', context),
              hintText: getTranslated('subject', context),
            controller: subjectController,),
            const SizedBox(height: Dimensions.paddingSizeDefault,),


            CustomTextField(maxLines: 5,
              required: true,
              controller: messageController,
              labelText: getTranslated('message', context),
              hintText: getTranslated('message', context),),

          ],),
        ),
      ),
      bottomNavigationBar: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          return Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: CustomButton(buttonText: getTranslated('send_request', context),
            onTap: (){
              String name = fullNameController.text.trim();
              String email = emailController.text.trim();
              String phone = phoneController.text.trim();
              String subject = subjectController.text.trim();
              String message = messageController.text.trim();
              if(name.isEmpty){
                showCustomSnackBar('${getTranslated('name_is_required', context)}', context);
              } else if(email.isEmpty){
                showCustomSnackBar('${getTranslated('email_is_required', context)}', context);
              } else if(phone.isEmpty){
                showCustomSnackBar('${getTranslated('phone_is_required', context)}', context);
              }else if(subject.isEmpty){
                showCustomSnackBar('${getTranslated('subject_is_required', context)}', context);
              }else if(message.isEmpty){
                showCustomSnackBar('${getTranslated('message_is_required', context)}', context);
              }else{
                profileProvider.contactUs(name, email, phone, subject, message).then((value){
                  fullNameController.clear();
                  emailController.clear();
                  phoneController.clear();
                  subjectController.clear();
                  messageController.clear();
                });
              }
            },),
          );
        }
      ),
    );
  }
}
