import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:evoke_nexus_app/app/provider/authentication_provider.dart';

class LoginScreenLarge extends ConsumerStatefulWidget {
  const LoginScreenLarge({super.key});

  @override
  ConsumerState<LoginScreenLarge> createState() => _LoginScreenLargeState();
}

class _LoginScreenLargeState extends ConsumerState<LoginScreenLarge>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..addListener(() {
        setState(() {
          _opacity = _animationController!.value;
        });
      });

    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authenticationServiceProvider);

    return Scaffold(
        body: SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 2, // Set flex to 2 to occupy 2/3 of the screen
              child: Image.asset(
                'assets/images/cover.png',
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to Nexus !!!',
                    style: TextStyle(
                        fontSize: 22,
                        color: Color.fromARGB(255, 5, 14, 69),
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                      child: AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(seconds: 3),
                    child: Image.asset(
                      'assets/images/Nexus2.png',
                      height: 200,
                      width: 400,
                      fit: BoxFit.cover,
                    ),
                  )),
                  ElevatedButton(
                    onPressed: () => {authService.login(((isSucess) 
                    {
                      
                    }))},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 5, 14, 69),
                      padding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    child: const Text(
                      'Login with Evoke Credentials',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Powered by',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 5, 14, 69),
                                fontStyle: FontStyle.italic)),
                        Image.asset(
                          'assets/images/evoke_title.png',
                          height: 60,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.indigo,
                    height: 20,
                    thickness: 1,
                    indent: 20,
                    endIndent: 0,
                  ),
                  const Text(
                      'Evoke Technologies Pvt. Ltd. © 2023 All Rights Reserved.',
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 5, 14, 69),
                          fontStyle: FontStyle.italic))
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
