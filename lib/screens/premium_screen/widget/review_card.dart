import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 20),
            blurRadius: 40,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: avatar, stars, rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image
              const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(
                  "assets/user.png",
                ), // Replace with your image path
              ),
              const SizedBox(width: 12),

              // Star rating and number
              Expanded(
                child: Row(
                  children: [
                    ...List.generate(
                      5,
                      (index) => const Icon(
                        Icons.star,
                        color: Color(0xFFFFB800),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "5.0",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Review text
          const Text(
            "This app is very helpful! I just finished my Canadian Test today and I got 20/20. Worth the money!",
            style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
          ),
          const SizedBox(height: 16),

          // Name & location
          const Text(
            "Miriam V.",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const Text(
            "Calgary, AB",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
