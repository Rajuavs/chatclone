import 'package:chatclone/features/auth/controller/auth_controller.dart';
import 'package:chatclone/features/call/screens/call_pickup_screen.dart';
import 'package:chatclone/models/user_model.dart';
import 'package:chatclone/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/loader.dart';
import '../../call/controller/call_controller.dart';

import '../widgets/bottom_chat_field.dart';
import '../widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobile-chat-screen';
  const MobileChatScreen(
      {super.key,
      required this.name,
      required this.uid,
      required this.isGroupChat,
      required this.profilePic});

  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;
  void makeCall(WidgetRef ref, BuildContext context) {
    ref.read(callControllerProvider).makeCall(
          context,
          name,
          uid,
          profilePic,
          isGroupChat,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("i'm in mobile chat screens");
    return CallPickupScreen(
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: isGroupChat
              ? Text(name)
              : StreamBuilder<UserModel>(
                  stream: ref.read(authControllerProvider).userDataById(uid),
                  builder: (context, snapshot) {
                    var data = snapshot.data;
                    print(
                        "streamData ${data?.isOnline} ${data?.phoneNumber} ${data?.name} ${data?.uid}");

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    }
                    return Column(children: [
                      Text(name),
                      Text(
                        (snapshot.data?.isOnline ?? false)
                            ? 'online'
                            : 'offline',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ]);
                  }),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () => makeCall(ref, context),
              icon: const Icon(Icons.video_call),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: ChatList(recieverUserId: uid, isGroupChat: isGroupChat)),
            BottomChatField(recieverUserId: uid, isGroupChat: isGroupChat),
          ],
        ),
      ),
    );
  }
}
