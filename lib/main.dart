import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:player_music/utils/request_permission.dart';
import 'package:player_music/controller/audio_controller.dart';
import 'package:player_music/pages/home_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RequestPermission.call();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AudioController(),
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          textTheme: TextTheme(          
            bodyText1: GoogleFonts.urbanist(
              color: Colors.white,
            ),
            bodyText2: GoogleFonts.urbanist(
              color: Colors.white,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}
