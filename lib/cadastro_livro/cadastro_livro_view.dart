import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan_vision_app/core/common/routes.dart';
import 'package:scan_vision_app/core/widgets/image_select.dart';
import 'package:scan_vision_app/models/livro_model.dart';
import 'package:scan_vision_app/utils/firebase_storage_utils.dart';

class CadastroLivroView extends StatefulWidget {
  final Livro livro;

  const CadastroLivroView({Key key, this.livro});

  @override
  _CadastroLivroViewState createState() => _CadastroLivroViewState();
}

class _CadastroLivroViewState extends State<CadastroLivroView> {
  File _capaFile;
  var _loading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _tituloFocusNode = FocusNode();
  final _autorFocusNode = FocusNode();
  final _anoEdicaoFocusNode = FocusNode();
  final _idiomaFocusNode = FocusNode();
  final _numEdicaoFocusNode = FocusNode();
  final _numPaginasFocusNode = FocusNode();
  final _nomeEditoraFocusNode = FocusNode();
  final _paisFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Cadastro Livro'),
        actions: <Widget>[
          _loading
              ? Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 32,
                    width: 32,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.check),
                  onPressed: _salvaLivro,
                ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Form(
          autovalidate: true,
          key: _formKey,
          child: Column(
            children: <Widget>[
              ImageSelect(
                file: _capaFile,
                url: widget.livro.capaUrl,
                onTap: _imageSelectTap,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Título"),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                initialValue: widget.livro.titulo,
                focusNode: _tituloFocusNode,
                validator: (value) =>
                    value.isEmpty ? "Campo obrigatório" : null,
                onSaved: (value) => widget.livro.titulo = value,
                onFieldSubmitted: (_) => _nextFocus(_autorFocusNode),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Autor"),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                initialValue: widget.livro.autor,
                focusNode: _autorFocusNode,
                validator: (value) =>
                    value.isEmpty ? "Campo obrigatório" : null,
                onSaved: (value) => widget.livro.autor = value,
                onFieldSubmitted: (_) => _nextFocus(_anoEdicaoFocusNode),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Ano de edição"),
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                initialValue: widget.livro.anoEdicao == null
                    ? ""
                    : widget.livro.anoEdicao.toString(),
                focusNode: _anoEdicaoFocusNode,
                maxLength: 4,
                onSaved: (value) =>
                    widget.livro.anoEdicao = int.tryParse(value),
                onFieldSubmitted: (_) => _nextFocus(_idiomaFocusNode),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Idioma"),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                initialValue: widget.livro.idioma,
                focusNode: _idiomaFocusNode,
                onSaved: (value) => widget.livro.idioma = value,
                onFieldSubmitted: (_) => _nextFocus(_numEdicaoFocusNode),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Número da edição"),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                initialValue: widget.livro.numeroEdicao == null
                    ? ""
                    : widget.livro.numeroEdicao.toString(),
                focusNode: _numEdicaoFocusNode,
                onSaved: (value) =>
                    widget.livro.numeroEdicao = int.tryParse(value),
                onFieldSubmitted: (_) => _nextFocus(_numPaginasFocusNode),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Número de páginas"),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                initialValue: widget.livro.numeroPaginas == null
                    ? ""
                    : widget.livro.numeroPaginas.toString(),
                focusNode: _numPaginasFocusNode,
                onSaved: (value) =>
                    widget.livro.numeroPaginas = int.tryParse(value),
                onFieldSubmitted: (_) => _nextFocus(_nomeEditoraFocusNode),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Nome da editora"),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                initialValue: widget.livro.nomeEditora,
                focusNode: _nomeEditoraFocusNode,
                onSaved: (value) => widget.livro.nomeEditora = value,
                onFieldSubmitted: (_) => _nextFocus(_paisFocusNode),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "País"),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.send,
                initialValue: widget.livro.pais,
                focusNode: _paisFocusNode,
                onSaved: (value) => widget.livro.pais = value,
                onFieldSubmitted: (_) => _salvaLivro(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: widget.livro.key == null
          ? null
          : FloatingActionButton(
              child: Icon(Icons.library_books),
              onPressed: () => _paginasFabTap(widget.livro),
            ),
    );
  }

  void _imageSelectTap() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1728,
      maxWidth: 1152,
    );

    if (image == null) {
      return;
    }

    _capaFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      compressQuality: 100,
      compressFormat: ImageCompressFormat.jpg,
      aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 3),
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Ajuste de capa',
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        lockAspectRatio: true,
      ),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );

    setState(() {});
  }

  void _nextFocus(FocusNode next) {
    FocusScope.of(context).requestFocus(next);
  }

  void _paginasFabTap(Livro livro) {
    Navigator.pushNamed(context, Routes.paginas, arguments: livro);
  }

  Future<void> _salvaLivro() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        _loading = true;
      });

      if (_capaFile != null) {
        var url = await FirebaseStorageUtils.uploadFile(_capaFile);
        widget.livro.capaUrl = url;
        _capaFile = null;
      }

      if (widget.livro.key == null) {
        var doc = await Firestore.instance
            .collection('livros')
            .add(widget.livro.toMap());

        widget.livro.key = doc.documentID;

        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Livro cadastrado com sucesso"),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        await Firestore.instance
            .collection('livros')
            .document(widget.livro.key)
            .updateData(widget.livro.toMap());

        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Livro alterado com sucesso"),
            duration: Duration(seconds: 2),
          ),
        );
      }

      setState(() {
        _loading = false;
      });
    }
  }
}
