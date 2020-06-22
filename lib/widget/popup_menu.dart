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
  const Choice({this.title, this.icon, this.menuItem, this.onNavigate});

  final String title;
  final IconData icon;
  final MenuItemKey menuItem;
  final Function() onNavigate;
}

const List<Choice> choices = const <Choice>[
  const Choice(
      title: 'Generate',
      icon: Icons.directions_car,
      menuItem: MenuItemKey.GENERATE),
  const Choice(
      title: 'Settings',
      icon: Icons.directions_bike,
      menuItem: MenuItemKey.SETTINGS),
  const Choice(
      title: 'Saved Sequences',
      icon: Icons.directions_boat,
      menuItem: MenuItemKey.SAVED_SEQUENCES),
  const Choice(
      title: 'Saved Videos',
      icon: Icons.directions_bus,
      menuItem: MenuItemKey.SAVED_VIDEO),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.headline4;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}
