import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yum_quick/view/homepage/home_page.dart';

class Regpage extends StatefulWidget {
  const Regpage({super.key});

  @override
  State<Regpage> createState() => _RegpageState();
}

class _RegpageState extends State<Regpage> {
  final namecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final mobilenocontroller = TextEditingController();
  final dobcontroller = TextEditingController();

  final _fromkey = GlobalKey<FormState>();

  bool showpassword = false;

  bool loading = false;
  String error = "";

Future<void> register() async {
  if (!_fromkey.currentState!.validate()) {
    return;
  }

  setState(() {
    loading = true;
    error = "";
  });

  try {
    final name = namecontroller.text.trim();
    final email = emailcontroller.text.trim();
    final password = passwordcontroller.text.trim();
    final mobile = mobilenocontroller.text.trim();
    final dob = dobcontroller.text.trim();

    // Create account in Firebase Authentication
    UserCredential result =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Get user's UID
    final uid = result.user!.uid;

    print("User created successfully");
    print("UID: $uid");

    // Save user information in Firestore
    await FirebaseFirestore.instance
        .collection('food')
        .doc(uid)
        .set({
      'name': name,
      'email': email,
      'mobile': mobile,
      'dob': dob,
      'createdAt': FieldValue.serverTimestamp(),
    });

    print("User data saved to Firestore");

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration successful'),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Homescreen(),
      ),
    );
  } on FirebaseAuthException catch (e) {
    print("Firebase Auth Error: ${e.code}");
    print("Message: ${e.message}");

    if (mounted) {
      setState(() {
        error = e.message ?? 'Registration failed';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Registration failed'),
        ),
      );
    }
  } on FirebaseException catch (e) {
    print("Firestore Error: ${e.code}");
    print("Message: ${e.message}");

    if (mounted) {
      setState(() {
        error = e.message ?? 'Firestore error';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Firestore error'),
        ),
      );
    }
  } catch (e) {
    print("Other Error: $e");

    if (mounted) {
      setState(() {
        error = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade300,
      appBar: AppBar(
        backgroundColor: Colors.amber.shade300,
        title: Center(
          child: Text('New Account', style: TextStyle(color: Colors.white)),
        ),
        leading: Icon(Icons.arrow_back_ios, color: Colors.deepOrange),
      ),
      body: Form(
        key: _fromkey,
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(19),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Full name',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      TextFormField(
                        controller: namecontroller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(248, 243, 243, 148),
                          hintText: 'Your Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.done,
                      ),

                      Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      TextFormField(
                        controller: passwordcontroller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(248, 243, 243, 148),
                          hintText: '**********',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),

                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                showpassword = !showpassword;
                              });
                            },
                            icon: Icon(
                              showpassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'password cannot be empty';
                          }
                          if (value.length < 6) {
                            return 'password contains 6 or more characters';
                          }
                          return null;
                        },
                      ),

                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      TextFormField(
                        controller: emailcontroller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(248, 243, 243, 148),
                          hintText: 'example@example.com',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.done,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'feild canot be empty';
                          }
                          if (!value.contains('@')) {
                            return 'enter a valid email id';
                          }
                          return null;
                        },
                      ),

                      Text(
                        'Mobile Number',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      TextFormField(
                        controller: mobilenocontroller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(248, 243, 243, 148),
                          hintText: '+123 456 7890',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.done,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'it is empty';
                          }
                          if (value.length < 10) {
                            return 'place enter 10 digit';
                          }
                          return null;
                        },
                      ),

                      Text(
                        'Date Of Birth',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      TextFormField(
                        controller: dobcontroller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(248, 243, 243, 148),
                          hintText: 'DD/MM/YY',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.done,
                      ),

                      SizedBox(height: 15),

                      Center(child: Text('By contining, you agree to')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Terms of Us',
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                          SizedBox(width: 5),
                          Text('and'),
                          SizedBox(width: 5),
                          Text(
                            'Privacy Policy.',
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        ],
                      ),

                      SizedBox(height: 15),

                      Center(
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.deepOrange,
                          ),
                          child: TextButton(
                          onPressed: 
loading
    ? null
    : () {
        if (_fromkey.currentState!.validate()) {
          register();
        }
      },

                            child: Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          socialButton(icon: Icons.g_mobiledata, onTap: () {}),

                          SizedBox(width: 20),

                          socialButton(icon: Icons.facebook, onTap: () {}),

                          SizedBox(width: 20),

                          socialButton(icon: Icons.fingerprint, onTap: () {}),
                        ],
                      ),

                      SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Alredy have an account?'),
                          Text(
                            'Log in',
                            style: TextStyle(color: Colors.deepOrange),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget socialButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.amber.shade100,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon, size: 32, color: Colors.deepOrange),
      ),
    );
  }
}
