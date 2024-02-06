import 'package:flutter/material.dart';

class CustomSearchContainer extends StatelessWidget {
  const CustomSearchContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Row(
        children: [
           const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter text',
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                // Perform search action here
                print('Search button pressed');
              },
            ),
          ),
        ],
      ),
    );
  }
}
