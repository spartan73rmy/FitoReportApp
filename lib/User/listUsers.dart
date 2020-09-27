import 'package:LikeApp/CommonWidgets/loadingScreen.dart';
import 'package:LikeApp/Models/user.dart';
import 'package:LikeApp/Services/auth.dart';
import 'package:LikeApp/Services/userService.dart';
import 'package:LikeApp/User/aproveUser.dart';
import 'package:LikeApp/User/register.dart';
import 'package:LikeApp/User/userDelete.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:LikeApp/Models/APIResponse.dart';

class ListUsers extends StatefulWidget {
  ListUsers({Key key}) : super(key: key);

  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  bool _isLoading = false;
  APIResponse<List<User>> res;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  UserService get service => GetIt.I<UserService>();
  @override
  void initState() {
    _fetchUsers();
    super.initState();
  }

  _fetchUsers() async {
    _showLoading();

    _sharedPreferences = await _prefs;
    String authToken = Auth.getToken(_sharedPreferences);
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
        appBar: AppBar(title: Text('Usuarios')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => Register()))
                .then((_) {
              _fetchUsers();
            });
          },
          child: Icon(Icons.add),
        ),
        body: Builder(
          builder: (_) {
            if (_isLoading) {
              return LoadingScreen();
            }

            if (res.error) {
              return Center(child: Text(res.errorMessage));
            }

            return ListView.separated(
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Theme.of(context).primaryColor),
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey(res.data[index].userName),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                        context: context, builder: (_) => UserDelete());

                    if (result) {
                      _sharedPreferences = await _prefs;
                      String authToken = Auth.getToken(_sharedPreferences);

                      final deleteResult = await service.deleteUser(
                          res.data[index].userName, authToken);
                      var message = '';

                      if (deleteResult != null && deleteResult.data == true) {
                        message = 'El usuario fue eliminado';
                      } else {
                        message =
                            deleteResult?.errorMessage ?? 'Ocurrio un error';
                      }
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(message),
                          duration: new Duration(milliseconds: 1000)));

                      return deleteResult.data ?? false;
                    }
                    print(result);
                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 16),
                    child: Align(
                      child: Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: ListTile(
                    title: RichText(
                      text: TextSpan(
                        text: res.data[index].nombre +
                            " " +
                            res.data[index].aPaterno +
                            " " +
                            res.data[index].aMaterno,
                        style: !res.data[index].aproved
                            ? TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)
                            : TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                      ),
                    ),
                    subtitle: RichText(
                        text: TextSpan(
                            text: "${res.data[index].email}\n",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                            children: [
                          TextSpan(
                            text:
                                "${(res.data[index].type == 1) ? "Administrador" : "Usuario"}",
                            style: !res.data[index].aproved
                                ? TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)
                                : TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                          ),
                        ])),
                    onTap: () async {
                      final result = await showDialog(
                          context: context, builder: (_) => AproveUser());

                      if (result) {
                        _sharedPreferences = await _prefs;
                        String authToken = Auth.getToken(_sharedPreferences);

                        final aproveResult = await service.aproveUser(
                            res.data[index].userName, authToken);
                        var message = '';

                        if (aproveResult != null && aproveResult.data == true) {
                          message = 'El usuario fue aprovado';
                        } else {
                          message =
                              aproveResult?.errorMessage ?? 'Ocurrio un error';
                        }
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(message),
                            duration: new Duration(milliseconds: 1000)));

                        await _fetchUsers();

                        return aproveResult.data ?? false;
                      }
                    },
                  ),
                );
              },
              itemCount: res.data.length,
            );
          },
        ));
  }
}
