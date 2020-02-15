import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageSelect extends StatelessWidget {
  final File file;
  final String url;
  final VoidCallback onTap;

  const ImageSelect({Key key, this.file, this.url, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 216,
        width: 144,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            if (file == null && url == null)
              Center(
                child: Icon(
                  Icons.photo_camera,
                  size: 48,
                ),
              ),
            if (url != null)
              CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: url,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
                ),
              ),
            if (file != null)
              Image.file(
                file,
                fit: BoxFit.fill,
              ),
            Positioned(
              bottom: 5,
              right: 5,
              child: Icon(
                Icons.photo_camera,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
