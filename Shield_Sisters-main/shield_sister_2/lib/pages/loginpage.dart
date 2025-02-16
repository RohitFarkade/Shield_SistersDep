import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/Authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}
final ThemeData theme = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  // Applies Poppins font to the entire text theme
);
class _MyLoginState extends State<MyLogin> {
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


//   void login() async {
//   final email = emailController.text.trim();
//   final password = passwordController.text.trim();

//   if (email.isEmpty || password.isEmpty) {
//     final snackBar = const SnackBar(
//       content: Text('Email and Password cannot be empty', style: TextStyle(color: Colors.white)),
//       duration: Duration(seconds: 2),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     return;
//   }

//   try {
//     final result = await authService.login(email, password);

//     if (result.containsKey('message') && result['message'] == 'Login successful') {
//       final snackBar = const SnackBar(
//         content: Text('Login Successful', style: TextStyle(color: Colors.white)),
//         duration: Duration(seconds: 2),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       Navigator.pushReplacementNamed(context, '/bot');
//     } else {
//       final snackBar = SnackBar(
//         content: Text(
//           result['message'] ?? 'Unknown error occurred',
//           style: const TextStyle(color: Colors.white),
//         ),
//         duration: const Duration(seconds: 2),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     }
//   } catch (e) {
//     // Display an error message if something unexpected happens.
//     final snackBar = SnackBar(
//       content: Text(
//         'An unexpected error occurred: $e',
//         style: const TextStyle(color: Colors.white),
//       ),
//       duration: const Duration(seconds: 2),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
// }
void login() async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  if (email.isEmpty || password.isEmpty) {
    final snackBar = const SnackBar(
      content: Text('Email and Password cannot be empty', style: TextStyle(color: Colors.white)),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return;
  }

  try {
    final result = await authService.login(email, password);

    if (result.containsKey('message') && result['message'] == 'Login successful') {
      // Save the user ID and JWT token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', result['user']['_id']);
      await prefs.setString('jwtToken', result['token']);
      await prefs.setString('username', result['user']['fullname']);
      await prefs.setString('email', result['user']['email']);



      final snackBar = const SnackBar(
        content: Text('Login Successful', style: TextStyle(color: Colors.white)),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacementNamed(context, '/bot');
    } else {
      final snackBar = SnackBar(
        content: Text(
          result['message'] ?? 'Unknown error occurred',
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  } catch (e) {
    // Display an error message if something unexpected happens.
    final snackBar = SnackBar(
      content: Text(
        'An unexpected error occurred: $e',
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Scaffold(
        backgroundColor: Color(0xFFDFF3EA),


        body: Stack(
          children: [
            Container(),
            Container(
              padding:  const EdgeInsets.fromLTRB(40,180,40,30),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding:  const EdgeInsets.fromLTRB(40,260,40,0),
                // padding: EdgeInsets.only(
                //     top: MediaQuery.of(context).size.height * 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(

                      child: Column(

                        children: [
                          TextField(
                            style: TextStyle(color: Colors.black),
                            controller: emailController,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Email",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black, // Set border color
                                  width: 2.0,         // Set border width
                                ),
                                borderRadius: BorderRadius.circular(10), // Set border radius
                              ),),
                          ),
                          SizedBox(

                            height: 30,
                          ),
                          TextField(
                            style: TextStyle(),
                            obscureText: true,
                            controller: passwordController,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black, // Set border color
                                    width: 2.0,         // Set border width
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          CustomPaint(
                            size: Size(50, 50),
                            painter: BlackBackgroundPainter(), // The custom painter
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text(
                              //   'Log in',
                              //   style: TextStyle(
                              //       fontSize: 27, fontWeight: FontWeight.w700),
                              // ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(250, 0, 0, 50),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.black,
                                  child: IconButton(
                                    color: Colors.white,
                                    onPressed: login,
                                    icon: Icon(
                                      Icons.arrow_forward,
                                    ),
                                  ),
                                ),
                              )

                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, '/reg');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 40.0), // Apply padding around the text
                                  child: Text(
                                    'Sign Up',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Color(0xFFF3E8E6),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                style: ButtonStyle(),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 40.0), // Apply padding around the text
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      color: Color(0xFFF3E8E6),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],

                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Create a custom painter class for the black background
class BlackBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.black;

    // // Paint a black ellipse
    // canvas.drawOval(
    //   Rect.fromLTWH(-175, 0, size.width * 85, size.height * 12),
    //   paint,
    // );

    // Paint 3 black circles
    canvas.drawCircle(
      Offset(-150, 310),  // Circle 1 center
      120,  // Circle 1 radius
      paint,
    );

    canvas.drawCircle(
      Offset(50, 300),  // Circle 2 center
      160,  // Circle 2 radius
      paint,
    );

    canvas.drawCircle(
      Offset(250, 280),  // Circle 3 center
      125,  // Circle 3 radius
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}



