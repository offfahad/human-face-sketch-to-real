import 'package:flutter/material.dart';
import 'package:human_face_generator/src/constants/image_strings.dart';
import 'package:human_face_generator/src/constants/text_strings.dart';

class SignUpHeaderWidget extends StatelessWidget {
  const SignUpHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10,),
        Image(
            image: const AssetImage(tOnBoardingImage3),
            height: size.height * 0.1),
        const SizedBox(height: 10,),
        Text(tSignUpTitle, style: Theme.of(context).textTheme.displayLarge),
        Text(tSignUpSubTitle, style: Theme.of(context).textTheme.bodyLarge),
        //const SizedBox(height: 10,),
      ],
    );
  }
}