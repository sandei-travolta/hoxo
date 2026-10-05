import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hoxo/ui/themes/colors.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 55.0),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                   const SizedBox(height: 15.0),
                   const Text(
                    'Create Project',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text("Project Tittle",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 18.0,
                              fontWeight: .w700
                            ),
                            ),
                            TextFormField(
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
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text("Project Category",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 18.0,
                              fontWeight: .w700
                            ),
                            ),
                            DropdownButton<String>(
                              items: ['Personal',"paid"].
                              map((e)=>DropdownMenuItem(
                                value: e,
                                child: Text(e),)).toList(), 
                                onChanged: (String? value){
                                  
                                })
                          ],
                        ),
                      ),
                      
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Text("Project Description",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18.0,
                      fontWeight: .w700
                    ),
                    ),
                    const SizedBox(height: 15.0,),
                  TextFormField(
                    cursorColor: Theme.of(context).colorScheme.onSurface,
                    cursorHeight: 15.0,
                    minLines: 5,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: "Project description...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: .circular(10.0),
                        borderSide: BorderSide(
                          width: 1.0,
                          color: Theme.of(context).colorScheme.secondary
                        ),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                      hoverColor: Color(0xFFF7F7F7)
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
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
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
}