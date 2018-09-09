import 'dart:convert';
import 'package:http/http.dart';

dynamic extractData(Response resp) => json.decode(resp.body);
