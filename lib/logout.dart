import 'package:flutter/material.dart';

class LogOutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D2D2D),
      appBar: AppBar(
        backgroundColor: Color(0xFF2D2D2D),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Log Out',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background dengan efek wave di bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              child: CustomPaint(
                painter: WavePainter(),
                size: Size(double.infinity, 200),
              ),
            ),
          ),
          
          // Main content
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              padding: EdgeInsets.all(32),
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
                children: [
                  // Logout Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: CustomPaint(
                        painter: LogoutIconPainter(),
                        size: Size(40, 40),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Question text
                  Text(
                    'Are you sure?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  
                  SizedBox(height: 32),
                  
                  // Buttons
                  Row(
                    children: [
                      // Yes button
                      Expanded(
                        child: Container(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle logout logic here
                              _showLogoutConfirmation(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF4A5568),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(width: 16),
                      
                      // No button
                      Expanded(
                        child: Container(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFE53E3E),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'No',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    // Simulate logout process
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logging out...'),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Please wait'),
            ],
          ),
        );
      },
    );

    // Simulate logout delay
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close loading dialog
      Navigator.of(context).pop(); // Close logout screen
      // Navigate to login screen or show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully logged out'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }
}

// Custom painter for logout icon
class LogoutIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF4A5568)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final width = size.width;
    final height = size.height;

    // Draw rounded rectangle (door)
    final doorRect = RRect.fromLTRBR(
      width * 0.1,
      height * 0.1,
      width * 0.6,
      height * 0.9,
      Radius.circular(8),
    );
    canvas.drawRRect(doorRect, paint);

    // Draw arrow
    final arrowPaint = Paint()
      ..color = Color(0xFF4A5568)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Arrow line
    canvas.drawLine(
      Offset(width * 0.4, height * 0.5),
      Offset(width * 0.85, height * 0.5),
      arrowPaint,
    );

    // Arrow head
    canvas.drawLine(
      Offset(width * 0.75, height * 0.35),
      Offset(width * 0.85, height * 0.5),
      arrowPaint,
    );
    canvas.drawLine(
      Offset(width * 0.75, height * 0.65),
      Offset(width * 0.85, height * 0.5),
      arrowPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for wave effect
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF4A5568).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Create wave shape
    path.moveTo(0, size.height * 0.3);
    
    // First wave
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.1,
      size.width * 0.5, size.height * 0.3,
    );
    
    // Second wave
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.5,
      size.width, size.height * 0.3,
    );
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
    
    // Add second layer for depth
    final paint2 = Paint()
      ..color = Color(0xFF4A5568).withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    final path2 = Path();
    path2.moveTo(0, size.height * 0.5);
    
    path2.quadraticBezierTo(
      size.width * 0.3, size.height * 0.2,
      size.width * 0.6, size.height * 0.4,
    );
    
    path2.quadraticBezierTo(
      size.width * 0.8, size.height * 0.6,
      size.width, size.height * 0.4,
    );
    
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogOutScreen()),
            );
          },
          child: Text('Open Logout Screen'),
        ),
      ),
    );
  }
}