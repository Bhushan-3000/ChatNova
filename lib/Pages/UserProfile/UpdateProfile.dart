import 'package:chatnova/Widget/PrimaryButton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UserUpdateProfile extends StatelessWidget {
  const UserUpdateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
  title: Text("Edit Profile",style: TextStyle(color: Colors.black),),
  backgroundColor: Theme.of(context).colorScheme.primaryContainer,

),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          child:Row(
            children: [
        Expanded(child: Column(
          children: [
            Container(
              width: 200,
              height: 200,
              child: Center(child: Icon(Icons.image,size: 40,),),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            SizedBox(height: 20,),
                Text("Personal Info",style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.blueGrey),
                ),
            SizedBox(height: 20,),
            Row(
              children: [
                Text("Name",style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey),
                ),],
            ),
            SizedBox(height: 10,),
            TextFormField(
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: "Bhushan Kumbhar",
                prefixIcon: Icon(Icons.person, color: Colors.black), // Icon color
                filled: true, // Enables background color
                fillColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.1), // Custom background color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded shape
                  borderSide: BorderSide.none, // Removes border
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Padding inside field
                hintStyle: TextStyle(color: Colors.black), // Hint text color
              ),
              style: TextStyle(color: Colors.white), // Input text color
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Text("Email Id",style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey),
                ),],
            ),
            SizedBox(height: 10,),
            TextFormField(
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: "Example@gmail.com",
                prefixIcon: Icon(Icons.alternate_email_rounded, color: Colors.black), // Icon color
                filled: true, // Enables background color
                fillColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.1), // Custom background color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded shape
                  borderSide: BorderSide.none, // Removes border
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Padding inside field
                hintStyle: TextStyle(color: Colors.black), // Hint text color
              ),
              style: TextStyle(color: Colors.white), // Input text color
            ),

            SizedBox(height: 20,),
            Row(
              children: [
                Text("Phone Number",style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueGrey),
                ),],
            ),
            SizedBox(height: 10,),
            TextFormField(
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: "1800xxx000",
                prefixIcon: Icon(Icons.alternate_email_rounded, color: Colors.black), // Icon color
                filled: true, // Enables background color
                fillColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.1), // Custom background color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded shape
                  borderSide: BorderSide.none, // Removes border
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Padding inside field
                hintStyle: TextStyle(color: Colors.black), // Hint text color
              ),
              style: TextStyle(color: Colors.white), // Input text color
            ),
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PrimaryButton(btnName: "Save", icon: Icons.save, ontap: (){},),
              ],
            ),

          ],
        ),
        ),
            ],
          ),
        ),
          ],
        ),
      ),
    );
  }
}
