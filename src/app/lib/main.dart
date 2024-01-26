import 'package:flutter/foundation.dart';
import 'package:gui/numeric_keypad.dart'; // the current package (see Makefile)
import 'package:flutter/material.dart';

import 'package:gui/addition_service.dart';
import 'package:usecase/usecase.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AdditionService.instance.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static const title = 'Int Addition Keypad Boilerplate';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CustomNumPadPage(title: title),
    );
  }
}

class CustomNumPadPage extends StatefulWidget {
  const CustomNumPadPage({super.key, required this.title});

  final String title;

  @override
  State<CustomNumPadPage> createState() => _CustomNumPadPageState();
}

class _CustomNumPadPageState extends State<CustomNumPadPage> {
  late final TextEditingController _controller;

  // generated gRPC stub
  late AdditionClient _stub;

  // Channel used by the client and the server to exchange
  late ClientChannel _channel;

  //stream logic from the client
  late List<String> _streamList;

  @override
  void initState() {
    super.initState();
    // At the beginning of the app building
    // mainly 4 logic part have been created to manage the app:
    // the controller, the client stream list, the communication
    // channel and the gRPC stubs

    // The
    _controller = TextEditingController();
    _streamList = <String>[];

    _channel = ClientChannel(
      '7.tcp.eu.ngrok.io',
      port: 12179,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
      ),
    );

    _stub = AdditionClient(_channel);
  }

  @override
  void dispose() {
    _controller.dispose();
    _channel.shutdown();
    super.dispose();
  }

  // The digit listener
  void onInputNumber(int value) {
    _controller.text += value.toString();
  }

  // The plus (+) symbol listener
  void onInputPlusSymbol(String value) {
    _controller.text += " $value ";
  }

  // Semicolon
  void onInputSemiColon(String value) {
    _controller.text += "$value ";
    if (kDebugMode) {
      print('My stream content 1: ${_controller.text}');
    }
    _streamList = _controller.text.split(";");

    if (kDebugMode) {
      print('My stream content: $_streamList');
    }
  }

  // Clear lat Input listener
  void onClearLastInput() {
    if (_controller.text.isNotEmpty) {
      _controller.text = _controller.text.substring(
        0,
        _controller.text.length - 1,
      );
    }
  }

  // unary or stream addition Client side logic
  Future<void> add() async {
    // simple unary addition: there is no stream
    if (_streamList.isEmpty) {
      List<String> num = _controller.text.split('+');
      if (_controller.text.isNotEmpty) {
        if (kDebugMode) {
          print('>> num: ${num[0]}, ${num[1]}');
        }
      }
      try {
        var a = int.parse(num[0]);
        var b = int.parse(num[1]);
        var req = AdditionRequest(a: a, b: b);

        final response = await _stub.add(req);

        if (kDebugMode) {
          print('>> result: ${response.result}');
        }
        _controller.text = response.result.toString();
      } catch (e) {
        if (kDebugMode) {
          print('>>ERR: $e');
        }
      }
    }

    // streaming addition
    else {
      AdditionRequest createAddition(int a, int b) {
        return AdditionRequest()
          ..a = a
          ..b = b;
      }

      // We should clean the textfield screen, if we start streaming
      _controller.text = "";
      final addRequests = <AdditionRequest>[];

      // for each stream, we gonna split the stream operand: a and b
      for (final stream in _streamList) {
        List<String> num = stream.split('+');
        if (_controller.text.isNotEmpty) {
          if (kDebugMode) {
            print('>> num: ${num[0]}, ${num[1]}');
          }
        }
        try {
          // the split are inserted in the following variable
          var a = int.parse(num[0]);
          var b = int.parse(num[1]);

          addRequests.add(createAddition(a, b));
        } catch (e) {
          if (kDebugMode) {
            print('>>ERR: $e');
          }
        }
      }

      // Building the stream structure, that will be sent to the server
      Stream<AdditionRequest> outgoingAddReqs() async* {
        for (final addRequest in addRequests) {
          // short delay to simulate some interaction
          await Future.delayed(const Duration(milliseconds: 10));

          print(
              'Sending Addition Op Data a = ${addRequest.a} and b = ${addRequest.b}');
          yield addRequest;
        }
      }

      // we send the stream list here and we get reply
      // We then print stream with some delay on the screeen
      final call = _stub.addChat(outgoingAddReqs());
      await for (var addReq in call) {
        if (kDebugMode) {
          print(' stream Result got: ${addReq.result}');
        }
        // short delay to simulate stream sending
        await Future.delayed(const Duration(milliseconds: 300));
        _controller.text += "${addReq.result}; ";
      }
      _streamList = [];
    }
  }

  void onClearAll() {
    _controller.clear();
  }

  // TODO: Implement method to input number to textfield
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1E33),
      appBar: AppBar(title: Text(widget.title)),
      body: Column(children: <Widget>[
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: _controller,
                autofocus: true,
                showCursor: true,
                keyboardType: TextInputType.none,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
            child: NumericKeyPad(
          onInputNumber: onInputNumber,
          onClearLastInput: onClearLastInput,
          onClearAll: onClearAll,
          onInputPlusSymbol: onInputPlusSymbol,
          onInputEqual: add,
          onInputSemiColumn: onInputSemiColon,
        )),
      ]),
    );
  }
}
