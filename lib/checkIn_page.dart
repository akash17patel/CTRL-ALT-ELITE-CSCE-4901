
import 'package:flutter/material.dart';

class CheckInPage extends StatefulWidget {
  //const CheckInPage({super.key});
  final String title;

  const CheckInPage({super.key, required this.title});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  
  bool isEmotionOpened = false;
  bool isNotesOpened = false;

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Check In Page'),
        centerTitle: true,
      ),
      body:Container(
        height: double.infinity, width: double.infinity,color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            const SizedBox(height:200),
           InkWell(
            onTap:(){
              print('12345');
              setState(() {
                isEmotionOpened = !isEmotionOpened;
                
              });
              
            },
            child: Container(height:60,width:200,color: Colors.grey, child:const Center(child: Text('Emotion Selection')))),
           const SizedBox(height: 15,),
           
          isEmotionOpened == true? const TextField():const SizedBox(),
           const SizedBox(height: 15,),
        
           GestureDetector(
            onTap: () {
              print ('1223445');
              setState(() {
                isNotesOpened = !isNotesOpened;
        
              });
              
            },
            child: Container(height:60,width:200,color: Colors.grey, child:const Center(child: Text('Notes/Comments')))),
            const SizedBox(height: 15,),
           
          isNotesOpened == true? const TextField():const SizedBox(),
           const SizedBox(height: 50,),
        
           InkWell(
            onTap: () {
              showDialog(context: context, builder: (context){
                return AlertDialog(title: const Text('Are You Sure?'),content: Column(
                  mainAxisSize: MainAxisSize.min,
                  
                  children: [
                  ElevatedButton(onPressed: (){}, child: const Text('Yes')),
                   ElevatedButton(onPressed: (){}, child: const Text('No')),
                ]),);
              });
            },
            
            child: Container(height:60,width:200,color: Colors.red, child:const Center(child: Text('Confirm'))))
        
          
          ],),
        ),
      ) ,
    );
  }
}