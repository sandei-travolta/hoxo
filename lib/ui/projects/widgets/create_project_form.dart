import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hoxo/ui/themes/colors.dart';

Future<void> createProjectForm(BuildContext context){
  String value="Personal";
  return showDialog(
    context: context, 
    builder: (context){
      return StatefulBuilder(
        builder: (context,setState){ 
          return Dialog(
          child: Container(
                width: MediaQuery.of(context).size.width*0.6,
                height: MediaQuery.of(context).size.height*0.6,
                padding: const EdgeInsets.symmetric(horizontal: 55.0,vertical: 25.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text("Project Tittle",
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: .w700
                                ),
                                ),
                                const SizedBox(height: 10.0),
                                TextFormField(
                                  cursorColor: Theme.of(context).colorScheme.onSurface,
                                  decoration: InputDecoration(
                                    hintText: "Project Tittle",
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 0.8,
                                        color: Theme.of(context).colorScheme.secondary
                                      )
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1.0,
                                        color: Theme.of(context).colorScheme.onSurface
                                      ),
                                      borderRadius: .circular(10.0)
                                    )
                                  ),
                                  
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 100.0),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text("Category",
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: .w700
                                ),
                                ),
                                const SizedBox(height: 10.0),
                                DropdownButtonFormField<String>(
                                initialValue: value,
                                isExpanded: true,
                                borderRadius: BorderRadius.circular(10.0),
                                dropdownColor: Theme.of(context).colorScheme.surface,
                                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      fontSize: 14.0,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 14.0,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      width: 1.0,
                                      color: Theme.of(context).colorScheme.onSurface,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      width: 1.0,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                ),
                                items: ['Personal', 'Paid']
                                    .map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ))
                                    .toList(),
                                onChanged: (String? selected) {
                                  setState(() {
                                    value = selected!;
                                  });
                                },
                              ),
                              ],
                            ),
                          ),
                          
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Text("Project Description",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 14.0,
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
                      const SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: (){
                                            
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: .circular(8.0)
                              )
                            ),
                            child: Text("Save Project")),
                            ElevatedButton(
                        onPressed: (){
                            context.pop();            
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: .circular(8.0)
                          )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 2.0),
                          child: Text("Cancle"),
                        ))
                        ],
                      ),
                        
                    ],
                  ),
                ),
              ),
        );
        }
      );
    });
}