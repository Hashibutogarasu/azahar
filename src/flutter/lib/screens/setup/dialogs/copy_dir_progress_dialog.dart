import 'package:flutter/material.dart';

import '../../../i18n/translations.g.dart';
import '../../../models/copy_dir_progress.dart';

class CopyDirProgressDialog extends StatelessWidget {
  const CopyDirProgressDialog({super.key, required this.progressStream});

  final Stream<CopyDirProgress> progressStream;

  static Future<void> show(
    BuildContext context, {
    required Stream<CopyDirProgress> progressStream,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CopyDirProgressDialog(progressStream: progressStream),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(t.setup.userDirectory.movingData),
        content: StreamBuilder<CopyDirProgress>(
          stream: progressStream,
          builder: (context, snapshot) {
            final event = snapshot.data;
            final message = event == null
                ? ''
                : event.when(
                    searching: (directoryName) => directoryName,
                    copying: (filename, _, _) => filename,
                  );
            final progress = event?.mapOrNull(copying: (e) => e.progress) ?? 0;
            final max = event?.mapOrNull(copying: (e) => e.max) ?? 0;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, maxLines: 4, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: max == 0 ? null : progress / max,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
