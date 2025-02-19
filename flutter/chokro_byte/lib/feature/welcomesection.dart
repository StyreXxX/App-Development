import 'package:flutter/material.dart';

class WelcomeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage('assets/chokrobyte.jpg'),
            ),
          ),
        ),
        SizedBox(width: 40),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Welcome to ChokroByte",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Transforming Vision into Code",
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 130, 44, 37),
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500),
                              children: [
                                TextSpan(
                                  text: "ChokroByte",
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 158, 24, 15)),
                                ),
                                TextSpan(
                                    text:
                                        " is a software development company that specializes in "
                                        "developing web and mobile applications. We are a team of highly skilled "
                                        "developers who are passionate about technology, growth, and innovation. Our mission is to help businesses turn their ideas into digital realities "
                                        "by providing them with "),
                                TextSpan(
                                  text: "high-quality software solution ",
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 158, 24, 15)),
                                ),
                                TextSpan(
                                    text:
                                        "that are tailored to their specific needs. Whether you need a website, a mobile app, or a custom software solution, we have the expertise"
                                        "and experience to bring your vision to life. Let us help you transform your vision into code and take your bussiness to next level")
                              ],
                            ),
                          ),
                        ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  height: 75,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 130, 44, 37),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
