
import 'package:flutter/material.dart';

class RoundedActionView extends StatelessWidget {
  Function() onPressed;
  final String title;

  RoundedActionView({super.key,required this.onPressed ,required this.title});
  
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: 
      Center(
        child: SizedBox(
          height: 30,
          width: 150,
          child: 
          InkWell(
             onTap:() {
               onPressed();
             },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), // Adjust the radius to make it rounded
              border: Border.all(
                color: Colors.white, // Set your desired border color
                width: 2.0, // Set your desired border width
              ),
              
          ),
            child: Center(
             child:   Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white
              ),

            )
            )

          )

        ),
      )
      )
    );
    
   
  }
}