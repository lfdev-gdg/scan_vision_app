
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LivroTile extends StatelessWidget {
  final VoidCallback onDoubleTap;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final String capaUrl;
  final bool favorito;

  const LivroTile({
    Key key,
    this.onDoubleTap,
    this.onTap,
    this.onFavoriteTap,
    this.capaUrl,
    this.favorito,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onDoubleTap,
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(
              fit: BoxFit.scaleDown,
              imageUrl: capaUrl,
              placeholder: (context, url) => Container(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 4,
              bottom: 4,
              child: IconButton(
                icon: Icon(
                  favorito ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                  size: 32,
                ),
                onPressed: onFavoriteTap,
              ),
            )
          ],
        ),
      ),
    );
  }
}
