import 'package:hoxo/data/models/milestone.dart';

class Project {
  final String title;
  final String description;
  final String type;
  final List<String> notes;
  final Milestone milestone;
  Project({required this.title, required this.description, required this.type, required this.notes, required this.milestone});
}