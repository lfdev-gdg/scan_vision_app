import 'package:cloud_firestore/cloud_firestore.dart';

class Pagina {
  String key;
  int pagina;
  String paginaUrl;

  Pagina({
    this.key,
    this.pagina,
    this.paginaUrl,
  });

  factory Pagina.fromSnapshot(DocumentSnapshot snapshot) => Pagina(
        key: snapshot.documentID,
        pagina: snapshot["pagina"] == null ? null : snapshot["pagina"],
        paginaUrl: snapshot["paginaUrl"] == null ? null : snapshot["paginaUrl"],
      );

  Map<String, dynamic> toMap() => {
        "pagina": pagina == null ? null : pagina,
        "paginaUrl": paginaUrl == null ? null : paginaUrl,
      };
}
