import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../repository/audio_repository.dart';
import 'package:just_audio/just_audio.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AudioRepository audioRepository = AudioRepository();
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    audioRepository.requestPermission();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  setAudio(String uri) async {
    await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri)));
    await audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<SongModel>>(
        future: audioRepository.querySongs(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('Nada Encontrado!'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var audio = snapshot.data![index];
              return ListTile(
                onTap: () => setAudio(audio.uri!),
                leading: Text(
                  '${index + 1}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                title: Text(
                  audio.displayNameWOExt,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                subtitle: Text(
                  audio.artist ?? '',
                  style: const TextStyle(fontSize: 13),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
