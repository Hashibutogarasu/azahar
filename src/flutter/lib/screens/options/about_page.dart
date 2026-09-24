import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: Image.asset('assets/images/azahar_logo.png', width: 104, height: 104),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: Divider(height: 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(about.title, style: Theme.of(context).textTheme.titleMedium),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(about.description, style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Divider(height: 1),
          ),
          _AboutRow(
            title: about.contributors,
            description: about.contributorsDescription,
            onTap: () => launchUrl(Uri.parse(_contributorsLink), mode: LaunchMode.externalApplication),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Divider(height: 1)),
          _AboutRow(
            title: about.licenses,
            description: about.licensesDescription,
            onTap: () => showLicensePage(context: context),
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Divider(height: 1)),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              return _AboutRow(title: about.build, description: snapshot.data?.version ?? '');
            },
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Divider(height: 1)),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 16, left: 40, right: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: SvgPicture.asset('assets/icons/discord.svg', width: 24, height: 24),
                  onPressed: () =>
                      launchUrl(Uri.parse(_supportLink), mode: LaunchMode.externalApplication),
                ),
                IconButton(
                  icon: const Icon(Icons.language),
                  onPressed: () =>
                      launchUrl(Uri.parse(_websiteLink), mode: LaunchMode.externalApplication),
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/github.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      IconTheme.of(context).color ?? Theme.of(context).colorScheme.onSurface,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () =>
                      launchUrl(Uri.parse(_githubLink), mode: LaunchMode.externalApplication),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({required this.title, required this.description, this.onTap});

  final String title;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(description, style: Theme.of(context).textTheme.bodyMedium),
            ),
          ],
        ),
      ),
    );
  }
}
