class FeedbackModel {
  final String? id;
  final String customerEmail;
  final String feedback;

  FeedbackModel({
    this.id,
    required this.customerEmail,
    required this.feedback,
  });

  // Convert Feedback object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerEmail': customerEmail,
      'feedback': feedback,
    };
  }

  // Convert JSON to Feedback object
  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      customerEmail: json['customerEmail'],
      feedback: json['feedback'],
    );
  }
}
