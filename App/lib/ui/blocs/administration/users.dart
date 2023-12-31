import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../services/swagger/generated_code/swagger.swagger.dart';
import '../loader.dart';
import 'user_add.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  List<Person>? _users;

  void _resetUsers() {
    setState(() {
      _users = null;
      _dummy = !_dummy;
    });
  }

  bool _dummy = false;

  Future<List<Person>?> _getData(bool reset) async {
    // if the users has not changed, no call to the backend
    if (_users != null) return _users;

    _users = await AppState.authenticationLogic?.getUsers();
    return _users;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getData(_dummy),
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
              // Extracting data from snapshot object
              final users = snapshot.data as List<Person>;
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text("User management", style: Theme.of(context).textTheme.displaySmall),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return UserAdd(_resetUsers);
                                    });
                              },
                              icon: const Icon(Icons.add_sharp)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            DataTable(
                              columns: const [
                                DataColumn(
                                    label: Expanded(
                                  child: Text("Type"),
                                )),
                                DataColumn(
                                    label: Expanded(
                                  child: Text("Username"),
                                )),
                                DataColumn(
                                    label: Expanded(
                                  child: Text("Email"),
                                )),
                                DataColumn(
                                    label: Expanded(
                                  child: Text("Name"),
                                )),
                                DataColumn(
                                    label: Expanded(
                                  child: Text("Surname"),
                                )),
                                DataColumn(
                                    label: Expanded(
                                  child: Text("Rights"),
                                ))
                              ],
                              rows: users
                                  .map((user) => DataRow(cells: [
                                        DataCell(Text((user.type ?? UserType.user).toString())),
                                        DataCell(Text(user.userName ?? "")),
                                        DataCell(Text(user.email ?? "")),
                                        DataCell(Text(user.name ?? "")),
                                        DataCell(Text(user.surname ?? "")),
                                        DataCell(Text(user.rights.toString()))
                                      ]))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
          return const Center(child: SizedBox(width: 50, height: 50, child: HelseLoader()));
        });
  }
}
