import 'dart:async';
import 'package:app_links/app_links.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();

  factory DeepLinkService() {
    return _instance;
  }

  DeepLinkService._internal();

  final _deepLinkStreamController = StreamController<Uri>.broadcast();
  StreamSubscription? _deepLinkSubscription;
  late final AppLinks _appLinks;

  Stream<Uri> get deepLinkStream => _deepLinkStreamController.stream;

  void initialize() async {
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() {
    _appLinks = AppLinks();
    
    // Listen for deep links
    _deepLinkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        print('Deep Link received: $uri');
        _deepLinkStreamController.add(uri);
      },
      onError: (err) {
        print('Deep Link Error: $err');
      },
    );
  }

  void dispose() {
    _deepLinkSubscription?.cancel();
    _deepLinkStreamController.close();
  }
}
