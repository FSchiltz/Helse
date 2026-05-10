import 'package:flutter/material.dart';
import 'package:helse/ui/blocs/care/patients_card.dart';

import '../../../logic/d_i.dart';
import '../../../services/swagger/generated_code/helseapi.swagger.dart';
import '../../common/loader.dart';
import 'patient_add.dart';

class Patients extends StatefulWidget {
  const Patients({super.key});

  @override
  State<Patients> createState() => _PatientsState();
}

class _PatientsState extends State<Patients> {
  List<Person>? _patients;

  @override
  void initState() {
    super.initState();
  }

  void _resetPatients() {
    setState(() {
      _patients = null;
    });
    _getData();
  }

  Future<List<Person>?> _getData() async {
    if (_patients != null) {
      _patients = List<Person>.empty();
      return _patients;
    }

    _patients = await DI.user.patients();
    return _patients;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return FutureBuilder(
      future: _getData(),
      builder: (ctx, snapshot) {
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
            // Extracting data from snapshot object
            final persons = snapshot.data as List<Person>;
            final cards = persons
                .map((p) => PatientsCard(p, _resetPatients))
                .toList();

            return SizedBox(
              width: 320,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Patients",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return PatientAdd(_resetPatients);
                            },
                          );
                        },
                        icon: const Icon(Icons.add_sharp),
                        iconSize: 35,
                        color: theme.primary,
                      ),
                    ],
                  ),
                  ListView(shrinkWrap: true, children: cards),
                ],
              ),
            );
          }
        }
        return const Center(
          child: SizedBox(width: 50, height: 50, child: HelseLoader()),
        );
      },
    );
  }
}
