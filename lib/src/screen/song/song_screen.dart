import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({super.key});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      context.read<SongProvider>().fetchSongs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SongProvider>(
        builder: (context, songProvider, child) {
          if (songProvider.status == DataFetchStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }else if (songProvider.status == DataFetchStatus.error || songProvider.songs.isEmpty) {
            return const Center(child: Text('No songs available'));
          } else {
            return ListView.builder(
              itemCount: songProvider.songs.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final song = songProvider.songs[index];
                return  SongCard(
                  index: index,
                  data: song,
                );
              },
            );
          }
        },
      ),
    );
  }
}
