import 'dart:io';

import 'package:ascendtek_exam/app/views/auth/login_page.dart';
import 'package:ascendtek_exam/app/views/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    '7uDEPqvelYXbj8cmuYdAiq4oQXN3d2fmjpmEYVp6',
    'https://ascendtekapp.b4a.io',
    liveQueryUrl: 'https://ascendtekapp.b4a.io',
    clientKey: 'QKhobcYdb1MO59Iqsf2c3IePMxXLREQA7qkX2tZy',
    debug: true,
    autoSendSessionId: true,
    securityContext: SecurityContext(withTrustedRoots: true),
    coreStore: await CoreStoreSharedPrefsImp.getInstance(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}
