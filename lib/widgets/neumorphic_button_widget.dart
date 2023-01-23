import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:player_music/constants/app_color.dart';

class NeumorphicButtonCustom extends StatelessWidget {
  final Icon icon;
  final Function function;
  final double size;
  final Color color;
  const NeumorphicButtonCustom({
    Key? key,
    required this.icon,
    required this.function,
    this.size = 7.0,
    this.color = Colors.black54,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      padding: const EdgeInsets.all(3),
      style: const NeumorphicStyle(
          intensity: 0,
          color: AppColor.backgroundColor,
          depth: -2,
          shadowDarkColor: Colors.white38,
          shadowLightColor: Color.fromARGB(179, 255, 255, 255),
          oppositeShadowLightSource: true,
          boxShape: NeumorphicBoxShape.circle()),
      child: Neumorphic(
        style: const NeumorphicStyle(
            depth: 20,
            color: Color.fromARGB(29, 237, 237, 238),
            shadowDarkColor: Colors.black,
            shadowLightColor: Colors.white54,
            oppositeShadowLightSource: false,
            boxShape: NeumorphicBoxShape.circle()),
        child: NeumorphicRadio(
            onChanged: (dynamic a) => function(),
            padding: EdgeInsets.all(size),
            style: NeumorphicRadioStyle(
              boxShape: const NeumorphicBoxShape.circle(),
              intensity: 0,
              shape: NeumorphicShape.convex,
              selectedColor: color,
              unselectedColor: color,
            ),
            child: icon),
      ),
    );
  }
}
