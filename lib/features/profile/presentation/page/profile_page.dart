import 'package:flutter/material.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/widget/language_dialog.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/widget/profile_item.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profil)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ProfileItem(
              icon: 'assets/icons/person_light.png',
              title: context.l10n.settingsProfil,
            ),
            ProfileItem(
              ontap: () {
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => const AboutUs()));
              },
              icon: 'assets/icons/info_light.png',
              title: context.l10n.aboutUs,
            ),
            ProfileItem(
              ontap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const RuleScreen()));
              },
              icon: 'assets/icons/rule_light.png',
              title: context.l10n.rules,
            ),
            ProfileItem(
              ontap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const LanguageDialog();
                  },
                );
              },
              icon: 'assets/icons/globe_light.png',
              title: context.l10n.language,
            ),
          ],
        ),
      ),
    );
  }
}
