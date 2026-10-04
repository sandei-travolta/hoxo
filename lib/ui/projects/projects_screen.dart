import 'package:flutter/material.dart';
import 'package:hoxo/ui/projects/widgets/create_project_form.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          await createProjectForm(context);
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        tooltip: "Add Project",
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.primary,
          ),
        ),  
    );
  }
}