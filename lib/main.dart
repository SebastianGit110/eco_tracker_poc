import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => CalculatorProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class CalculatorProvider with ChangeNotifier {
  String _output = "0";
  String _operator = "";
  double _num1 = 0;
  double _num2 = 0;

  String get output => _output;

  void buttonPressed(String buttonText) {
    if (buttonText == "CLEAR") {
      _output = "0";
      _num1 = 0;
      _num2 = 0;
      _operator = "";
    } else if (buttonText == "+" || buttonText == "-" || buttonText == "/" || buttonText == "x") {
      _num1 = double.parse(output);
      _operator = buttonText;
      _output = "0";
    } else if (buttonText == ".") {
      if (_output.contains(".")) {
        return;
      } else {
        _output = _output + buttonText;
      }
    } else if (buttonText == "=") {
      _num2 = double.parse(output);

      if (_operator == "+") {
        _output = (_num1 + _num2).toString();
      }
      if (_operator == "-") {
        _output = (_num1 - _num2).toString();
      }
      if (_operator == "x") {
        _output = (_num1 * _num2).toString();
      }
      if (_operator == "/") {
        _output = (_num1 / _num2).toString();
      }

      _num1 = 0.0;
      _num2 = 0.0;
      _operator = "";
    } else {
      if (_output == "0") {
        _output = buttonText;
      } else {
        _output = _output + buttonText;
      }
    }

    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primarySeedColor = Colors.deepPurple;

    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.oswald(fontSize: 57, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w500),
      bodyMedium: GoogleFonts.openSans(fontSize: 14),
    );

    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.light,
      ),
      textTheme: appTextTheme,
    );

    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.dark,
      ),
      textTheme: appTextTheme,
    );

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Mini Calculator',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          home: const CalculatorScreen(),
        );
      },
    );
  }
}

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  Widget buildButton(String buttonText, BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(24.0),
        ),
        onPressed: () => Provider.of<CalculatorProvider>(context, listen: false).buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final calculatorProvider = Provider.of<CalculatorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Calculator'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 12,
            ),
            child: Text(
              calculatorProvider.output,
              style: GoogleFonts.oswald(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Expanded(
            child: Divider(),
          ),
          Column(
            children: [
              Row(
                children: [
                  buildButton("7", context),
                  buildButton("8", context),
                  buildButton("9", context),
                  buildButton("/", context),
                ],
              ),
              Row(
                children: [
                  buildButton("4", context),
                  buildButton("5", context),
                  buildButton("6", context),
                  buildButton("x", context),
                ],
              ),
              Row(
                children: [
                  buildButton("1", context),
                  buildButton("2", context),
                  buildButton("3", context),
                  buildButton("-", context),
                ],
              ),
              Row(
                children: [
                  buildButton(".", context),
                  buildButton("0", context),
                  buildButton("00", context),
                  buildButton("+", context),
                ],
              ),
              Row(
                children: [
                  buildButton("CLEAR", context),
                  buildButton("=", context),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
