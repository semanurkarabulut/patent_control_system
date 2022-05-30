class Patent {
  final String patent_number;
  final String patent_title;

  const Patent({required this.patent_number, required this.patent_title});

  factory Patent.fromJson(Map<String, dynamic> json) {
    return Patent(
      patent_number: json['patent_number'],
      patent_title: json['patent_title'],
    );
  }
}
