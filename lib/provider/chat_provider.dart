import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/message_body.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/chat_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/message_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/chat_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';


class ChatProvider extends ChangeNotifier {
  final ChatRepo? chatRepo;
  ChatProvider({required this.chatRepo});


  bool _isSendButtonActive = false;
  bool get isSendButtonActive => _isSendButtonActive;
  List<Chat>? _chatList;
  List<Chat>? get chatList => _chatList;
  bool _isSearching = false;
  bool get isSearching => _isSearching;
  File? _imageFile;
  File? get imageFile => _imageFile;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _userTypeIndex = 0;
  int get userTypeIndex =>  _userTypeIndex;
  ChatModel? chatModel;




  Future<void> getChatList(BuildContext context, int offset, {bool reload = true}) async {
    if(reload){
      _chatList = [];
      chatModel = null;
    }
    _isLoading = true;
    ApiResponse apiResponse = await chatRepo!.getChatList(_userTypeIndex == 0? 'seller' : 'delivery-man', offset);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _chatList = ChatModel.fromJson(apiResponse.response!.data).chat;
    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchChat(BuildContext context, String search) async {
    _isLoading = true;
    _chatList = [];
    chatModel = null;
    chatModel?.chat = [];
    ApiResponse apiResponse = await chatRepo!.searchChat(_userTypeIndex == 0? 'seller' : 'delivery-man', search);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _chatList = [];
      chatModel = null;
      chatModel?.chat?.clear();
      chatModel = ChatModel(totalSize: 1, limit: '1', offset: '1', chat: []);
      apiResponse.response!.data.forEach((chat) => chatModel!.chat!.add(Chat.fromJson(chat)));
      _chatList = chatModel!.chat;

    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }


  List<String> dateList = [];
  List<dynamic> messageList=[];
  List<Message> allMessageList=[];
  MessageModel? messageModel;
  Future<void> getMessageList(BuildContext context, int? id, int offset, {bool reload = true}) async {
    if(reload){
      messageModel = null;
      dateList = [];
      messageList = [];
      allMessageList = [];
    }
    _isLoading = true;
    ApiResponse apiResponse = await chatRepo!.getMessageList(_userTypeIndex == 0? 'seller' : 'delivery-man', id, offset);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {


      messageModel = null;
      dateList = [];
      messageList = [];
      allMessageList = [];
        messageModel = MessageModel.fromJson(apiResponse.response!.data);
        for (var data in messageModel!.message!) {
          if(!dateList.contains(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)))) {
            dateList.add(DateConverter.dateStringMonthYear(DateTime.tryParse(data.createdAt!)));
          }
          allMessageList.add(data);
        }


      for(int i=0;i< dateList.length;i++){
        messageList.add([]);
        for (var element in allMessageList) {
          if(dateList[i]== DateConverter.dateStringMonthYear(DateTime.tryParse(element.createdAt!))){
            messageList[i].add(element);
          }
        }
      }


    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }



  Future<ApiResponse> sendMessage(MessageBody messageBody, BuildContext context, ) async {
    _isSendButtonActive = true;
    notifyListeners();
    ApiResponse apiResponse = await chatRepo!.sendMessage(messageBody, _userTypeIndex == 0? 'seller' : 'delivery-man');
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      getMessageList(Get.context!, messageBody.id, 1, reload: false);

    } else {
      _isSendButtonActive = false;
      ApiChecker.checkApi( apiResponse);
    }
    _isSendButtonActive = false;
    notifyListeners();
    return apiResponse;
  }


  Future<ApiResponse> seenMessage(BuildContext context, int? sellerId, int? deliveryId) async {
    ApiResponse apiResponse = await chatRepo!.seenMessage(_userTypeIndex == 0? sellerId!: deliveryId!, _userTypeIndex == 0? 'seller' : 'delivery-man');
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      getChatList(Get.context!, 1);
    } else {
      ApiChecker.checkApi( apiResponse);
    }

    notifyListeners();
    return apiResponse;
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }

  void setImage(File image) {
    _imageFile = image;
    _isSendButtonActive = true;
    notifyListeners();
  }

  void removeImage(String text) {
    _imageFile = null;
    text.isEmpty ? _isSendButtonActive = false : _isSendButtonActive = true;
    notifyListeners();
  }

  void toggleSearch() {
    _isSearching = !_isSearching;
    notifyListeners();
  }
  void setUserTypeIndex(BuildContext context, int index) {
    _userTypeIndex = index;
    getChatList(context, 1);
    notifyListeners();
  }

}
