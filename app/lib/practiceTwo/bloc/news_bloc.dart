import 'dart:async';
import 'package:app/practiceTwo/api/apiCall.dart';
import 'package:app/practiceTwo/model/articles.dart';

enum UserNewsAction {
  Read,
}

class NewsBloc {
  final _stateStreamController = StreamController<List<Articles>?>();
  StreamSink<List<Articles>?> get _newsSink => _stateStreamController.sink;
  Stream<List<Articles>?> get newsStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<UserNewsAction>();
  StreamSink<UserNewsAction> get eventSink => _eventStreamController.sink;
  Stream<UserNewsAction> get _eventStream => _eventStreamController.stream;

  NewsBloc() {
    _eventStream.listen((event) async {
      if (event == UserNewsAction.Read) {
        try {
          var news = await ApiCall().getNews();
          _newsSink.add(news.articles);
        } on Exception catch (e) {
          _newsSink.addError(e);
        }
      }
    });
  }

  void closeTheController() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
