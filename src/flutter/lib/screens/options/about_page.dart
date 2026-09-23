import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../i18n/translations.g.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const _contributorsLink = 'https://github.com/azahar-emu/azahar/graphs/contributors';
  static const _supportLink = 'https://discord.gg/4ZjMpAp3M6';
  static const _websiteLink = 'https://azahar-emu.org/';
  static const _githubLink = 'https://github.com/azahar-emu/azahar';

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final about = t.about;
    return Scaffold(
      appBar: AppBar(title: Text(about.title)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(about.title, style: Theme.of(context).textTheme.titleMedium),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(about.description),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(about.contributors),
            subtitle: Text(about.contributorsDescription),
            onTap: () => launchUrl(Uri.parse(_contributorsLink), mode: LaunchMode.externalApplication),
          ),
          const Divider(),
          ListTile(
            title: Text(about.licenses),
            subtitle: Text(about.licensesDescription),
            onTap: () => showLicensePage(context: context),
          ),
          const Divider(),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              return ListTile(
                title: Text(about.build),
                subtitle: Text(snapshot.data?.version ?? ''),
              );
            },
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.forum_outlined),
                onPressed: () => launchUrl(Uri.parse(_supportLink), mode: LaunchMode.externalApplication),
              ),
              IconButton(
                icon: const Icon(Icons.public),
                onPressed: () => launchUrl(Uri.parse(_websiteLink), mode: LaunchMode.externalApplication),
              ),
              IconButton(
                icon: const Icon(Icons.code),
                onPressed: () => launchUrl(Uri.parse(_githubLink), mode: LaunchMode.externalApplication),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
