import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helse/logic/event.dart';
import 'package:helse/logic/metrics/metric_bloc.dart';

import '../../../services/swagger_generated_code/swagger.swagger.dart';

class MetricImport extends StatelessWidget {
  final List<MetricType> types;
  const MetricImport(this.types, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text("Import"),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (context) {
            return MetricBloc(types: types);
          },
          child: BlocListener<MetricBloc, MetricState>(
            listener: (context, state) {
              if (state.status == SubmissionStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('Upload Failure')),
                  );
              }
            },
            child: Form(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Text("Import external metric", style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 10),
                    _SubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MetricBloc, MetricState>(
      builder: (context, state) {
        return state.status == SubmissionStatus.inProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: state.isValid
                    ? () {
                        context.read<MetricBloc>().add(SubmittedEvent("", callback: () => Navigator.of(context).pop()));
                      }
                    : null,
                child: const Text('Submit'),
              );
      },
    );
  }
}
