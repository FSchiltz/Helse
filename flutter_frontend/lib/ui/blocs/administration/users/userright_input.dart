import 'package:flutter/material.dart';
import 'package:helse/services/swagger/generated_code/helseapi.enums.swagger.dart';

class UserRightInput extends StatelessWidget {
  final List<UserType> types;
  final void Function(List<UserType>) callback;
  final String? label;
  final List<UserType> value;

  const UserRightInput(
    this.types,
    this.callback, {
    super.key,
    this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: types.map((hobby) {
        bool isSelected = false;
        if (value.contains(hobby)) {
          isSelected = true;
        }
        return GestureDetector(
          onTap: () {
            if (!value.contains(hobby)) {
              if (value.length < 5) {
                value.add(hobby);
                callback(value);
              }
            } else {
              value.removeWhere((element) => element == hobby);
              callback(value);
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: isSelected ? 4 : 5,
              vertical: 4,
            ),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
            decoration: BoxDecoration(
              color: theme.onPrimary,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isSelected ? theme.primary : theme.inversePrimary,
                width: isSelected ? 3 : 2,
              ),
            ),
            child: Text(
              hobby.name,
              style: TextStyle(
                color: isSelected ? theme.primary : theme.inversePrimary,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
