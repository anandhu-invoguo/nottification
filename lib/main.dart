import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:nottification/notification.dart';

void main() {
  // Set up global error handler
  FlutterError.onError = (FlutterErrorDetails details) {
    // Convert stack trace to a string, ensuring it's not null
    String stackTraceString = details.stack?.toString() ?? "";

    // Report the error to your API
    reportErrorToAPI(details.exceptionAsString());

    // Optionally, you can also log it to the console or take other actions
    print("Caught Flutter error: ${details.exceptionAsString()}");
    print("Stack trace: $stackTraceString");
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notifications Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home Page",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationPage()),
                );
              },
              child: const Text(
                "Go to Notifications",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // This will trigger an error
                throw Exception(
                    "This is a test error to check the reportErrorToAPI function.");
              },
              child: const Text('Trigger Error'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> reportErrorToAPI(String errorMessage) async {
  final String apiUrl =
      "https://bdbs.co.in/php_test_by_invo/anandhu/test/error/index.php"; // Ensure correct API path

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"error_message": errorMessage}),
    );

    if (response.statusCode == 200) {
      print("Error logged successfully: ${response.body}");
    } else {
      print("Failed to log error: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("Error reporting failed: $e");
  }
}
