import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'About developers',
          style: TextStyle(
            fontSize: 25,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: <Color>[Colors.cyanAccent, Colors.purpleAccent],
              ).createShader(
                Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
              ),
          ),
        ),
        Image.asset('assets/Images/Developers.png'),
        TextButton.icon(
          onPressed: () async {
            String _url = 'https://github.com/team-Homo-Novus/';
            await canLaunch(_url)
                ? await launch(_url)
                : ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      elevation: 6,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 3),
                      content: Text('Failed to launch $_url'),
                    ),
                  );
          },
          icon: CircleAvatar(
            maxRadius: 15,
            backgroundImage: AssetImage('assets/Images/icon.jpg'),
          ),
          label: Text(
            'Visit us!',
            style: TextStyle(fontSize: 25),
          ),
        )
      ],
    );
  }
}
