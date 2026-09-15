

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:yamp/data/metadata.dart';
import 'package:yamp/data/song.dart';
import 'package:yamp/data/songFileReader.dart';

class EditButton extends StatelessWidget {

  const EditButton({super.key, required this.song});

  final Song song;

  void _showEditDialog(BuildContext context, SongModel songModel) async {
    Metadata? metadata = await showDialog<Metadata>(
      context: context,
      useSafeArea: true,
      builder: (context) => Dialog(
        child: _EditForm(song: song)
      ) 
    );

    if (metadata != null) {
      SongFileReader.updateSongMetadata(song, metadata);
      songModel.saveSong(song);
    }
  }

  @override
  Widget build(BuildContext context) {  
    return IconButton(
      onPressed: () => _showEditDialog(context, context.read<SongModel>()), 
      icon: Icon(Icons.edit)
    );
  }
}


class _EditForm extends StatefulWidget {

  const _EditForm({required this.song});

  final Song song;

  @override
  State<_EditForm> createState() => _EditFormState(song: song);
}


class _EditFormState extends State<_EditForm> {

  _EditFormState({required this.song}) {
    titleController.text = song.title;
    artistController.text = song.artist;  
  }

  final Song song;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController artistController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  String? _nonNullValidator(String? input) {
    return (input != null && input.trim().isNotEmpty) ? input : null; 
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            TextFormField(
              controller: titleController,
              validator: _nonNullValidator,
              decoration: InputDecoration(
                hintText: "Title"
              ),
            ),

            TextFormField(
              controller: artistController,
              validator: _nonNullValidator,
              decoration: InputDecoration(
                hintText: "Artist"
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    Metadata metadata = Metadata(
                      title: titleController.text,
                      artist: artistController.text,
                    );
                    Navigator.pop(context, metadata);
                  } 
                ),
                
              ],
            )
          ],
        )
    );
  }
}