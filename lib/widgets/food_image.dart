import 'package:flutter/material.dart';
import '../theme.dart';

class FoodImage extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final BoxFit fit;
  const FoodImage(this.url,
      {super.key, this.height, this.width, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      height: height,
      width: width,
      color: AppColors.paleYellow,
      alignment: Alignment.center,
      child: const Icon(Icons.restaurant, color: AppColors.primary, size: 34),
    );
    if (url.isEmpty || url.endsWith('/images/')) return placeholder;
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (_, __, ___) => placeholder,
      );
    }
    return Image.network(
      url,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (_, __, ___) => placeholder,
      loadingBuilder: (c, child, p) => p == null ? child : placeholder,
    );
  }
}
