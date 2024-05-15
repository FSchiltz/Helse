
import '../services/swagger/generated_code/swagger.swagger.dart';

extension UsersHelper on UserType {
  /// Rights is just a flag and admin is true when the first bit is 1
  bool isAdmin() => ((value ?? 0).isOdd);

  bool isCare() => has(UserType.caregiver);

  bool isUser() => has(UserType.user);

  bool has(UserType enumFlag) {
    int toSearch = enumFlag.value ?? 0;
    int hay = value ?? 0;
    return (hay & toSearch) == toSearch;
  }
}
