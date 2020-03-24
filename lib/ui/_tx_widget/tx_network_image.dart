import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TXNetworkImage extends StatelessWidget {
  final String imageUrl;
  final String placeholderImage;
  final BoxShape shape;
  final double width;
  final double height;
  final BoxFit boxFitImage;
  final BoxFit boxFitErrorImage;
  final BoxFit boxFitPlaceholderImage;

  TXNetworkImage({
    this.shape = BoxShape.rectangle,
    @required this.imageUrl,
    @required this.placeholderImage,
    this.width = 80,
    this.height = 60,
    this.boxFitImage = BoxFit.contain,
    this.boxFitErrorImage = BoxFit.contain,
    this.boxFitPlaceholderImage = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(shape: shape),
      child: CachedNetworkImage(
        imageUrl: imageUrl ?? "",
        imageBuilder: (context, imageProvider) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                shape: shape,
                image:
                    DecorationImage(image: imageProvider, fit: boxFitImage)),
          );
        },
        placeholder: (context, url) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(shape: shape),
            child: Image.asset(
              placeholderImage,
              fit: boxFitPlaceholderImage,
            ),
          );
        },
        errorWidget: (context, url, error) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(shape: shape),
            child: Image.asset(
              placeholderImage,
              fit: boxFitErrorImage,
            ),
          );
        },
      ),
    );
  }
}
