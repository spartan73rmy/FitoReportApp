import '../CommonWidgets/loadingScreen.dart';
import '../Models/user.dart';
import '../Services/auth.dart';
import '../Services/UserService.dart';
import '../User/aproveUser.dart';
import '../User/register.dart';
import '../CommonWidgets/deleteDialog.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/APIResponse.dart';

class ListUsers extends StatefulWidget {
  const ListUsers({super.key});

  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  bool _isLoading = false;
  late APIResponse<List<User>> res;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences _sharedPreferences;

  UserService get service => GetIt.I<UserService>();
  @override
  void initState() {
    _fetchUsers();
    super.initState();
  }

  _fetchUsers() async {
    _showLoading();

    _sharedPreferences = await _prefs;
    String authToken = Auth.getToken(_sharedPreferences) ?? '';
    var resp = await service.getListUser(authToken);

    setState(() {
      res = resp;
    });
    _hideLoading();
  }

  _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Usuarios')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const Register()))
                .then((_) {
              _fetchUsers();
            });
          },
          child: const Icon(Icons.add),
        ),
        body: Builder(
          builder: (_) {
            if (_isLoading) {
              return LoadingScreen();
            }

            if (res.error) {
              return Center(child: Text(res.errorMessage ?? ''));
            }

            return ListView.separated(
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Theme.of(context).primaryColor),
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(res.data?[index].userName),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                            context: context,
                            builder: (_) => const DeleteDialog()) ??
                        false;

                    if (result) {
                      _sharedPreferences = await _prefs;
                      String authToken =
                          Auth.getToken(_sharedPreferences) ?? '';

                      final deleteResult = await service.deleteUser(
                          res.data?[index].userName ?? '', authToken);
                      String message = '';

                      if (deleteResult.data == true) {
                        message = 'El usuario fue eliminado';
                      } else {
                        message =
                            deleteResult.errorMessage ?? 'Ocurrio un error';
                      }
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(message),
                          duration: const Duration(milliseconds: 1000)));

                      return deleteResult.data ?? false;
                    }
                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.only(left: 16),
                    child: const Align(
                      child: Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: ListTile(
                    title: RichText(
                      text: TextSpan(
                        text: '${res.data?[index].nombre ?? ''}'
                            ' '
                            '${res.data?[index].aPaterno ?? ''}'
                            ' '
                            '${res.data?[index].aMaterno ?? ''}',
                        style: !(res.data?[index].aproved ?? false)
                            ? const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)
                            : const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                      ),
                    ),
                    subtitle: RichText(
                        text: TextSpan(
                            text: "${res.data?[index].email ?? ''}\n",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                            children: [
                          TextSpan(
                            text:
                                "${(res.data?[index].type == 1) ? "Administrador" : "Usuario"}",
                            style: !(res.data?[index].aproved ?? false)
                                ? const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)
                                : const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                          ),
                        ])),
                    onTap: () async {
                      final result = await showDialog(
                          context: context, builder: (_) => const AproveUser());

                      if (result == true) {
                        _sharedPreferences = await _prefs;
                        String authToken =
                            Auth.getToken(_sharedPreferences) ?? '';

                        final aproveResult = await service.aproveUser(
                            res.data?[index].userName ?? '', authToken);
                        String message = '';

                        if (aproveResult.data == true) {
                          message = 'El usuario foi aprovado';
                        } else {
                          message =
                              aproveResult.errorMessage ?? 'Ocurrio un error';
                        }
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(message),
                            duration: const Duration(milliseconds: 1000)));

                        await _fetchUsers();
                      }
                    },
                  ),
                );
              },
              itemCount: res.data?.length ?? 0,
            );
          },
        ));
  }
}
