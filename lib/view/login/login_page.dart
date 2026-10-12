import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yum_quick/view/homepage/home_page.dart';
import 'package:yum_quick/view/login/Register_page.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  final _fromkey = GlobalKey<FormState>();

  bool showpassword = false;

  bool loading = false;
  String error = "";

  Future<void> signInWithgoogle() async {
    setState(() {
      loading = true;
      error = "";
    });
    try {
      UserCredential userCredential;
      if (kIsWeb) {
        userCredential = await FirebaseAuth.instance.signInWithPopup(
          GoogleAuthProvider(),
        );
      } else {
        final GoogleSignInAccount googleuser = await GoogleSignIn.instance
            .authenticate();

        final GoogleSignInAuthentication googleAuth = googleuser.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );
      }
      final user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Restaurent')
            .doc(user.uid)
            .set({
              'RestaurentName': user.displayName ?? "",
              'Eamil': user.email ?? "",
              'UpdatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Homescreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message ?? 'Login faild';
      });
    } catch (e) {
      setState(() {
        error = 'Login faild:$e';
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> login() async {
    if (!_fromkey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
      error = "";
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homescreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message ?? 'login faild';
      });
    } catch (e) {
      setState(() {
        error = 'login faild$e';
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> forgotpassword() async {
    if (emailcontroller.text.trim().isEmpty) {
      setState(() {
        error = "Enter your email frist";
      });
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailcontroller.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset email sent")),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message ?? "something went wrong";
      });
    }
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow.shade400,
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade400,
        title: Center(
          child: Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: Icon(Icons.arrow_back_ios, color: Colors.deepOrange),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(19),
                  topRight: Radius.circular(19),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _fromkey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 15),

                        Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit,/ sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        SizedBox(height: 15),

                        Text(
                          "Email or MobileNumber",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: 10),

                        TextFormField(
                          controller: emailcontroller,
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(248, 243, 243, 148),
                            hintText: 'example@example.com',
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          textCapitalization: TextCapitalization.none,
                          obscureText: false,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'feild canot empty';
                            }
                            if (!value.contains("@")) {
                              return 'enter a vaild email';
                            }

                            return null;
                          },
                        ),

                        SizedBox(height: 13),

                        Text(
                          "passsword",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: 10),

                        TextFormField(
                          controller: passwordcontroller,
                          obscureText: !showpassword,
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(248, 243, 243, 148),
                            hintText: "**********",
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),

                            suffixIcon: IconButton(
                              icon: Icon(
                                showpassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.deepOrange,
                              ),
                              onPressed: () {
                                setState(() {
                                  showpassword = !showpassword;
                                });
                              },
                            ),
                          ),

                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'password cannot be empty';
                            }
                            if (value.length < 6) {
                              return 'password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 5),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Forget Password',
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 45),

                        Center(
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.deepOrange,
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Homescreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        const Center(
                          child: Text(
                            "or sign up with",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),

                        SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            socialButton(
                              icon: Icons.g_mobiledata,
                              onTap: signInWithgoogle,
                            ),
                            SizedBox(width: 5),

                            socialButton(icon: Icons.facebook, onTap: () {}),

                            SizedBox(width: 5),

                            socialButton(icon: Icons.fingerprint, onTap: () {}),
                          ],
                        ),

                        SizedBox(height: 15),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Regpage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.deepOrange),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      //  bottomNavigationBar: bottombar(),
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
