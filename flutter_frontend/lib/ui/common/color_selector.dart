import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:helse/helpers/translation.dart';
import 'package:helse/ui/common/square_button.dart';

class ColorSelector extends StatefulWidget {
  const ColorSelector({
    super.key,
    required this.color,
    required this.context,
    required this.callback,
  });

  final Color color;
  final BuildContext context;
  final void Function(Color value) callback;

  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  Color? _color;

  @override
  void initState() {
    _color = widget.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locale = Translation.of(context);
    return InkWell(
      child: Container(color: _color),
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (x) => AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: _color ?? Colors.red,
                onColorChanged: (value) {
                  setState(() {
                    _color = value;
                  });
                  widget.callback(value);
                },
              ),
              // Use Material color picker:
              //
              // child: MaterialPicker(
              //   pickerColor: pickerColor,
              //   onColorChanged: changeColor,
              //   showLabel: true, // only on portrait mode
              // ),
              //
              // Use Block color picker:
              //
              // child: BlockPicker(
              //   pickerColor: currentColor,
              //   onColorChanged: changeColor,
              // ),
              //
              // child: MultipleChoiceBlockPicker(
              //   pickerColors: currentColors,
              //   onColorsChanged: changeColors,
              // ),
            ),
            actions: <Widget>[
              SquareButton(locale.ok, () => Navigator.of(context).pop()),
            ],
          ),
        );
      },
    );
  }
}
