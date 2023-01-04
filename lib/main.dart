import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter cache with dio',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // get();
    _getData();
  }

  final List lists = [];

  _getData() async {
    String tempResponse = '';
    var fileInfo = await DefaultCacheManager()
        .getFileFromCache("https://jsonplaceholder.typicode.com/users");
    if (fileInfo == null) {
      http.Response? response;
      try {
        response = await http.get(
          Uri.parse("https://jsonplaceholder.typicode.com/users"),
        );
      } on SocketException catch (_) {
        // TODO: Handle Exception
      }
      tempResponse = response!.body;
      print(tempResponse);
      // _myData = tempResponse;
      lists.add(tempResponse);
      // put data into cache after getting from internet
      List<int> list = tempResponse.codeUnits;
      Uint8List fileBytes = Uint8List.fromList(list);
      DefaultCacheManager()
          .putFile("https://jsonplaceholder.typicode.com/users", fileBytes);
    } else {
      tempResponse = fileInfo.file.readAsStringSync();
      print(tempResponse);
      // _myData = tempResponse;
      lists.add(tempResponse);
    }
    // _parseData(tempResponse);
  }

  get() async {
    _dioCacheManager = DioCacheManager(CacheConfig());

    Options _cacheOptions = buildCacheOptions(Duration(days: 7));
    Dio _dio = Dio();
    _dio.interceptors.add(_dioCacheManager!.interceptor);
    Response response = await _dio.get(
        'https://jsonplaceholder.typicode.com/users',
        options: _cacheOptions);
    setState(() {
      _myData = response.data.toString();
    });
    print(_myData);
  }

  DioCacheManager? _dioCacheManager;
  String? _myData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          // TextButton(
          //   child: Text(
          //     'getData',
          //   ),
          //   onPressed: () async {
          //     _dioCacheManager = DioCacheManager(CacheConfig());
          //
          //     Options _cacheOptions = buildCacheOptions(Duration(days: 7));
          //     Dio _dio = Dio();
          //     _dio.interceptors.add(_dioCacheManager!.interceptor);
          //     Response response = await _dio.get(
          //         'https://jsonplaceholder.typicode.com/users',
          //         options: _cacheOptions);
          //     setState(() {
          //       _myData = response.data.toString();
          //     });
          //     print(_myData);
          //   },
          // ),
          // TextButton(
          //   child: Text(
          //     'Delete Cache',
          //   ),
          //   onPressed: () async {
          //     if (_dioCacheManager != null) {
          //       bool res = await _dioCacheManager!.deleteByPrimaryKey(
          //           'https://jsonplaceholder.typicode.com/users');
          //       print(res);
          //     }
          //   },
          // ),
          Text(
            lists.first ?? '',
            // style: Theme.of(context).textTheme.headline1,
          ),
        ],
      ),
    );
  }
}
