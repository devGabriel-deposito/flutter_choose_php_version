import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String php8Path = "C:\\php\\php-8.3.4-nts-Win32-vs16-x64";
  final String php7Path = "C:\\php\\php-7.4.32-nts-Win32-vc15-x64";

  String currentPhpVersion = "";

  void renamePhpExecutables(bool switchToPhp7) {
    try {
      // Renomear os arquivos php.exe nas pastas PHP 7 e PHP 8
      if (switchToPhp7 && currentPhpVersion == "PHP 8") {
        setState(() {
          currentPhpVersion = "PHP 7";
        });

        File(php7Path + "\\php7.exe").renameSync(php7Path + "\\php.exe");
        File(php8Path + "\\php.exe").renameSync(php8Path + "\\php8.exe");
      } else if (switchToPhp7 == false && currentPhpVersion == "PHP 7") {
        setState(() {
          currentPhpVersion = "PHP 8";
        });

        File(php7Path + "\\php.exe").renameSync(php7Path + "\\php7.exe");
        File(php8Path + "\\php8.exe").renameSync(php8Path + "\\php.exe");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Current Version: $currentPhpVersion"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao renomear os arquivos php.exe: $e"),
        ),
      );
    }
  }

  void updateCurrentPhpVersion() {
    List<FileSystemEntity> filesPhp8 = Directory(php8Path).listSync();
    List<String> fileNamesPhp8 =
        filesPhp8.map((file) => file.uri.pathSegments.last).toList();

    fileNamesPhp8.forEach((element) {
      if (element == 'php.exe') {
        currentPhpVersion = "PHP 8";
      }
    });

    List<FileSystemEntity> filesPhp7 = Directory(php7Path).listSync();
    List<String> fileNamesPhp7 =
        filesPhp7.map((file) => file.uri.pathSegments.last).toList();

    fileNamesPhp7.forEach((element) {
      if (element == 'php.exe') {
        currentPhpVersion = "PHP 7";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    updateCurrentPhpVersion();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Change PHP version"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Current PHP version: $currentPhpVersion",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 100.0)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                ElevatedButton(
                  onPressed: () => {renamePhpExecutables(true)},
                  child: Text("PHP 7"),
                ),
                const Spacer(flex: 1),
                ElevatedButton(
                  onPressed: () => {renamePhpExecutables(false)},
                  child: Text("PHP 8"),
                ),
                const Spacer(flex: 1),
              ],
            )
          ],
        ),
      ),
    );
  }
}
