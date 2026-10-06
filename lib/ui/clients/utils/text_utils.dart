String initial(String name) =>
    name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();