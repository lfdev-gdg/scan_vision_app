import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scan_vision_app/core/common/routes.dart';
import 'package:scan_vision_app/models/livro_model.dart';
import 'package:scan_vision_app/models/pagina_model.dart';
import 'package:scan_vision_app/utils/firebase_storage_utils.dart';

class PaginasView extends StatefulWidget {
  final Livro livro;

  const PaginasView({Key key, this.livro}) : super(key: key);

  @override
  _PaginasViewState createState() => _PaginasViewState();
}

class _PaginasViewState extends State<PaginasView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Páginas'),
      ),
      body: StreamBuilder<List<Pagina>>(
          stream: Firestore.instance
              .collection("livros/${widget.livro.key}/paginas")
              .orderBy("pagina")
              .snapshots()
              .map((event) =>
                  event.documents.map((e) => Pagina.fromSnapshot(e)).toList()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.library_books,
                        size: 96,
                      ),
                      Text(
                        "Nenhuma página cadastrada!",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.pageview),
                  title: Text("Página nº ${snapshot.data[index].pagina}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () =>
                            _editTap(snapshot.data[index], widget.livro.key),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteTap(snapshot.data[index]),
                      ),
                    ],
                  ),
                  onTap: () => _tileTap(snapshot.data[index]),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(
            context,
            Routes.cadastroPagina,
            arguments: {
              "livroKey": widget.livro.key,
              "pagina": Pagina(),
            },
          );
        },
      ),
    );
  }

  void _deleteTap(Pagina pagina) async {
    await Firestore.instance
        .document('livros/${widget.livro.key}/paginas/${pagina.key}')
        .delete();

    _scaffoldKey.currentState
        .showSnackBar(SnackBar(
          content: Text("Página excluída com sucesso!"),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
              label: "Desfazer",
              onPressed: () async {
                await Firestore.instance
                    .collection('livros/${widget.livro.key}/paginas')
                    .add(pagina.toMap());
              }),
        ))
        .closed
        .then((reason) async {
      if (reason != SnackBarClosedReason.action) {
        await FirebaseStorageUtils.deleteFile(pagina.paginaUrl);
      }
    });
  }

  void _editTap(Pagina pagina, String livroKey) {
    Navigator.pushNamed(
      context,
      Routes.cadastroPagina,
      arguments: {
        "livroKey": livroKey,
        "pagina": pagina,
      },
    );
  }

  void _tileTap(Pagina pagina) {
    Navigator.pushNamed(
      context,
      Routes.visualizarPagina,
      arguments: pagina,
    );
  }
}
