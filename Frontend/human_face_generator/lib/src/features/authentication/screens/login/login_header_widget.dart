import 'package:flutter/material.dart';
import 'package:human_face_generator/src/constants/image_strings.dart';
import 'package:human_face_generator/src/constants/text_strings.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Image(
            image: const AssetImage(tOnBoardingImage3),
            height: size.height * 0.2),
        const SizedBox(
          height: 10,
        ),
        Text(tLoginTitle, style: Theme.of(context).textTheme.displayLarge),
        Text(tLoginSubTitle, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
