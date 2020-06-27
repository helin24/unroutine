import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unroutine/database.dart';
import 'package:unroutine/model/sequence_model.dart';
import 'package:unroutine/widget/display_sequence.dart';
import 'package:unroutine/widget/popup_menu.dart';

class SavedVideos extends StatefulWidget {
  @override
  _SavedVideosState createState() => _SavedVideosState();
}

class _SavedVideosState extends State<SavedVideos> {
  List<FileSystemEntity> _files;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _listofFiles();
  }

  void _listofFiles() async {
    String directory = (await getExternalStorageDirectory()).path;
    setState(() {
      _files = Directory(directory).listSync();
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved videos'),
        actions: <Widget>[
          PopupMenu('Saved videos', MenuItemKey.SAVED_VIDEO),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _files.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(_files[index].path);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
