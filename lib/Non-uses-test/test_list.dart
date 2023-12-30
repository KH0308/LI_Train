import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostApi extends StatefulWidget {
  const PostApi({super.key});

  @override
  State<PostApi> createState() => _PostApi();
}

class _PostApi extends State<PostApi> {
  
  Future submitData(String name, String description) async{
  
  var response =  await http.post(Uri.parse('https://tarsoft.com.my/api/v1/categories'), 
  headers: {'Accept':'application/json'},
    body:{ "name" : name, 'description' :  description});
  var data =  response.body;
  print(data);

  if(response.statusCode ==  201){
    // String responseString = response.body;
    // dataModelFromJson(responseString);
  }
  else {
    return null;
  }
}

  TextEditingController nameController =  TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('hello'),
      ),
    body: 
    Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: 'Enter name'),
          controller: nameController,
          ),
          const SizedBox(height: 10,),
          TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: 'Enter description'),
          controller: descriptionController,
          ),
          ElevatedButton(onPressed: () {
            
             submitData (nameController.text, descriptionController.text);

            // setState(() {
            //   _dataModel = data;
            // });

          }, child: const Text("Submit"))
      ],
    ),
    );
  }
}