import 'package:cloud_firestore/cloud_firestore.dart';

class Livro {
  String key;
  String titulo;
  String autor;
  int anoEdicao;
  String idioma;
  int numeroEdicao;
  int numeroPaginas;
  String nomeEditora;
  String pais;
  String capaUrl;
  bool favorito;

  Livro({
    this.key,
    this.titulo,
    this.autor,
    this.anoEdicao,
    this.idioma,
    this.numeroEdicao,
    this.numeroPaginas,
    this.nomeEditora,
    this.pais,
    this.capaUrl,
    this.favorito,
  });

  factory Livro.fromSnapshot(DocumentSnapshot snapshot) => Livro(
        key: snapshot.documentID,
        titulo: snapshot["titulo"] == null ? null : snapshot["titulo"],
        autor: snapshot["autor"] == null ? null : snapshot["autor"],
        anoEdicao: snapshot["anoEdicao"] == null ? null : snapshot["anoEdicao"],
        idioma: snapshot["idioma"] == null ? null : snapshot["idioma"],
        numeroEdicao:
            snapshot["numeroEdicao"] == null ? null : snapshot["numeroEdicao"],
        numeroPaginas: snapshot["numeroPaginas"] == null
            ? null
            : snapshot["numeroPaginas"],
        nomeEditora:
            snapshot["nomeEditora"] == null ? null : snapshot["nomeEditora"],
        pais: snapshot["pais"] == null ? null : snapshot["pais"],
        capaUrl: snapshot["capaUrl"] == null ? null : snapshot["capaUrl"],
        favorito: snapshot["favorito"] == null ? null : snapshot["favorito"],
      );

  Map<String, dynamic> toMap() => {
        "titulo": titulo == null ? null : titulo,
        "autor": autor == null ? null : autor,
        "anoEdicao": anoEdicao,
        "idioma": idioma == null ? null : idioma,
        "numeroEdicao": numeroEdicao,
        "numeroPaginas": numeroPaginas,
        "nomeEditora": nomeEditora == null ? null : nomeEditora,
        "pais": pais == null ? null : pais,
        "capaUrl": capaUrl == null ? null : capaUrl,
        "favorito": favorito == null ? null : favorito,
      };
}
