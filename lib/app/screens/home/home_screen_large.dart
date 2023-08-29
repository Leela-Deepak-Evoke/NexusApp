import 'package:flutter/material.dart';
import 'package:evoke_nexus_app/app_router.dart';

class HomeScreenLarge extends StatelessWidget {
  const HomeScreenLarge({super.key});
  @override
  Widget build(BuildContext context) {
    // Obtain the screen size using MediaQuery
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Card(
          margin: const EdgeInsets.all(20.0),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Message
                const Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Paragraph about the application
                const Text(
                  'This application provides a wide range of features that are designed to enhance your experience. Navigate through and explore all the amazing functionalities!',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),

                // Rows
                const Row(
                  children: <Widget>[
                    Expanded(child: Text('Row 1')),
                    Expanded(child: Text('Row 2')),
                    Expanded(child: Text('Row 3')),
                  ],
                ),
                const SizedBox(height: 20),

                // Button at the bottom
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: _handleContinue,
                    child: const Text('Continue...'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleContinue() {
    router.go('feeds');
  }
}
