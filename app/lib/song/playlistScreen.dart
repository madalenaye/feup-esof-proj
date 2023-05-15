import 'dart:io';
import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:matchify/appBar/appBar.dart';
import 'package:matchify/appBar/infoScreen.dart';
import 'package:matchify/song/playlist.dart';
import '../constants.dart';

class PlaylistScreen extends StatefulWidget {
  final Playlist playlist;

  const PlaylistScreen({required this.playlist});

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late Color bgColor;
  late Color textColor;
  Future<void> export() async {
    List<List<dynamic>> rows = [];

    // add header row
    rows.add(['Track Name', 'Artist Name', 'Genre', 'Preview URL', 'Image URL']);

    // add data rows
    for (var song in widget.playlist.songs) {
      rows.add([song.trackName, song.artistName, song.genre, song.previewUrl, song.imageUrl]);
    }
    String csv = const ListToCsvConverter().convert(rows);

    String dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    print("dir $dir");
    String file = "$dir";
    String playlistName= widget.playlist.name;
    File f = File("$file/$playlistName.csv");

    f.writeAsString(csv);
  }
  @override
  void initState() {
    super.initState();
    updateColors();
    
  }

  void updateColors() {
    setState(() {
      bgColor = DarkMode.isDarkModeEnabled
          ? Color.fromRGBO(59, 59, 59, 1)
          : Colors.white;

      textColor = DarkMode.isDarkModeEnabled
          ? //Color.fromRGBO(68, 47, 100, 1)
          Colors.white
          : Color.fromRGBO(48, 21, 81, 1);
    });
  }

  Widget showSongs() {
    return ListView(
      key: Key("playlist songs"),
      shrinkWrap: true,
      children: [
        SizedBox(
          height: 600,
          child: ListView.builder(
            itemCount: widget.playlist.songs.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Image.network(
                        widget.playlist.songs[index].imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.playlist.songs[index].trackName,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.playlist.songs[index].artistName,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      color: textColor,
                      onPressed: () {
                        setState(() {
                          if (widget.playlist.songs[index].isPlaying) {
                            widget.playlist.songs[index].pause();
                          } else {
                            widget.playlist.songs[index].play();
                          }
                        });
                      },
                      icon: Icon(widget.playlist.songs[index].isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key("playlist page"),

      drawer: Info(),
      appBar: appBar(),
      body:Container(
  color: bgColor,
  child: Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 50),
        Text(
          widget.playlist.name,
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 64),
        IconButton(
          onPressed: () async {
            export();
          },
          icon: Icon(Icons.file_download),
        ),
        showSongs(),
      ],
    ),
  ),
)

    );
  }
}
