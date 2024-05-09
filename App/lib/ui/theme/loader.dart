import 'package:flutter/material.dart';

class HelseLoader extends StatefulWidget {
  final bool static;
  final Color? color;

  const HelseLoader({super.key, this.static = false, this.color});

  @override
  State<HelseLoader> createState() => HelseLoaderState();
}

class HelseLoaderState extends State<HelseLoader> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..forward()
      ..repeat(reverse: true);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = widget.color ?? Theme.of(context).colorScheme.secondary;
    return Container(
        alignment: Alignment.center,
        child: FadeTransition(
          opacity: TweenSequence([
            TweenSequenceItem<double>(
              tween: Tween<double>(begin: widget.static ? 1 : 0, end:  1).chain(CurveTween(curve: Curves.easeInOut)),
              weight: 1,
            ),
          ]).animate(controller),
          child: IconButton(
            color: theme,
            icon: const Icon(Icons.favorite),
            iconSize: 40,
            onPressed: () {},
          ),
        ));
  }
}
