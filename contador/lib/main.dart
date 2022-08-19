import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // override sobrescrevendo o metodo build do StatelessWidget com meu proprio código.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int count = 0;

  void decrement() {
    setState(() {
      count--;
    });
  }

  void increment() {
    setState(() {
      count++;
    });
  }

  bool get isEmpty => count == 0;
  bool get isFull => count >= 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/blur-bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Pode entrar!",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                )),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text("$count",
                  style: TextStyle(
                    fontSize: 100,
                    color: isFull ? Colors.red : Colors.black,
                    fontWeight: FontWeight.w600,
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: isEmpty ? null : decrement,
                    style: TextButton.styleFrom(
                      backgroundColor: isEmpty
                          ? Colors.white.withOpacity(0.2)
                          : Colors.white,
                      fixedSize: const Size(100, 50),
                      primary: Colors.black,
                    ),
                    child: Text(
                      isEmpty ? "Vazio" : "Saiu",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    )),
                const SizedBox(
                  width: 25,
                ),
                TextButton(
                    onPressed: isFull ? null : increment,
                    style: TextButton.styleFrom(
                      backgroundColor:
                          isFull ? Colors.white.withOpacity(0.2) : Colors.white,
                      fixedSize: const Size(100, 50),
                      primary: Colors.black,
                    ),
                    child: Text(
                      isFull ? "Lotado" : "Entrou",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
