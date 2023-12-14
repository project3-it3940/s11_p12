import 'package:flutter/material.dart';
import 'package:flutter_app/database_service.dart';
import 'package:flutter_app/user.model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DataBaseService dataBaseService = DataBaseService();
  TextEditingController idEditingController = TextEditingController();
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController ageEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<UserModel> users = [];

  @override
  void initState() {
    dataBaseService
        .getUsers()
        .then((userModels) => users = userModels)
        .catchError(
            (error) => print("${DateTime.now()}-error-${error.toString()}"));
    super.initState();
  }

  void restartUser() async {
    final newUsers = await dataBaseService.getUsers();
    if (mounted) {
      setState(() {
        users = newUsers;
      });
    }
  }

  void update(
      String id, String name, String email, String age, BuildContext context) {
    nameEditingController.text = name;
    emailEditingController.text = email;
    ageEditingController.text = age;
    showModalBottomSheet(
        context: context,
        constraints: const BoxConstraints(minHeight: 0),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Column(
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFormField(
                          controller: nameEditingController,
                          decoration: const InputDecoration(
                            label: Text("Fullname"),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter fullname";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: emailEditingController,
                          decoration: const InputDecoration(
                            label: Text("Email"),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter email";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: ageEditingController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text("Age"),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter age";
                            }
                            return null;
                          },
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final user = UserModel(
                                    id: id,
                                    name: nameEditingController.text,
                                    email: emailEditingController.text,
                                    age: int.parse(ageEditingController.text));
                                await dataBaseService.editUser(user);
                                Navigator.of(context).pop();
                                restartUser();
                              }
                            },
                            child: Text("Update user"))
                      ],
                    ))
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Flutter Demo",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SizedBox(
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ...users.map((user) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name),
                        Text(user.email),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            update(user.id, user.name, user.email,
                                user.age.toString(), context);
                          },
                          child: const Icon(Icons.edit),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            await dataBaseService.deleteUser(user.id);
                            restartUser();
                          },
                          child: const Icon(Icons.delete),
                        ),
                      ],
                    )
                  ],
                ),
              ))
        ])),
      ),
      floatingActionButton: ElevatedButton(
        child: const Text("Add User"),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            constraints: const BoxConstraints(minHeight: 0),
            builder: (context) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Column(
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextFormField(
                              controller: idEditingController,
                              decoration: const InputDecoration(
                                label: Text("Id"),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter id";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: nameEditingController,
                              decoration: const InputDecoration(
                                label: Text("Fullname"),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter fullname";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: emailEditingController,
                              decoration: const InputDecoration(
                                label: Text("Email"),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter email";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: ageEditingController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                label: Text("Age"),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter age";
                                }
                                return null;
                              },
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final user = UserModel(
                                        id: idEditingController.text,
                                        name: nameEditingController.text,
                                        email: emailEditingController.text,
                                        age: int.parse(
                                            ageEditingController.text));
                                    await dataBaseService.insertUser(user);
                                    Navigator.of(context).pop();
                                    restartUser();
                                  }
                                },
                                child: Text("Add user"))
                          ],
                        ))
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
