import 'package:flutter/material.dart';

Whychooseus() {
  return Container(
    color: const Color.fromARGB(255, 22, 26, 71), 
    padding: const EdgeInsets.all(20.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Why Choose Us',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(height:10),
              Text(
                '"With ChokroByte, you are not just choosing a service provider — you are choosing a partner in innovation."',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20.0),
              _buildFeatureSection('Advanced Technology Expertise',
                  'We stay ahead of the curve by leveraging the latest technologies, ensuring your business thrives in a competitive digital landscape.'),
              _buildFeatureSection('Customized Solutions',
                  'Every business is unique. We design tailored solutions to meet your specific needs and drive measurable results.'),
              _buildFeatureSection('Proven Industry Experience',
                  'With years of experience in IT services and a track record of successful projects, ChokroByte is a trusted partner for businesses of all sizes.'),
              _buildFeatureSection('Client-Centric Approach',
                  'Your success is our priority. We collaborate closely with you at every stage, ensuring transparency, efficiency, and satisfaction.'),
              _buildFeatureSection('Scalable Solutions for Growth',
                  'Our solutions are built to grow with your business, providing long-term value and adaptability.'),
              _buildFeatureSection('Dedicated Support Team',
                  'From implementation to ongoing support, our experts are always available to ensure your success.'),
            ],
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          flex: 1,
          child: Column(
            children: [
              const SizedBox(height: 150),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'See what we offer',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 146, 26, 26),
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Check out the range of services we provide, all crafted with your business in mind. Whether you are looking for innovative technology solutions or expert support, we’re here to help you navigate challenges and achieve real growth. Our team is committed to working closely with you, ensuring every solution is tailored to fit your unique needs and goals.',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w600
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(                      
                          backgroundColor: const Color.fromARGB(255, 144, 20, 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                        ),
                        child: const Text(
                          'Check Services',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildFeatureSection(String title, String description) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.yellow,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70),
          child: Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      ],
    ),
  );
}
