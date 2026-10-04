import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

Future<void> createProjectForm(BuildContext context){
  return showDialog(
    context: context, 
    builder: (context){
      return Dialog(
        child: Stack(
          children: [
            Positioned(
              top: 5,
              right: 7,
              child: IconButton(
                onPressed: (){
                  context.pop();
                }, 
                icon: Icon(Icons.cancel_outlined)
                )),
            Container(
              width: MediaQuery.of(context).size.width*0.6,
              height: MediaQuery.of(context).size.height*0.6,
              child: Column(
                children: [
                   const SizedBox(height: 15.0),
                   const Text(
                    'Create Project',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 55.0),
                    child: TextFormField(
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                      decoration: InputDecoration(
                        hintText: "Project Tittle",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Theme.of(context).colorScheme.onSurface
                          )
                        )
                      ),
                      
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 55.0),
                    child: TextFormField(
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                      minLines: 5,
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: "Project description...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: .circular(10.0),
                          borderSide: BorderSide(
                            width: 2.0,
                            color: Theme.of(context).colorScheme.onSurface
                          )
                        )
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: Align(
                      alignment: .centerRight,
                      child: ElevatedButton(
                        onPressed: (){

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: .circular(8.0)
                          )
                        ),
                        child: Text("Save Project")),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
}