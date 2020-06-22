import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum MenuItemKey {
  GENERATE,
  SETTINGS,
  SAVED_SEQUENCES,
  SAVED_VIDEO,
}

class PopupMenu extends StatelessWidget {
  PopupMenu(this.title, this.menuItemKey);

  final String title;
  final MenuItemKey menuItemKey;

  void _onSelected(MenuItemKey menuItemKey, BuildContext context) {
    switch(menuItemKey) {
      case MenuItemKey.GENERATE:
        Navigator.pushNamed(context, '/generate');
        break;
      case MenuItemKey.SETTINGS:
        Navigator.pushNamed(context, '/settings');
        break;
      case MenuItemKey.SAVED_SEQUENCES:
        Navigator.pushNamed(context, '/saved_sequences');
        break;
      case MenuItemKey.SAVED_VIDEO:
        Navigator.pushNamed(context, '/saved_videos');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Choice>(
      onSelected: (Choice choice) => _onSelected(choice.menuItem, context),
      itemBuilder: (BuildContext context) {
        return choices
            .where((element) => element.menuItem != menuItemKey)
            .map((Choice choice) {
          return PopupMenuItem<Choice>(
            value: choice,
            child: Text(choice.title),
          );
        }).toList();
      },
    );
  }
}

class Choice {
  const Choice({this.title, this.menuItem, this.onNavigate});

  final String title;
  final MenuItemKey menuItem;
  final Function() onNavigate;
}

const List<Choice> choices = const <Choice>[
  const Choice(
      title: 'Generate',
      menuItem: MenuItemKey.GENERATE),
  const Choice(
      title: 'Settings',
      menuItem: MenuItemKey.SETTINGS),
  const Choice(
      title: 'Saved Sequences',
      menuItem: MenuItemKey.SAVED_SEQUENCES),
  const Choice(
      title: 'Saved Videos',
      menuItem: MenuItemKey.SAVED_VIDEO),
];
