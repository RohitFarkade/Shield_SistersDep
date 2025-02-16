// import 'package:flutter/material.dart';
// import '/backend/Authentication.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({Key? key}) : super(key: key);

//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final AuthService authService = AuthService();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController numberController = TextEditingController();


//   void register() async {
//     final result = await authService.register(
//       nameController.text,
//       emailController.text,
//       passwordController.text,
//       numberController.text,
//     );
//     print(result);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Scaffold(

//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.white), // Back arrow icon
//             onPressed: () {
//               Navigator.pop(context); // Goes back to the previous page
//             },
//           ),
//           title: Text(
//             'Sign Up',
//             style: TextStyle(color: Colors.white), // Text color set to white
//           ),
//           backgroundColor: Colors.black, // AppBar background color
//         ),
//         backgroundColor: Color(0xFFDFF3EA),
//         body: Stack(
//           children: [
//             Container(),
//             // Container(
//             //   padding:  const EdgeInsets.fromLTRB(30,30,30,0),
//             //   child: Text(
//             //     'Sign Up',
//             //     style: TextStyle(color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold
//             //     ),
//             //   ),
//             // ),
//             SingleChildScrollView(
//               child: Container(
//                 padding:  const EdgeInsets.fromLTRB(40,50,40,10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       // margin: EdgeInsets.only(left: 20, right: 20),
//                       child: Column(
//                         children: [
//                           TextField(
//                             style: TextStyle(color: Colors.black),
//                             controller: nameController,
//                             decoration: InputDecoration(
//                                 fillColor: Colors.grey.shade100,
//                                 filled: true,
//                                 hintText: "Name",
//                                 border: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: Colors.black, // Set border color
//                                     width: 2.0,         // Set border width
//                                   ),
//                                   borderRadius: BorderRadius.circular(10),
//                                 )),
//                           ),
//                           SizedBox(
//                             height: 40,
//                           ),
//                           TextField(
//                             style: TextStyle(color: Colors.black),
//                             controller: emailController,
//                             decoration: InputDecoration(
//                                 fillColor: Colors.grey.shade100,
//                                 filled: true,
//                                 hintText: "Email",
//                                 border: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: Colors.black, // Set border color
//                                     width: 2.0,         // Set border width
//                                   ),
//                                   borderRadius: BorderRadius.circular(10),
//                                 )),
//                           ),
//                           SizedBox(
//                             height: 40,
//                           ),
//                           TextField(
//                             style: TextStyle(),
//                             obscureText: true,
//                             controller: passwordController,
//                             decoration: InputDecoration(
//                                 fillColor: Colors.grey.shade100,
//                                 filled: true,
//                                 hintText: "Password",
//                                 border: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: Colors.black, // Set border color
//                                     width: 2.0,         // Set border width
//                                   ),
//                                   borderRadius: BorderRadius.circular(10),
//                                 )),
//                           ),
//                           SizedBox(
//                             height: 40,
//                           ),
//                           TextField(
//                             style: TextStyle(),
//                             obscureText: true,
//                             controller: numberController,
//                             decoration: InputDecoration(
//                                 fillColor: Colors.grey.shade100,
//                                 filled: true,
//                                 hintText: "Phone Number",
//                                 border: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: Colors.black, // Set border color
//                                     width: 2.0,         // Set border width
//                                   ),
//                                   borderRadius: BorderRadius.circular(10),
//                                 )),
//                           ),
//                           SizedBox(
//                             height: 40,
//                           ),
//                           ElevatedButton(
//                             onPressed: (){
//                               Navigator.pushReplacementNamed(context, '/log');
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.black,

//                               // onPrimary: Colors.white, // Text color
//                               padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12), // Button padding
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(50), // Button border radius
//                               ),
//                             ),
//                             child: Text(
//                               'Sign Up',
//                               style: TextStyle(
//                                   fontSize: 22, // Text size
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white// Text weight
//                               ),
//                             ),
//                           ),

//                           SizedBox(
//                             height: 40,
//                           ),

//                           // Row(
//                           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           //   children: [
//                           //     TextButton(
//                           //       onPressed: register,
//                           //       child: Text(
//                           //         'Register',
//                           //         textAlign: TextAlign.left,
//                           //         style: TextStyle(
//                           //             decoration: TextDecoration.underline,
//                           //             color: Color(0xff4c505b),
//                           //             fontSize: 18),
//                           //       ),
//                           //       style: ButtonStyle(),
//                           //     ),
//                           //     TextButton(
//                           //         onPressed: () {},
//                           //         child: Text(
//                           //           'Forgot Password',
//                           //           style: TextStyle(
//                           //             decoration: TextDecoration.underline,
//                           //             color: Color(0xff4c505b),
//                           //             fontSize: 18,
//                           //           ),
//                           //         )),
//                           //   ],
//                           // )
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import '/backend/Authentication.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();

  void register() async {
    final fullname = fullnameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (fullname.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields are required', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final result = await authService.register(fullname, email, password);

    if (result['message'] == 'User registered successfully') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Successful', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/log');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Registration failed', style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Sign Up', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFFDFF3EA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: const TextStyle(color: Colors.black),
              controller: fullnameController,
              decoration: InputDecoration(
                fillColor: Colors.grey.shade100,
                filled: true,
                hintText: "Full Name",
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              style: const TextStyle(color: Colors.black),
              controller: emailController,
              decoration: InputDecoration(
                fillColor: Colors.grey.shade100,
                filled: true,
                hintText: "Email",
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              style: const TextStyle(),
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                fillColor: Colors.grey.shade100,
                filled: true,
                hintText: "Password",
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2.0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
