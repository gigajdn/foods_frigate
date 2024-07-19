import 'package:flutter/material.dart';

class SimpleHeader extends StatefulWidget {
  final String userPhoto;
  final VoidCallback toggleSettings;

  SimpleHeader({required this.userPhoto, required this.toggleSettings});

  @override
  _SimpleHeaderState createState() => _SimpleHeaderState();
}

class _SimpleHeaderState extends State<SimpleHeader> {
  bool introOpen = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildTriangle(),
        _buildQuestion(),
        _buildIntroBlock(),
        _buildHeadWrapper(),
      ],
    );
  }

  Widget _buildTriangle() {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        width: 0,
        height: 0,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 45, color: Theme.of(context).primaryColor),
            right: BorderSide(width: 45, color: Colors.transparent),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    return Positioned(
      top: 0,
      left: 0,
      child: GestureDetector(
        onTap: () {
          setState(() {
            introOpen = !introOpen;
          });
          _adjustBodyMargin();
        },
        child: Container(
          width: 50,
          height: 50,
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 7),
            child: Text(
              'i',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _adjustBodyMargin() {
    // Adjust the body margin as needed
    // Note: This is a placeholder and should be implemented as per Flutter app structure
  }

  Widget _buildIntroBlock() {
    return Positioned(
      top: introOpen ? 40 : -40,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border(
            bottom: BorderSide(color: Theme.of(context).scaffoldBackgroundColor, width: 3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Text(
                'by ',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              ),
              GestureDetector(
                onTap: () => _launchURL('https://basinbald.com'),
                child: Text(
                  'Bumhan Yu',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    fontFamily: 'Raleway',
                  ),
                ),
              ),
              Text(
                ' \u2022 ',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              ),
              GestureDetector(
                onTap: () => _launchURL('https://github.com/baadaa/remember-fridge-react'),
                child: Text(
                  'GitHub',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    fontFamily: 'Raleway',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) {
    // Implement URL launch logic using url_launcher package
  }

  Widget _buildHeadWrapper() {
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'My Fridge',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: widget.toggleSettings,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.userPhoto),
                  radius: 22.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
