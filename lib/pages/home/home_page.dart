import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:player_music/utils/app_color.dart';
import 'package:player_music/pages/albums/albuns_page.dart';
import 'package:player_music/pages/artists/artists_page.dart';
import 'package:player_music/pages/all_songs/list_music_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        backgroundColor: const Color(0xFFA02017),
        selectedItemColor: Colors.white,
        unselectedItemColor: AppColor.secondaryTextColor,
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note_rounded), label: 'Músicas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Artistas'),
          BottomNavigationBarItem(icon: Icon(Icons.album), label: 'Álbuns'),
        ],
      ),
      backgroundColor: AppColor.backgroundColor,
      body: IndexedStack(
        index: currentIndex,
        children: const [
          ListMusicPage(),
          ArtistsPage(),
          AlbunsPage(),
        ],
      ),
    );
  }
}
