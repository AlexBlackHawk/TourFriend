import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_agency_work_optimization/widgets/message_item.dart';
import 'package:travel_agency_work_optimization/backend_authentication.dart';
import 'package:travel_agency_work_optimization/backend_chat.dart';
import 'package:travel_agency_work_optimization/backend_storage.dart';
import 'package:travel_agency_work_optimization/backend_database.dart';

class Chat extends StatefulWidget implements PreferredSizeWidget {
  final AuthenticationBackend auth;
  final ChatBackend chat;
  final StorageBackend storage;
  final DatabaseBackend database;
  final String chatRoomId;
  const Chat({super.key, required this.auth, required this.chat, required this.storage, required this.database, required this.chatRoomId});

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final chatInputController = TextEditingController();
  late Stream<QuerySnapshot> chats;
  late Future<Map<String, dynamic>> chatRoom;
  late Future<Map<String, dynamic>> userData;

  @override
  void initState() {
    super.initState();
    chatRoom = widget.chat.getChatRoomInfo(widget.chatRoomId);
    chats = widget.chat.getChats(widget.chatRoomId);
    // setState(() async {
    //   for (var i = 0; i < chatRoom!["users"].length; i++){
    //     if (chatRoom!["users"][i] != widget.auth.user!.uid) {
    //       userData = widget.database.getUserInfo(chatRoom!["users"][i]);
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    chatInputController.dispose();
    super.dispose();
  }

  // handle send message
  void handleSendMessage() {
    print("1");
    if (chatInputController.text.isNotEmpty) {
      print("2");
      String id = widget.auth.user!.uid;
      print("3");
      Map<String, dynamic> chatMessageMap = {
        "sendBy": id,
        "message": chatInputController.text,
        'time': Timestamp.fromDate(DateTime.now()),
      };
      print("4");

      widget.chat.addMessage(widget.chatRoomId, chatMessageMap);
      print("5");

      setState(() {
        print("6");
        chatInputController.text = "";
        print("7");
      });
      print("8");
    }
    print("9");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          messagesList(),
          bottomTextBox(),
        ],
      )
      // StreamBuilder<QuerySnapshot>(
      //   stream: chats,
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (snapshot.hasError) {
      //       return const Text('Something went wrong');
      //     }
      //
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Text("Loading");
      //     }
      //
      //     return Stack(
      //       children: <Widget>[
      //         messagesList(),
      //         bottomTextBox(),
      //       ],
      //     );
      //   },
      // )
    );
  }

  AppBar getAppBar() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.lightBlue,
      flexibleSpace: FutureBuilder<Map<String, dynamic>>(
        future: chatRoom,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshotChatRoom) {
          if (snapshotChatRoom.hasData) {
            for (var i = 0; i < snapshotChatRoom.data!["users"].length; i++){
              if (snapshotChatRoom.data!["users"][i] != widget.auth.user!.uid) {
                userData = widget.database.getUserInfo(snapshotChatRoom.data!["users"][i]);
                break;
              }
            }
            return FutureBuilder<Map<String, dynamic>>(
              future: userData,
              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshotUser) {
                if (snapshotUser.hasData) {
                  // return AppBarChat(
                  //   name: snapshotUser.data!["name"],
                  //   avatar: snapshotUser.data!["avatar"],
                  // );
                  return SafeArea(
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
                          CircleAvatar(
                            backgroundImage: NetworkImage(snapshotUser.data!["avatar"]),
                            maxRadius: 20,
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(snapshotUser.data!["name"],style: const TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshotUser.hasError) {
                  return const Center(
                    child: Text('Error'),
                  );
                } else {
                  return Center(
                    child: Column(
                      children: const [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('Awaiting result...'),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          } else if (snapshotChatRoom.hasError) {
            return const Center(
              child: Text('Error'),
            );
          } else {
            return Center(
              child: Column(
                children: const [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget messagesList() {
    return FutureBuilder<Map<String, dynamic>>(
      future: chatRoom,
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshotChatRoom) {
        if (snapshotChatRoom.hasData) {
          for (var i = 0; i < snapshotChatRoom.data!["users"].length; i++){
            if (snapshotChatRoom.data!["users"][i] != widget.auth.user!.uid) {
              userData = widget.database.getUserInfo(snapshotChatRoom.data!["users"][i]);
              break;
            }
          }
          return FutureBuilder<Map<String, dynamic>>(
            future: userData,
            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshotUser) {
              if (snapshotUser.hasData) {
                return StreamBuilder<QuerySnapshot>(
                  stream: chats,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                    if (chatSnapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (chatSnapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }

                    return ListView.builder(
                      itemCount: chatSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        bool sendByMe = widget.auth.user!.uid == chatSnapshot.data!.docs[index]["sendBy"];
                        return MessageItem(
                          auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,
                          message: chatSnapshot.data!.docs[index]["message"],
                          senderMe: sendByMe,
                          photo: sendByMe ? null : snapshotUser.data!["avatar"],
                        );
                      },
                    );
                  },
                );
                // return StreamBuilder(
                //   stream: chats,
                //   builder: (context, snapshot) {
                //     return snapshot.hasData ? ListView.builder(
                //       itemCount: snapshot.data!.docs.length,
                //       itemBuilder: (context, index) {
                //         bool sendByMe = widget.auth.user!.uid == snapshot.data!.docs[index]["sendBy"];
                //         return MessageItem(
                //           auth: widget.auth, chat: widget.chat, storage: widget.storage, database: widget.database,
                //           message: snapshot.data!.docs[index]["message"],
                //           senderMe: sendByMe,
                //           photo: sendByMe ? null : snapshotUser.data!["avatar"],
                //         );
                //       },
                //     )
                //         : Container();
                //   },
                // );
              } else if (snapshotUser.hasError) {
                return const Center(
                  child: Text('Error'),
                );
              } else {
                return Center(
                  child: Column(
                    children: const [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        } else if (snapshotChatRoom.hasError) {
          return const Center(
            child: Text('Error'),
          );
        } else {
          return Center(
            child: Column(
              children: const [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Align bottomTextBox() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 10,bottom: 10,top: 10),
        height: 60,
        width: double.infinity,
        color: Colors.lightBlue,
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
            Expanded(
              child: TextField(
                controller: chatInputController,
                decoration: const InputDecoration(
                    hintText: "Write message...",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none
                ),
              ),
            ),
            const SizedBox(width: 15,),
            FloatingActionButton(
              onPressed: () {
                handleSendMessage();
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