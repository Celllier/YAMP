
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yamp/screens/navigation.dart';
import 'common.dart';

import '../data/song.dart';
import '../data/playlist.dart';

class PlaylistListingPage extends StatelessWidget {

  const PlaylistListingPage({super.key, required this.songModel});

  final SongModel songModel;

  void _showPlaylistCreateModal(BuildContext context) {
    showModalBottomSheet(
      context: context, 
      isDismissible: true,
      showDragHandle: true,
      builder: (context) => _PlaylistNameForm()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "Your Playlists",
            style: TextTheme.of(context).headlineMedium,
          ),
      
          Consumer<PlaylistModel>(
            builder: (context, playlistModel, child) => ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                for (final playlist in playlistModel.playlists) 
                  _buildPlayListTile(playlist)
              ],
            ),
          ),
      
          FloatingActionButton(
            onPressed: () => _showPlaylistCreateModal(context),
            child: Icon(Icons.add),
          )
        ],
      ),
    );
  }



  Widget _buildPlayListTile(Playlist playlist) {
    return ListTile(
      leading: Text(playlist.name),
    );
  }
}






class _PlaylistNameForm extends StatefulWidget {

  @override
  State<_PlaylistNameForm> createState() => _PlaylistNameFormState();
}


class _PlaylistNameFormState extends State<_PlaylistNameForm> {

  final _formController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? formErrorText;

  static String emptyNameError = 'Name cannot be empty';

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    return formKey.currentState!.validate();
  }

  void _submitForm(BuildContext context, PlaylistModel playlistModel) {
    if (!_isFormValid()) {
      return;
    }

    //playlistModel.asdf
    Navigator.pop(context);
  }

  String? _validateInput(String? input) {
    return (input != null && input.trim().isNotEmpty) 
                ? null 
                : _PlaylistNameFormState.emptyNameError; 
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            spacing: 20,
            children: [
              Text(
                'Create a Playlist',
                style: TextTheme.of(context).titleLarge,
              ),

              TextFormField(
                controller: _formController,
                validator: _validateInput,
                forceErrorText: formErrorText,
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.abc),
                  labelText: 'Name your playlist (*)',
                  hintText: 'My Playlist...', 
                ),
              ),

              Consumer<PlaylistModel>(
                builder: (context, playlistModel, child) => 
                  FloatingActionButton(
                    onPressed: () => _submitForm(context, playlistModel),
                    child: const Text('Submit'),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}