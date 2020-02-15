import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:scan_vision_app/models/pagina_model.dart';
import 'package:scan_vision_app/visualizar_pagina/widgets/text_detector_painter.dart';
import 'package:zoom_widget/zoom_widget.dart';

class VisualizarPaginaView extends StatefulWidget {
  final Pagina pagina;

  const VisualizarPaginaView({Key key, this.pagina}) : super(key: key);

  @override
  _VisualizarPaginaViewState createState() => _VisualizarPaginaViewState();
}

class _VisualizarPaginaViewState extends State<VisualizarPaginaView> {
  Widget _textPaint = Material(
    color: Colors.transparent,
  );
  final flutterTts = FlutterTts();
  var _playing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualizar Página'),
      ),
      body: Zoom(
        height: (MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                kToolbarHeight) *
            4,
        width: MediaQuery.of(context).size.width * 4,
        initZoom: 0,
        centerOnScale: true,
        enableScroll: true,
        doubleTapZoom: true,
        child: Center(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: widget.pagina.paginaUrl,
                fit: BoxFit.fill,
              ),
              _textPaint,
            ],
          ),
        ),
      ),
      floatingActionButton: _playing
          ? FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: () {
                flutterTts.stop();
                setState(() {
                  _playing = false;
                });
              })
          : SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                  child: Icon(Icons.keyboard_voice),
                  backgroundColor: Colors.red,
                  onTap: _speakTap,
                ),
                SpeedDialChild(
                  child: Icon(Icons.select_all),
                  labelStyle: TextStyle(fontSize: 18.0),
                  onTap: _detectTextTap,
                ),
                SpeedDialChild(
                  child: Icon(Icons.share),
                  backgroundColor: Colors.green,
                  onTap: _shareText,
                ),
              ],
            ),
    );
  }

  @override
  void initState() {
    flutterTts.setStartHandler(() {
      setState(() {
        _playing = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        _playing = false;
      });
    });

    flutterTts.setErrorHandler((e) {
      setState(() {
        _playing = false;
      });
    });

    super.initState();
  }

  void _detectTextTap() async {
    var imageFile =
        await DefaultCacheManager().getFileFromCache(widget.pagina.paginaUrl);
    final visionImage = FirebaseVisionImage.fromFile(imageFile.file);
    final textRecognizer = FirebaseVision.instance.textRecognizer();
    final visionText = await textRecognizer.processImage(visionImage);
    try {
      var image = await decodeImageFromList(
        imageFile.file.readAsBytesSync(),
      );

      setState(() {
        _textPaint = CustomPaint(
          painter: TextDetectorPainter(
            Size(
              image.width.toDouble(),
              image.height.toDouble(),
            ),
            visionText,
          ),
        );
      });
    } finally {
      textRecognizer.close();
    }
  }

  void _shareText() async {
    var textRead = await _textReader();

    Share.text('Scan Vision App', textRead, 'text/plain');
  }

  void _speakTap() async {
    var textRead = await _textReader();

    if (textRead.isNotEmpty) {
      await flutterTts.speak(textRead);
    }
  }

  Future<String> _textReader() async {
    final imageFile =
        await DefaultCacheManager().getFileFromCache(widget.pagina.paginaUrl);

    final visionImage = FirebaseVisionImage.fromFile(imageFile.file);
    final textRecognizer = FirebaseVision.instance.textRecognizer();
    final visionText = await textRecognizer.processImage(visionImage);

    try {
      var textRead = '';

      for (TextBlock block in visionText.blocks) {
        for (var line in block.lines) {
          textRead += line.text + ' ';
        }
      }
      return textRead;
    } finally {
      textRecognizer.close();
    }
  }
}
