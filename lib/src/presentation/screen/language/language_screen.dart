import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../src.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.watch<LanguageProvider>().locale.languageCode;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n?.translate('language') ?? 'Language'),
      ),
      body: ListView(
        children: [
          for (final lang in AppConstants.languages)
            ListTile(
              leading:
                  lang['flag'].endsWith('.svg')
                      ? SvgHelper.fromSource(
                        path: lang['flag'],
                        width: 32,
                        height: 32,
                      )
                      : null,
              title: Text(lang['name']),
              trailing:
                  currentLocale == lang['code']
                      ? const Icon(Icons.check)
                      : null,
              onTap:
                  () => context.read<LanguageProvider>().setLocale(
                    Locale(lang['code']),
                  ),
            ),
        ],
      ),
    );
  }
}
