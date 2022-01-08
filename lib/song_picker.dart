
import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:filter_app/audio_player.dart';
import 'package:flutter/material.dart';

class SongPicker extends StatefulWidget {
  const SongPicker({Key? key}) : super(key: key);

  @override
  _SongPickerState createState() => _SongPickerState();
}

class _SongPickerState extends State<SongPicker> {
  final FileManagerController _fileManagerController = FileManagerController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: FileManager(
        controller: _fileManagerController,
        builder: (context, snapshot) {
        final List<FileSystemEntity> entities = snapshot;
          return ListView.builder(
            itemCount: entities.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: FileManager.isFile(entities[index])
                      ? const Icon(Icons.feed_outlined)
                      : const Icon(Icons.folder),
                  title: Text(FileManager.basename(entities[index])),
                  onTap: () {
                    if (FileManager.isDirectory(entities[index])) {
                        _fileManagerController.openDirectory(entities[index]);
                      } else {
                          if (entities[index].path.contains(".mp3")) {
                            var player = Player();
                            player.play(entities[index].path);
                            Navigator.of(context).pop();
                          }
                      }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}