import 'package:flutter/material.dart';

import 'custom_toolbar_shape.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height = 80;
  final PopupMenuButton<int>? actions;
  final Widget title;
  final Widget? child;

  const CustomAppBar({super.key, required this.title, this.actions, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
          color: Colors.transparent,
          child: Stack(fit: StackFit.loose, children: <Widget>[
            Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                height: height,
                child: CustomPaint(
                  painter: CustomToolbarShape(theme: Theme.of(context).colorScheme),
                )),
            Align(
                alignment: const Alignment(0.0, 2.8),
                child: Container(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20.0,
                          // shadow
                          spreadRadius: .5,
                          // set effect of extending the shadow
                          offset: Offset(
                            0.0,
                            5.0,
                          ),
                        )
                      ],
                    ),
                    child: child,
                  ),
                )),
            Align(alignment: Alignment.topCenter, child: title),
            Align(alignment: Alignment.topRight, child: actions),
          ])),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
