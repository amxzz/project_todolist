import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8E4F0),
              Color(0xFFF0EDF5),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background wave shape at bottom
            Positioned(
              bottom: -50,
              left: -100,
              right: -100,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Color(0xFF4A4A5C),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(400, 150),
                    topRight: Radius.elliptical(400, 150),
                  ),
                ),
              ),
            ),
            
            // Sign up form container
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    SizedBox(height: 30),
                    
                    // Email input
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter your personal or work email...',
                          hintStyle: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    // Password input
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Enter your password...',
                          hintStyle: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    
                    // Sign up button
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle sign up
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF6B47),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    // Log in link
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Log in',
                          style: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
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