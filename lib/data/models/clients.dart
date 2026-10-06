class Client {
  final int? id;
  final String name;
  final String? mobile;
  final String? email;
  final String? twitter;
  final String? instagram;
  final String? facebook;
  final String? website;
  final String description;
  final List<String> notes;
  final String status;

  Client({
    required this.name, 
    this.mobile, 
    this.email, 
    this.twitter, 
    this.instagram, 
    this.facebook, 
    this.website, 
    required this.description, 
    required this.notes, 
    required this.status, 
    this.id});
}