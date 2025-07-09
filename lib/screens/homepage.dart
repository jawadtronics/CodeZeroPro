import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  String rate = "0%";
  Color color1 = const Color(0xFF74ebd5);
  Color color2 = const Color(0xFFACB6E5);

  // 🔁 Call Make.com webhook and update rate
  Future<void> sendToWebhook(String data) async {
    final url = Uri.parse(
        'https://hook.eu2.make.com/4ljnm3xcrdj3bbruczjk5udtuqzz4lnh'); // replace with your actual URL

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': data}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String? probabilityString = responseData['code probability'];

      if (probabilityString != null) {
        setState(() {
          rate = "$probabilityString%";
        });
        colorChange(); // update background color based on new rate
      }
    } else {
      print('Webhook call failed: ${response.statusCode}');
    }
  }

  void colorChange() {
    final numericRate = int.tryParse(rate.replaceAll('%', ''));

    if (numericRate != null) {
      if (numericRate >= 75 && numericRate <= 100) {
        setState(() {
          color1 = const Color(0xFFE96443); // red shades for high probability
          color2 = const Color(0xFF904E95);
        });
      } else if (numericRate > 30 && numericRate <= 74) {
        setState(() {
          color1 = const Color(0xFFf7971e); // orange shades for mid rate
          color2 = const Color(0xFFFFD200);
        });
      } else if (numericRate >= 0 && numericRate <= 29) {
        setState(() {
          color1 = const Color(0xFF74ebd5); // original blue shades
          color2 = const Color(0xFFACB6E5);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color1, color2],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Opacity(
                      opacity: 0.05,
                      child: Text(
                        rate,
                        style: const TextStyle(
                          fontSize: 400,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 10,
                        ),
                      ),
                    ),
                  ),

                  // ✅ "AI Code Detector" Text
                  Positioned(
                    top: 80,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        "AI Code Detector",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.9),
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black26,
                              offset: Offset(2, 2),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 🔺 Glassmorphic section
                  Center(
                    child: GlassmorphicContainer(
                      width: 650,
                      height: 400,
                      borderRadius: 20,
                      blur: 2,
                      alignment: Alignment.center,
                      border: 2,
                      linearGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.5),
                          Colors.white.withOpacity(0.5),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Please Input Your Code",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: SingleChildScrollView(
                                child: TextField(
                                  controller: _controller,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Enter your code here...',
                                    filled: true,
                                    fillColor: Colors.white24,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  final text = _controller.text;
                                  sendToWebhook(text);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(25),
                                  backgroundColor: Colors.black,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ✅ Uplifted rounded banner at bottom
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, -4),
                )
              ],
            ),
            child: Text(
              "Try Out Our Premium Code Detector With 400% More Accuracy Then CodePro Simon",
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
