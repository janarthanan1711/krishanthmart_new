import 'package:flutter/material.dart';
import '../../../utils/colors.dart';
import '../../../utils/image_directory.dart';
class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: MyTheme.white,
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: (){},
                  child: const CircleAvatar(
                    backgroundImage: AssetImage(ImageDirectory.profilePlaceHolder),
                  ),
                ),
                TextButton(
                  onPressed: (){},
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: MyTheme.grey_153,
                      fontSize: 15,
                    ),
                  ),
                ),
                const Text("|", style: TextStyle(
                  color: MyTheme.grey_153,
                  fontSize: 15,
                ),),
                TextButton(
                  onPressed: (){},
                  child: const Text(
                    'Registration',
                    style: TextStyle(
                      color: MyTheme.grey_153,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              // Handle home tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: const Text('Groceries'),
            onTap: () {
              // Handle settings tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: const Text('Dairy & Beverages'),
            onTap: () {
              // Handle home tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: const Text('Packaged Foods & Snacks'),
            onTap: () {
              // Handle home tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: const Text('Home & Kitchen'),
            onTap: () {
              // Handle home tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: const Text('Blogs'),
            onTap: () {
              // Handle home tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: const Text('Flash Sales'),
            onTap: () {
              // Handle home tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          // Add more list items as needed
        ],
      ),
    );
  }
}