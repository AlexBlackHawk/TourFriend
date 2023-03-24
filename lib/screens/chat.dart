import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/backend_chat.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/widgets/item_message_from_receiver.dart';
import 'package:travel_agency_work_optimization/widgets/item_message_from_sender.dart';

class Chat extends StatefulWidget {
  final String roomID;
  final ProgramUser userChat;
  final ProgramUser currUser;

  const Chat({super.key, required this.roomID, required this.userChat, required this.currUser});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final chatInputController = TextEditingController();
  bool haveText = false;
  final ScrollController _scrollController = ScrollController();
  bool needJump_toEnd = false;

  @override
  void dispose() {
    chatInputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // handle send message
  void handleSend_message(ChatBackend chatProvider) {
    if (haveText) {
      setState(() {
        needJump_toEnd = true;
      });

      MessageChat chatMessage = MessageChat(
        roomID: widget.roomID,
        fromUser: widget.currUser.userID,
        text: chatInputController.text,
        type: "text",
        time: DateTime.now().toString(),
      );
      chatProvider.sendChatMessage(chatMessage, widget.roomID).then((value) {
        chatInputController.text = "";
        // show send animation
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
        stop_sendAnimation();
        setState(() {
          haveText = false;
        });
      });
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: Colors.grey);
    }
  }

  // stop send animation for receive message after 300 milliseconds
  // becase we need 300 milliseconds to show animation send
  void stop_sendAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        needJump_toEnd = false;
      });
    });
  }

  void autoScroll_toEnd() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    } else {
      setState(() => null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatBackend>(context);
    return Scaffold(
      appBar: getAppBar(),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          messagesList(chatProvider),
          bottomTextBox(chatProvider),
        ],
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.lightBlue,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back,color: Colors.black,),
              ),
              const SizedBox(width: 2,),
              const CircleAvatar(
                backgroundImage: NetworkImage("https://assets.nhle.com/mugs/nhl/20222023/SEA/8482665.png"),
                maxRadius: 20,
              ),
              const SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Kriss Benwat",style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                    const SizedBox(height: 6,),
                    Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                  ],
                ),
              ),
              const Icon(Icons.settings,color: Colors.black54,),
            ],
          ),
        ),
      ),
    );
  }

  Widget messagesList(ChatBackend chatProvider) {
    return StreamBuilder<QuerySnapshot>(
      stream: chatProvider.getMessageWithChatroomID(widget.roomID),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          // if we got data
          if (snapshot.data!.docs.isEmpty) {
            // if they haven't sent message

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.userChat.photo),
                    radius: 50,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.userChat.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text("Say hello..."),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          } else {
            // if they have sent message
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // when we sen message we need the send animation,
              // but when we got the receive message we don't need animation
              if (!needJump_toEnd) autoScroll_toEnd();
            });

            // convert QuerySnapShot to List data
            List<MessageChat> messageData = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              String UserID_sent = snapshot.data!.docs[i]["fromUser"];

              messageData.add(MessageChat(
                  roomID: widget.roomID,
                  fromUser: snapshot.data!.docs[i]["fromUser"],
                  text: snapshot.data!.docs[i]["text"],
                  type: snapshot.data!.docs[i]["type"],
                  time: snapshot.data!.docs[i]["time"]));
            }

            return ListView.builder(
                controller: _scrollController,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return messageData[index].fromUser == widget.currUser.userID
                      ? ItemMessageFromSender(
                    message: messageData[index].text,
                  )
                      : ItemMessageFromReceiver(
                    photo: widget.userChat.photo,
                    message: messageData[index].text,
                    chatProvider: chatProvider,
                  );
                });
          }
        } else {
          return const Center(
            child: Text("Loading..."),
          );
        }
      },
    );
  }

  Align bottomTextBox(ChatBackend chatProvider) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 10,bottom: 10,top: 10),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            // GestureDetector(
            //   onTap: (){
            //   },
            //   child: Container(
            //     height: 30,
            //     width: 30,
            //     decoration: BoxDecoration(
            //       color: Colors.lightBlue,
            //       borderRadius: BorderRadius.circular(30),
            //     ),
            //     child: const Icon(Icons.add, color: Colors.white, size: 20, ),
            //   ),
            // ),
            const SizedBox(width: 15,),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Write message...",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none
                ),
              ),
            ),
            const SizedBox(width: 15,),
            FloatingActionButton(
              onPressed: () {
                handleSend_message(chatProvider);
              },
              backgroundColor: Colors.blue,
              elevation: 0,
              child: const Icon(Icons.send,color: Colors.white,size: 18,),
            ),
          ],

        ),
      ),
    );
  }
}
