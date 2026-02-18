import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSvgWedget extends StatelessWidget {
  const CustomSvgWedget({
    super.key,
    required this.path,
    this.withFilter = true,
  });
  const CustomSvgWedget.withOutFilter({
    super.key,
    required this.path,
}) :  this.withFilter = false;

  final String path;
  final bool withFilter;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,

      colorFilter:withFilter==true? ColorFilter.mode(
        Theme.of(context).colorScheme.secondary,
        BlendMode.srcIn,
      ) : null,
    );
  }
}
