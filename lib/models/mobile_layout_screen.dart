import 'dart:io';

import 'package:chatclone/util/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/controller/auth_controller.dart';
import '../features/chat/widgets/contacts_list.dart';
import '../features/group/screens/create_group_screen.dart';
import '../features/select_contacts/screens/select_contacts_screen.dart';
import '../util/colors.dart';
import '../util/utils.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'common/utils/colors.dart';
// import 'common/utils/utils.dart';
// import 'features/auth/controller/auth_controller.dart';
// import 'features/chat/widgets/contacts_list.dart';
// import 'features/group/screens/create_group_screen.dart';
// import 'features/select_contacts/screens/select_contacts_screen.dart';
// import 'features/status/screens/confirm_status_screen.dart';
// import 'features/status/screens/status_contacts_screen.dart';
// import 'package:whatsapp_ui/common/utils/colors.dart';
// import 'package:whatsapp_ui/common/utils/utils.dart';
// import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
// import 'package:whatsapp_ui/features/group/screens/create_group_screen.dart';
// import 'package:whatsapp_ui/features/select_contacts/screens/select_contacts_screen.dart';
// import 'package:whatsapp_ui/features/chat/widgets/contacts_list.dart';
// import 'package:whatsapp_ui/features/status/screens/confirm_status_screen.dart';
// import 'package:whatsapp_ui/features/status/screens/status_contacts_screen.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;
  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("didchangeapplife cycle state ${state.name}");
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: const Text(
            appName,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text(
                    'Create Group',
                  ),
                  onTap: () => Future(
                    () => Navigator.pushNamed(
                        context, CreateGroupScreen.routeName),
                  ),
                )
              ],
            ),
          ],
          bottom: TabBar(
            controller: tabBarController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(
                text: 'CHATS',
              ),
              // Tab(
              //   text: 'STATUS',
              // ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: Container(
          child: TabBarView(
            controller: tabBarController,
            children: const [
              ContactsList(),
              // StatusContactsScreen(),
              Text('Calls')
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (tabBarController.index == 0) {
              Navigator.pushNamed(context, SelectContactsScreen.routeName);
            } else {
              // File? pickedImage = await pickImageFromGallery(context);
              // if (pickedImage != null) {
              //   Navigator.pushNamed(
              //     context,
              //     ConfirmStatusScreen.routeName,
              //     arguments: pickedImage,
              //   );
              // }
            }
          },
          backgroundColor: tabColor,
          child: const Icon(
            Icons.comment,
            color: appBarColor,
          ),
        ),
      ),
    );
  }
}
