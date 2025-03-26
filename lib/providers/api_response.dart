class ApiResponse {
  final String apiUsername;
  final String apiEmail;
  final String apiUserId;
  final String apiTownship;
  final String token;

  ApiResponse({
    required this.apiUsername,
    required this.apiEmail,
    required this.apiUserId,
    required this.apiTownship,
    required this.token,
  });

  // Add factory constructor or other methods if needed
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      apiUsername: json['username'] ?? '',
      apiEmail: json['email'],
      apiUserId: json['userId'],
      apiTownship: json['township'],
      token: json['token'],
    );
}
  // Convert object to JSON (useful for saving to SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'api_user_id': apiUserId,
      'api_username': apiUsername,
      'api_email': apiEmail,
      'api_township': apiTownship,
      'token' : token,
    };
  }
}