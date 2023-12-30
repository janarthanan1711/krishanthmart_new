import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class Loading{
  static  BuildContext? _context;

  static show(BuildContext context)async{
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        Loading._context=context;
        return  AlertDialog(
            content: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  width: 10,
                ),
                Text(AppLocalizations.of(context)!.please_wait_ucf),
              ],
            ));
      },);
  }

  static close(){
    if(Loading._context !=null) {
      Navigator.of(Loading._context!).pop();
    }
  }




  static Widget bottomLoading(bool value){
    return value? Container(
      alignment: Alignment.center,
      child: const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator()),
    ):const SizedBox(height: 5,width: 5,);
  }

}