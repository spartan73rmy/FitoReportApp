class Token {
  String token;
  String refreshToken;
  DateTime expToken;
  Token({this.token, this.refreshToken, this.expToken});

  factory Token.fromJSON(Map<String, dynamic> item) {
    return Token(
        token: item['token'],
        refreshToken: item['refreshToken'],
        expToken: item['expirationDate']);
  }
}
