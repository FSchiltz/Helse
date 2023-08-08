import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import 'patient_add.dart';

class Patients extends StatefulWidget {
  const Patients({super.key});

  @override
  State<Patients> createState() => _PatientsState();
}

class _PatientsState extends State<Patients> {
  late List<Person>? _patients = null;

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

    _patients = await AppState.personsLogic?.getPatients();
    return _patients;
  }

  @override
  Widget build(BuildContext context) {
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
                  .map((p) => Card(
                        child: Row(
                          children: [Text(p.name ?? ""), Text(p.surname ?? ""), ElevatedButton(onPressed: () {}, child: Text("view"))],
                        ),
                      ))
                  .toList();
              cards.add(Card(
                child: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return PatientAdd(_resetPatients);
                          });
                    },
                    icon: const Icon(Icons.add_sharp)),
              ));

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Patients", style: Theme.of(context).textTheme.displaySmall),
                    Expanded(
                      child: GridView.extent(
                        shrinkWrap: true,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                        maxCrossAxisExtent: 180.0,
                        children: cards,
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return const Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator()));
        });
  }
}
