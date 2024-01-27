import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lottery Numbers Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LotteryScreen(),
    );
  }
}

class LotteryScreen extends StatefulWidget {
  const LotteryScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LotteryScreenState createState() => _LotteryScreenState();
}

class _LotteryScreenState extends State<LotteryScreen> {
  final TextEditingController countController = TextEditingController();
  final TextEditingController maxNumberController = TextEditingController();
  final TextEditingController setsController = TextEditingController();

  List<List<int>> generatedSets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lottery Numbers Generator'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildInputField('Numbers Count', countController, 1, 6),
              buildInputField('Max Number', maxNumberController, 1, 100),
              buildInputField('Number of Sets', setsController, 1, 5),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: generateNumbers,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow, // background color
                    foregroundColor: Colors.black, // text color
                    elevation: 5, // button's elevation when it's pressed
                    padding: const EdgeInsets.all(12)),
                child: const Text('Generate', style: TextStyle(fontSize: 17)),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: generatedSets.isEmpty
                    ? Container()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Generated Numbers (${countController.text} out of ${maxNumberController.text})',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: generatedSets.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                      'Set ${index + 1}: ${generatedSets[index].join(', ')}'),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomAppBar(
          color: Color.fromARGB(255, 6, 86, 91),
          elevation: 0,
          child: Column(
            children: [
              Text('Name: Zenith Rajbhandari',
                  style: TextStyle(color: Colors.white, fontSize: 17)),
              Text('College ID: 301373152',
                  style: TextStyle(color: Colors.white, fontSize: 17)),
            ],
          ),
        ));
  }

  Widget buildInputField(
      String label, TextEditingController controller, int min, int max) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        int? intValue = int.tryParse(value);
        if (intValue == null || intValue < min || intValue > max) {
          return 'Please enter a valid number between $min and $max';
        }
        return null;
      },
    );
  }

  void generateNumbers() {
    if (countController.text.isNotEmpty &&
        maxNumberController.text.isNotEmpty &&
        setsController.text.isNotEmpty) {
      int count = int.parse(countController.text);
      int maxNumber = int.parse(maxNumberController.text);
      int sets = int.parse(setsController.text);

      List<int> numbers = List.generate(maxNumber, (index) => index + 1);
      generatedSets.clear();

      for (int i = 0; i < sets; i++) {
        List<int> set = [];
        Set<int> uniqueNumbers = {};

        while (uniqueNumbers.length < count) {
          int randomIndex = Random().nextInt(numbers.length);
          uniqueNumbers.add(numbers[randomIndex]);
        }

        set.addAll(uniqueNumbers.toList());
        set.sort();

        generatedSets.add(set);
      }

      setState(() {});
    }
  }
}
