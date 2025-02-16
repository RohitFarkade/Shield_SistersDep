import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CommonLogo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.network("https://www.shieldofsisters.org/wp-content/uploads/2024/07/shieldofsisters1200R-200x175.png",width: 100,),
        "Shield Sisters".text.xl2.italic.make(),
        "Shielding Sisters on Every Path".text.light.white.wider.lg.make(),
      ],
    );
  }
}