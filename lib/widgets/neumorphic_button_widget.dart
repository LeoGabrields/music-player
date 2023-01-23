// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeumorphicButtonCustom extends StatelessWidget {
  final Icon icon;
  final Function function;
  final Color color;
  final double width;
  final double heigth;

  const NeumorphicButtonCustom({
    Key? key,
    required this.icon,
    required this.function,
    this.color = const Color.fromARGB(255, 80, 80, 83),
    required this.width,
    required this.heigth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      width: width,
      height: heigth,
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(255, 52, 52, 58),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(38, 255, 255, 255),
            blurRadius: 30,
            offset: Offset(-8, -8),
          ),
          BoxShadow(
            color: Color.fromARGB(164, 0, 0, 0),
            blurRadius: 23,
            offset: Offset(10, 9),
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(60),
        onTap: () => function(),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                const Color(0xff202026),
              ],
            ),
          ),
          child: icon,
        ),
      ),
    );
  }
}
