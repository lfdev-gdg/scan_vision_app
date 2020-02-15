import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan_vision_app/core/widgets/image_select.dart';
import 'package:scan_vision_app/models/pagina_model.dart';
import 'package:scan_vision_app/utils/firebase_storage_utils.dart';

class CadastroPaginaView extends StatefulWidget {
  final Pagina pagina;
  final String livroKey;

  const CadastroPaginaView({Key key, this.pagina, this.livroKey});

  @override
  _CadastroPaginaViewState createState() => _CadastroPaginaViewState();
}

class _CadastroPaginaViewState extends State<CadastroPaginaView> {
  File _paginaFile;
  var _loading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _salvaLivro() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        _loading = true;
      });

      if (_paginaFile != null) {
        var url = await FirebaseStorageUtils.uploadFile(_paginaFile);
        widget.pagina.paginaUrl = url;
        _paginaFile = null;
      }

      if (widget.pagina.key == null) {
        var doc = await Firestore.instance
            .collection('livros/${widget.livroKey}/paginas')
            .add(widget.pagina.toMap());

        widget.pagina.key = doc.documentID;

        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Página cadastrada com sucesso"),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        await Firestore.instance
            .collection('livros/${widget.livroKey}/paginas')
            .document(widget.pagina.key)
            .updateData(widget.pagina.toMap());

        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text("Página cadastrada com sucesso"),
            duration: Duration(seconds: 2),
          ),
        );
      }

      setState(() {
        _loading = false;
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Cadastro página'),
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
                file: _paginaFile,
                url: widget.pagina.paginaUrl,
                onTap: _imageSelectTap,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Número da página"),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    value.isEmpty ? "Campo obrigatório" : null,
                initialValue: widget.pagina.pagina == null
                    ? ""
                    : widget.pagina.pagina.toString(),
                onSaved: (value) => widget.pagina.pagina = int.tryParse(value),
                onFieldSubmitted: (_) => _salvaLivro(),
              ),
            ],
          ),
        ),
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

    _paginaFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      compressQuality: 100,
      compressFormat: ImageCompressFormat.jpg,
      aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 3),
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Ajuste de página',
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
}
