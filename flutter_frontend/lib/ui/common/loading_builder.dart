import 'package:flutter/material.dart';
import 'package:helse/ui/common/loader.dart';

class LoadingBuilder<T> extends StatefulWidget {
  final Future<T> Function(bool refresh) getData;
  final Widget Function(BuildContext context, T data, void Function() callback)
  builder;
  const LoadingBuilder(this.getData, {super.key, required this.builder});

  @override
  State<LoadingBuilder<T>> createState() => _LoadingBuilderState<T>();
}

class _LoadingBuilderState<T> extends State<LoadingBuilder<T>> {
  bool _refresh = false;

  void reset() {
    setState(() {
      _refresh = !_refresh;
    });
  }

  @override
  Widget build(Object context) {
    return FutureBuilder<T>(
      future: widget.getData(_refresh),
      builder: (context, snapshot) {
        // Checking if future is resolved
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: const TextStyle(fontSize: 18),
              ),
            );
            // if we got our data
          } else if (snapshot.hasData) {
            return widget.builder(context, snapshot.requireData, reset);
          }
        }
        return const Center(
          child: SizedBox(width: 50, height: 50, child: HelseLoader()),
        );
      },
    );
  }
}
