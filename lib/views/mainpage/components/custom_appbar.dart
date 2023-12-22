import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:krishanthmart_new/controllers/location_controller.dart';
import '../../../utils/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
   CustomAppBar({super.key});

  @override
  Size get preferredSize =>
       Size.fromHeight(180.h); // Adjust the height as needed
  @override

  Widget build(BuildContext context) {
    LocationController locationController = Get.put(LocationController());
    return AppBar(
      title:  Text(
        'KRISHANTHMART',
        style: TextStyle(
            color: MyTheme.black,
            fontSize: 25.sp,
            fontWeight: FontWeight.bold,),
      ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(left: 10,right: 10),
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/profile.png'),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(20.h),
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.only(left: 16.w),
              child: Obx(
                  ()=> InkWell(
                  onTap: (){
                    locationController.getUserLocation();
                  },
                  child:Row(
                    children: [
                      Text(locationController.isAddressSelected.value == false ? "Delivery Location" : locationController.currentLocation.value),
                      const Icon(Icons.arrow_drop_down_outlined)
                    ],
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(14.h),
                child: TextField(
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search....',
                      prefixIcon: Icon(Icons.search,color: MyTheme.black,),
                      suffixIcon: IconButton(
                          onPressed: () {},
                          icon:  Icon(Icons.keyboard_voice_outlined,color: MyTheme.black,))),
                ),
              ),
            ),
             Container(
               width: 350.w,
               padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Column(
                     children: [
                       Text(
                         "Free Delivery",
                         style: TextStyle(
                             color: const Color(0xFF996515),
                             fontSize: 25.sp,
                             fontWeight: FontWeight.bold,
                             fontStyle: FontStyle.italic),
                       ),
                       Text(
                         "On order above \u{20B9}99",
                         style: TextStyle(
                           color: const Color(0xFF996515),
                           fontWeight: FontWeight.bold,
                           fontSize: 8.sp
                         ),
                       ),
                     ],
                   ),
                   Text(
                     "|",
                     style: TextStyle(
                         color: const Color(0xFF996515),
                         fontSize: 30.sp,
                         fontWeight: FontWeight.bold,
                         fontStyle: FontStyle.italic),
                   ),
                   Column(
                     children: [
                       Text(
                         "Flat \u{20B9}50 off",
                         style: TextStyle(
                             color: const Color(0xFF996515),
                             fontSize: 25.sp,
                             fontWeight: FontWeight.bold,
                             fontStyle: FontStyle.italic),
                       ),
                       Text(
                         "Above \u{20B9}199 | Code: BLINK50",
                         style: TextStyle(
                           color: const Color(0xFF996515),
                           fontWeight: FontWeight.bold,
                           fontSize: 8.sp
                         ),
                       ),
                     ],
                   )
                 ],
               ),
             )
          ],
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFAE8625),
              Color(0xFFF7EF8A),
              Color(0xFFD2AC47),
            ],
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10.0),
        ),
      ),
      backgroundColor: MyTheme.noColor,
    );
  }
}
