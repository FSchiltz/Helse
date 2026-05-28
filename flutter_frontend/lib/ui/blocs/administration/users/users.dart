import 'package:flutter/material.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/ui/blocs/administration/users/delete_user.dart';
import 'package:helse/ui/common/loading_builder.dart';

import '../../../../services/swagger/generated_code/helseapi.swagger.dart';
import 'user_add.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  Future<List<Person>> _getData(bool reset) async {
    return await Dependencies.services.user.persons() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return LoadingBuilder(
      _getData,
      builder: (context, data, reset) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  "Users",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return UserAdd(reset);
                      },
                    );
                  },
                  icon: const Icon(Icons.add_sharp),
                ),
              ],
            ),
            SingleChildScrollView(
              child: FittedBox(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Expanded(child: Text("Id"))),
                    DataColumn(label: Expanded(child: Text("Type"))),
                    DataColumn(label: Expanded(child: Text("Username"))),
                    DataColumn(label: Expanded(child: Text("Email"))),
                    DataColumn(label: Expanded(child: Text("Name"))),
                    DataColumn(label: Expanded(child: Text("Surname"))),
                    DataColumn(label: Expanded(child: Text(""))),
                  ],
                  rows: data
                      .where((user) => user.types?.isEmpty == false)
                      .map(
                        (user) => DataRow(
                          cells: [
                            DataCell(Text(user.id.toString())),
                            DataCell(
                              Text(
                                user.types?.map((x) => x.name).join(';') ?? '0',
                              ),
                            ),
                            DataCell(Text(user.userName ?? "")),
                            DataCell(Text(user.email ?? "")),
                            DataCell(Text(user.name ?? "")),
                            DataCell(Text(user.surname ?? "")),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return UserAdd(reset, edit: user);
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.edit_sharp),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return DeleteUser(() async {
                                            await Dependencies.services.user.deletePerson(
                                              user.id,
                                            );
                                            reset();
                                          }, person: user);
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.delete_sharp),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
