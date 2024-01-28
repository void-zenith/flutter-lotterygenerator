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
  final _formKey = GlobalKey<FormState>();
  final String _collegeID = "52";
  final TextEditingController _countController = TextEditingController();
  final TextEditingController _maxNumberController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();

  List<List<int>> generatedSets = [];
  bool isGenerated = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lottery Numbers Generator'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildInputField(
                      'Numbers Count (1 to 6)', _countController, 1, 6, false),
                  buildInputField('Max Number (1 to 100)', _maxNumberController,
                      1, 100, true),
                  buildInputField(
                      'Number of Sets (1 to 5)', _setsController, 1, 5, false),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: generateNumbers,
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.yellow, // background color
                              foregroundColor: Colors.black, // text color
                              elevation:
                                  2, // button's elevation when it's pressed
                              padding: const EdgeInsets.all(12)),
                          child: const Text('Generate',
                              style: TextStyle(fontSize: 17)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: clearAll,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                  255, 245, 100, 84), // background color
                              foregroundColor: Colors.white, // text color
                              elevation:
                                  2, // button's elevation when it's pressed
                              padding: const EdgeInsets.all(12)),
                          child: const Text('Clear All',
                              style: TextStyle(fontSize: 17)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: !isGenerated
                        ? const Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                Text(
                                  "The Lottery Numbers Generator is a Flutter application designed to provide users with the ability to generate random sets of lottery numbers based on their input parameters.",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "If the maximum number is not given, then last two digits of college Id will be taken as default maximum number.",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                )
                              ])
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Generated Numbers (${_countController.text} out of ${_maxNumberController.text.isNotEmpty ? _maxNumberController.text : _collegeID})',
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
              )),
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

  Widget buildInputField(String label, TextEditingController controller,
      int min, int max, bool isOptional) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter a number between $min and $max',
      ),
      validator: (value) {
        if (isOptional == true) {
          return null;
        }
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

  void clearAll() {
    setState(() {
      isGenerated = false;
      _countController.clear();
      _maxNumberController.clear();
      _setsController.clear();
    });
    generatedSets.clear();
  }

  void generateNumbers() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_countController.text.isNotEmpty && _setsController.text.isNotEmpty) {
        int count = int.parse(_countController.text);
        int maxNumber = int.parse(_maxNumberController.text.isNotEmpty
            ? _maxNumberController.text
            : _collegeID);
        int sets = int.parse(_setsController.text);
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

          setState(() {
            isGenerated = true;
          });
          generatedSets.add(set);
        }

        setState(() {});
      }
    }
  }
}
