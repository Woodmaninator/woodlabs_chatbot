import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:woodlabs_chatbot/components/woodlabs_button.dart';
import 'package:woodlabs_chatbot/components/woodlabs_icon_button.dart';
import 'package:woodlabs_chatbot/components/woodlabs_window.dart';
import 'package:woodlabs_chatbot/features/profiles/widgets/profile_banner.dart';
import 'package:woodlabs_chatbot/model/profile.dart';
import 'package:woodlabs_chatbot/provider/profiles_provider.dart';
import 'package:woodlabs_chatbot/provider/selected_profile_provider.dart';
import 'package:woodlabs_chatbot/router/routes.dart';
import 'package:woodlabs_chatbot/service/profile_service.dart';
import 'package:woodlabs_chatbot/utils/extensions/context_extensions.dart';

class ProfilesPage extends ConsumerStatefulWidget {
  const ProfilesPage({super.key});

  @override
  ConsumerState<ProfilesPage> createState() => _ProfilesPageState();
}

class _ProfilesPageState extends ConsumerState<ProfilesPage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var profiles = ref.watch(profilesProvider);
    var selectedProfile = ref.watch(selectedProfileProvider);

    var profileBanners = <Widget>[];
    for (int i = 0; i < profiles.length; i++) {
      var profile = profiles[i];
      profileBanners.add(
        Padding(
          padding: EdgeInsets.only(
            top: 16.0,
            bottom: 16,
            right: i == profiles.length - 1 ? 0 : 8.0,
          ),
          child: ProfileBanner(
            profile: profile,
            isSelected:
                selectedProfile != null && profile.id == selectedProfile.id,
            onSelect: () => _onSelectProfile(context, profile),
            onEdit: () => _onEditProfile(context, profile),
            onDelete: () => _onDeleteProfile(context, profile),
          ),
        ),
      );
    }

    return WoodlabsWindow(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  WoodlabsIconButton(
                    onPressed: () => _onAddProfile(context),
                    icon: TablerIcons.plus,
                    backgroundColor: context.customColors.attmayGreen,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
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
                  scrollDirection: Axis.horizontal,
                  controller: scrollController,
                  children: [
                    SizedBox(width: 8.0),
                    ...profileBanners,
                    SizedBox(width: 8.0),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 100.0),
        ],
      ),
    );
  }

  void _onAddProfile(BuildContext context) {
    NewProfileRoute().go(context);
  }

  void _onEditProfile(BuildContext context, Profile profile) {
    EditProfileRoute(profileId: profile.id).go(context);
  }

  void _onSelectProfile(BuildContext context, Profile profile) {
    setState(() {
      ProfileService.setSelectedProfile(ref, profile);
    });
  }

  void _onDeleteProfile(BuildContext context, Profile profile) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          actionsPadding: EdgeInsets.all(16.0),
          title: Text(
            context.localizations.profile_delete_title,
            style: context.customTextStyles.navigationBar,
          ),
          content: Text(
            context.localizations.profile_delete_text,
            style: context.customTextStyles.bodyRegular,
          ),
          backgroundColor: context.customColors.backgroundMedium,
          actions: [
            WoodlabsButton(
              icon: TablerIcons.trash,
              text: context.localizations.delete,
              isPrimary: false,
              isDisabled: false,
              width: 150,
              onPressed: () {
                ProfileService.deleteProfile(ref, profile.id);
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
