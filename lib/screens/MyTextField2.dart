import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MyTextField2 extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final void Function(String?)? onSaved;

  const MyTextField2({
    Key? key,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.onSaved,
  }) : super(key: key);

  @override
  _MyTextField2State createState() => _MyTextField2State();
}

class _MyTextField2State extends State<MyTextField2> {
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      try {
        bool available = await _speech.initialize(
          onStatus: (val) => print('onStatus: $val'),
          onError: (val) => print('onError: $val'),
        );
        if (available) {
          setState(() => _isListening = true);
          _speech.listen(
            onResult: (val) => setState(() {
              _controller.text = _convertTextToNumber(val.recognizedWords);
            }),
          );
        } else {
          print('Microphone not available');
        }
      } catch (e) {
        print('Error initializing speech recognition: $e');
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  String _convertTextToNumber(String recognizedWords) {
    Map<String, String> numberWords = {
      'cero': '0',
      'uno': '1',
      'una': '1',
      'dos': '2',
      'tres': '3',
      'cuatro': '4',
      'cinco': '5',
      'seis': '6',
      'siete': '7',
      'ocho': '8',
      'nueve': '9',
      'diez': '10',
      'once': '11',
      'doce': '12',
      'trece': '13',
      'catorce': '14',
      'quince': '15',
      'dieciséis': '16',
      'diecisiete': '17',
      'dieciocho': '18',
      'diecinueve': '19',
      'veinte': '20',
      'treinta': '30',
      'cuarenta': '40',
      'cincuenta': '50',
      'sesenta': '60',
      'setenta': '70',
      'ochenta': '80',
      'noventa': '90',
      'cien': '100',
      'mil': '1000',
      'punto': '.',
      'coma': '.',
      'y': '', // Ignorar "y" en frases como "cuarenta y cinco"
    };

    List<String> words = recognizedWords.split(' ');
    String result = '';
    bool isDecimal = false;

    for (var word in words) {
      String lowerWord = word.toLowerCase();
      if (numberWords.containsKey(lowerWord)) {
        result += numberWords[lowerWord]!;
        if (lowerWord == 'punto' || lowerWord == 'coma') {
          isDecimal = true;
        }
      }
    }

    if (isDecimal && !result.contains('.')) {
      result += '.0';
    }

    result = result.replaceAll(' ', ''); // Remover espacios extra
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color.fromARGB(255, 225, 255, 246),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 180, 255, 231)),
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: Colors.blue),
        prefixIcon: Icon(widget.prefixIcon, color: Color.fromARGB(255, 97, 173, 255)),
        suffixIcon: IconButton(
          icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: Color(0xFF164092)),
          onPressed: _listen,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onSaved: widget.onSaved,
    );
  }
}
