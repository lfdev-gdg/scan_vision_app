import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scan_vision_app/core/common/routes.dart';
import 'package:scan_vision_app/home/widgets/livro_tile.dart';
import 'package:scan_vision_app/models/livro_model.dart';

class FavoritosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Livro>>(
      stream: Firestore.instance
          .collection("livros")
          .where("favorito", isEqualTo: true)
          .snapshots()
          .map((event) =>
              event.documents.map((e) => Livro.fromSnapshot(e)).toList()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.favorite_border,
                  size: 96,
                ),
                Text(
                  "Você ainda não tem livro favorito!",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            );
          }

          return GridView.builder(
            itemCount: snapshot.data.length,
            padding: const EdgeInsets.all(8.0),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
            ),
            itemBuilder: (context, index) {
              return LivroTile(
                capaUrl: snapshot.data[index].capaUrl,
                favorito: snapshot.data[index].favorito ?? false,
                onDoubleTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.cadastroLivro,
                    arguments: snapshot.data[index],
                  );
                },
                onFavoriteTap: () {
                  Firestore.instance
                      .collection("livros")
                      .document(snapshot.data[index].key)
                      .updateData({
                    "favorito": !(snapshot.data[index].favorito ?? false)
                  });
                },
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.paginas,
                    arguments: snapshot.data[index],
                  );
                },
              );
            },
          );
        }

        return Center(
          child: Text(
            "Aconteceu um erro na consulta ${snapshot.error.toString()}",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }
}
