import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:typed_data';

void main() {
  runApp(const RGBControlApp());
}

class RGBControlApp extends StatelessWidget {
  const RGBControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: RGBController());
  }
}

class RGBController extends StatefulWidget {
  @override
  _RGBControllerState createState() => _RGBControllerState();
}

class _RGBControllerState extends State<RGBController> {
  BluetoothConnection? connection;
  bool isConnected = false;

  double red = 0;
  double green = 0;
  double blue = 0;

  Future<void> _connect() async {
    // Введи MAC адрес HC-05
    String address = "00:00:00:00:00:00"; // замени на адрес модуля!

    try {
      connection = await BluetoothConnection.toAddress(address);
      setState(() {
        isConnected = true;
      });
    } catch (e) {
      print("Ошибка подключения: $e");
    }
  }

  void sendRGB() {
    if (connection != null && isConnected) {
      String data =
          "${red.toInt()}.${green.toInt()}.${blue.toInt()}"; // формат R.G.B
      connection!.output.add(Uint8List.fromList(data.codeUnits));
      connection!.output.add(
        Uint8List.fromList("\n".codeUnits),
      ); // send newline
      connection!.output.allSent;
      print("Отправлено: $data");
    }
  }

  @override
  void dispose() {
    connection?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("RGB Bluetooth Control")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _connect,
            child: Text(isConnected ? "Подключено" : "Подключиться"),
          ),

          // slider Р
          Text("Red ${red.toInt()}"),
          Slider(
            value: red,
            max: 255,
            min: 0,
            divisions: 255,
            activeColor: Colors.red,
            onChanged: (v) {
              setState(() {
                red = v;
              });
              sendRGB();
            },
          ),

          // slider G
          Text("Green ${green.toInt()}"),
          Slider(
            value: green,
            max: 255,
            min: 0,
            divisions: 255,
            activeColor: Colors.green,
            onChanged: (v) {
              setState(() {
                green = v;
              });
              sendRGB();
            },
          ),

          // slider B
          Text("Blue ${blue.toInt()}"),
          Slider(
            value: blue,
            max: 255,
            min: 0,
            divisions: 255,
            activeColor: Colors.blue,
            onChanged: (v) {
              setState(() {
                blue = v;
              });
              sendRGB();
            },
          ),
        ],
      ),
    );
  }
}
