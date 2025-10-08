import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/components/woodlabs_button.dart';
import 'package:woodlabs_chatbot/components/woodlabs_icon_button.dart';
import 'package:woodlabs_chatbot/components/woodlabs_text_input.dart';
import 'package:woodlabs_chatbot/components/woodlabs_window.dart';
import 'package:woodlabs_chatbot/features/bannedUsers/widgets/banned_user_banner.dart';
import 'package:woodlabs_chatbot/provider/banned_users_provider.dart';
import 'package:woodlabs_chatbot/service/banned_user_service.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class BannedUsersPage extends ConsumerStatefulWidget {
  const BannedUsersPage({super.key});

  @override
  ConsumerState<BannedUsersPage> createState() => _BannedUsersPageState();
}

class _BannedUsersPageState extends ConsumerState<BannedUsersPage> {
  final TextEditingController newBanController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    newBanController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var bannedUsers = ref.watch(bannedUsersProvider);

    bannedUsers.sort((a, b) => a.compareTo(b));

    var bannedUserBanners = <Widget>[];
    for (int i = 0; i < bannedUsers.length; i++) {
      var bannedUser = bannedUsers.elementAt(i);
      bannedUserBanners.add(
        Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16,
            bottom: i == bannedUsers.length - 1 ? 0 : 8.0,
          ),
          child: BannedUserBanner(
            bannedUser: bannedUser,
            onDelete: () => {_onBannedUserDelete(context, bannedUser)},
          ),
        ),
      );
    }

    return WoodlabsWindow(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: WoodlabsTextInput(
                  label: context.localizations.banned_user_add_user,
                  hintText: "",
                  controller: newBanController,
                ),
              ),
              const SizedBox(width: 16.0),
              WoodlabsIconButton(
                onPressed: () => _onAddBannedUser(context),
                icon: TablerIcons.gavel,
                backgroundColor: newBanController.text.trim().isEmpty
                    ? context.customColors.attmayGreenLight
                    : context.customColors.attmayGreen,
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.customColors.backgroundLight,
                borderRadius: BorderRadius.circular(16.0),
                border: BoxBorder.fromBorderSide(
                  BorderSide(
                    color: context.customColors.attmayGreen,
                    width: 1.0,
                  ),
                ),
              ),
              child: Scrollbar(
                controller: scrollController,
                child: ListView(
                  controller: scrollController,
                  children: [
                    SizedBox(height: 8.0),
                    ...bannedUserBanners,
                    SizedBox(height: 8.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    newBanController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _onAddBannedUser(BuildContext context) {
    var username = newBanController.text.trim();

    if (username.isEmpty) {
      return;
    }

    BannedUserService.addBannedUser(ref, username);
  }

  void _onBannedUserDelete(BuildContext context, String bannedUser) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: EdgeInsets.all(16.0),
          title: Text(
            context.localizations.banned_user_delete_title,
            style: context.customTextStyles.navigationBar,
          ),
          content: Text(
            context.localizations.banned_user_delete_text,
            style: context.customTextStyles.bodyRegular,
          ),
          backgroundColor: context.customColors.backgroundMedium,
          actions: [
            WoodlabsButton(
              icon: TablerIcons.heart,
              text: context.localizations.banned_user_unban,
              isPrimary: false,
              isDisabled: false,
              width: 150,
              onPressed: () {
                BannedUserService.removeBannedUser(ref, bannedUser);
                Navigator.of(context).pop();
              },
            ),
            WoodlabsButton(
              icon: TablerIcons.x,
              text: context.localizations.cancel,
              isPrimary: true,
              isDisabled: false,
              width: 150,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
