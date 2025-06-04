import 'package:flutter/material.dart';
import 'package:new_kitap_chesmesi/app/app.dart';


class LangPopup extends StatelessWidget {
  const LangPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleSmall;
    return PopupMenuButton<String>(
      onSelected: (String languageCode) 
        =>App.of(context)?.setLocale(Locale(languageCode))
      ,
      icon: const Icon(Icons.language),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'en',
          child: Text(
            'English',
            style: textStyle,
          ),
        ),
        PopupMenuItem(
          value: 'ru',
          child: Text(
            'Rусский',
            style: textStyle,
          ),
        ),
        PopupMenuItem(
          value: 'tr',
          child: Text(
            'Turkçe',
            style: textStyle,
          ),
        ),
      ],
    );
  }
}
