import 'package:flutter/material.dart';

class FacilitiesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            'Our Facilities',
            style: TextStyle(
              fontSize: 40,
              color: Color.fromARGB(255, 130, 44, 37),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFacilityIcon('assets/earth.png'),
            _buildFacilityIcon('assets/credit-card.png'),
            _buildFacilityIcon('assets/problem-solving.png'),
            _buildFacilityIcon('assets/24-hours.png'),
            _buildFacilityIcon('assets/code.png'),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            SizedBox(width: 110),
            _buildFacilityText('World-Wide Service'),
            SizedBox(width: 110),
            _buildFacilityText('Secure Payment'),
            SizedBox(width: 140),
            _buildFacilityText('Solution'),
            SizedBox(width: 165),
            _buildFacilityText('24/7 Support'),
            SizedBox(width: 125),
            _buildFacilityText('Best Service'),
          ],
        ),
        SizedBox(height: 17),
        Row(
          children: [
            SizedBox(width: 90),
            Center(
              child: Container(
                height: 60,
                width: 220,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    text: 'We provide our service to clients all over the world',
                  ),
                ),
              ),
            ),
            SizedBox(width: 50),
            Center(
              child: Container(
                height: 60,
                width: 220,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    text: 'Pay with popular and secure payment methods',
                  ),
                ),
              ),
            ),
            SizedBox(width: 30),
            Center(
              child: Container(
                height: 60,
                width: 220,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      
                    ),
                    text: 'Solution for every time of bussiness',
                  ),
                ),
              ),
            ),
            SizedBox(width: 42),
            Center(
              child: Container(
                height: 60,
                width: 220,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      
                    ),
                    text: 'We are always here to help you',
                  ),
                ),
              ),
            ),
            SizedBox(width: 30),
            Center(
              child: Container(
                height: 60,
                width: 220,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      
                    ),
                    text: 'We provide with best professionals',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFacilityIcon(String imagePath) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
        ),
      ),
    );
  }

  Widget _buildFacilityText(String text) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Color.fromARGB(255, 130, 44, 37),
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        text: text,
      ),
    );
  }
}
