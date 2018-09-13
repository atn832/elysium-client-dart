/* From https://github.com/dart-lang/sdk/issues/32592 */

@JS()
library gelocation_dartdevc_polyfill.dart;

// tracking dart-lang/sdk#32592

import 'dart:async';
import 'dart:html' as html;

import 'package:js/js.dart';

class Geolocation {
  bool _ddcIsSafe;

  factory Geolocation() {
    if (_ddcSupported()) {
      return new Geolocation._native();
    } else {
      return new Geolocation._jsInterop();
    }
  }

  Geolocation._jsInterop() {
    _ddcIsSafe = false;
  }

  Geolocation._native() {
    _ddcIsSafe = true;
  }

  Future<Position> getCurrentPosition({bool enableHighAccuracy, Duration timeout, Duration maximumAge}) {
    if (_ddcIsSafe) {
      return html.window.navigator.geolocation
          .getCurrentPosition(enableHighAccuracy: enableHighAccuracy, timeout: timeout, maximumAge: maximumAge)
          .then((loc) => new Position(loc));
    } else {
      var c = new Completer<Position>();
      var jsGeoOptions = new _JsGeoOptions(
          timeout: timeout.inMilliseconds, maximumAge: timeout.inMilliseconds, enableHighAccuracy: enableHighAccuracy);
      _JsGeolocation.getCurrentPosition((pos) {
        c.complete(new Position(pos));
      }, (err) {
        c.completeError(err);
      }, jsGeoOptions);
      return c.future;
    }
  }

  Stream<Position> watchPosition({bool enableHighAccuracy, Duration timeout, Duration maximumAge}) {
    if (_ddcIsSafe) {
      return html.window.navigator.geolocation
          .watchPosition(enableHighAccuracy: enableHighAccuracy, timeout: timeout, maximumAge: maximumAge)
          .map((pos) => new Position(pos));
    } else {
      var controller = new StreamController<Position>.broadcast();
      var jsGeoOptions = new _JsGeoOptions(
          timeout: timeout.inMilliseconds, maximumAge: timeout.inMilliseconds, enableHighAccuracy: enableHighAccuracy);
      _JsGeolocation.watchPosition((pos) {
        controller.add(new Position(pos));
      }, (err) {
        controller.addError(err);
      }, jsGeoOptions);
      return controller.stream;
    }
  }

  static bool _ddcSupported() {
    try {
      html.window.navigator.geolocation.getCurrentPosition;
      return true;
    } catch (_) {
      return false;
    }
  }
}

@JS('navigator.geolocation')
class _JsGeolocation {
  external static getCurrentPosition(_jsCallback success, [_jsCallback error, _JsGeoOptions params]);

  external static watchPosition(_jsCallback success, [_jsCallback error, _JsGeoOptions params]);
}

@JS()
@anonymous
class _JsGeoOptions {
  external int get timeout;

  external int get maximumAge;

  external bool get enableHighAccuracy;

  external factory _JsGeoOptions({int timeout, int maximumAge, bool enableHighAccuracy});
}

@JS()
class _JsPosition {
  external int get timestamp;

  external Coordinates get coords;
}

@JS()
class _JsCoordinates {
  external double get latitude;

  external double get longitude;

  external double get altitude;

  external double get altitudeAccuracy;

  external double get heading;

  external double get speed;
}

// proxy class
class Position {
  final _instance;
  final bool _isNativeInstance;

  factory Position(instance) {
    if (instance == null) {
      throw new ArgumentError.notNull('instance');
    }
    if (instance is html.Geoposition) {
      return new Position._(instance, true);
    } else if (instance is _JsPosition) {
      return new Position._(instance, false);
    } else {
      throw new ArgumentError('Invalid type');
    }
  }

  Position._(this._instance, this._isNativeInstance);

  int get timestamp => _isNativeInstance ? _asNative.timestamp : _asInterop.timestamp;

  Coordinates get coordinates => new Coordinates(this);

  html.Geoposition get _asNative => _instance;

  _JsPosition get _asInterop => _instance;
}

// proxy class
class Coordinates {
  final _instance;
  final bool _isNativeInstance;

  factory Coordinates(Position positionInstance) {
    if (positionInstance == null) {
      throw new ArgumentError.notNull('instance');
    }
    if (positionInstance._isNativeInstance) {
      return new Coordinates._(positionInstance._asNative.coords, true);
    } else {
      return new Coordinates._(positionInstance._asInterop.coords, false);
    }
  }

  Coordinates._(this._instance, this._isNativeInstance);

  double get latitude => _isNativeInstance ? _asNative.latitude : _asInterop.latitude;

  double get longitude => _isNativeInstance ? _asNative.longitude : _asInterop.longitude;

  double get altitude => _isNativeInstance ? _asNative.altitude : _asInterop.altitude;

  double get altitudeAccuracy => _isNativeInstance ? _asNative.altitudeAccuracy : _asInterop.altitudeAccuracy;

  double get heading => _isNativeInstance ? _asNative.heading : _asInterop.heading;

  double get speed => _isNativeInstance ? _asNative.speed : _asInterop.speed;

  html.Coordinates get _asNative => _instance;

  _JsCoordinates get _asInterop => _instance;
}

typedef _jsCallback(param);