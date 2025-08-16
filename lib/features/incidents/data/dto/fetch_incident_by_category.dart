class CategoryDto {
  final String category;

  CategoryDto({required this.category});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'category': category};
  }
}
