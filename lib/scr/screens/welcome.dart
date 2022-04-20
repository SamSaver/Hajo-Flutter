import 'package:flutter/material.dart';
import 'package:flutter_app/scr/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'images/welcome.jpg',
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  // Box decoration takes a gradient
                  gradient: LinearGradient(
                    // Where the linear gradient begins and ends
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    colors: [
                      // Colors are easy thanks to Flutter's Colors class.
                      Colors.black.withOpacity(1),

                      Colors.black.withOpacity(0.9),

                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.05),
                      Colors.black.withOpacity(0.025),
                    ],
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container())),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const Text(
                "HaJo",
                textScaleFactor: 1,
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 300,
              ),
              const Text(
                "Enjoy the world",
                textScaleFactor: 1,
                style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "We will help you find the best \n experiences and adventures",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.googleLogin();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ],
      ),
    );
  }
}
