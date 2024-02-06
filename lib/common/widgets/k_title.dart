import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';

class KTitleWidget extends StatelessWidget {
  const KTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          Images.icon,
          height: 35,
        ),
        const Flexible(
          child: Text(
            'Elisir_club',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
