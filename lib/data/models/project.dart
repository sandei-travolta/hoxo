import 'package:hoxo/data/models/milestone.dart';

class Project {
  final int? id;
  final String title;
  final String description;
  final String type;
  final List<String> notes;
  final List<Milestone> milestone;
  Project({
    required this.title, 
    required this.description, 
    required this.type, 
    required this.notes, 
    required this.milestone, 
    this.id});
}