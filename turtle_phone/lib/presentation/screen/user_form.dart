import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:turtle_phone/presentation/bloc/user_state.dart';

import '../../generated/l10n.dart';
import '../bloc/user_bloc.dart';
import 'design/style.dart';

class UserForm extends StatelessWidget {
  final bool isCreation;

  const UserForm({
    super.key,
    required this.isCreation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            S.current.user_information,
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
                child: UserScreen(
              isCreation: isCreation,
            ))));
  }
}

class UserScreen extends StatefulWidget {
  final bool isCreation;

  const UserScreen({
    super.key,
    required this.isCreation,
  });

  @override
  State<StatefulWidget> createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  final _formKey = GlobalKey<FormState>();
  late UserBloc userBloc;

  @override
  void initState() {
    userBloc = BlocProvider.of<UserBloc>(context)..getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      if (state is UserFound) {
        return SingleChildScrollView(
            child: Form(
                key: _formKey,
                child:
                    Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  TextFormField(
                    decoration:
                        TextFormDecoration.copyWith(labelText: S.current.name),
                    initialValue: state.user.name,
                    onSaved: (String? value) {
                      if (value != null) {
                        setState(() {
                          state.user.name = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return S.current.required_field;
                      }
                      return null;
                    },
                    maxLines: 1,
                  ),
                  spaceBetweenField,
                  TextFormField(
                    decoration: TextFormDecoration.copyWith(
                        labelText: S.current.last_name),
                    initialValue: state.user.lastName,
                    onSaved: (String? value) {
                      if (value != null) {
                        setState(() {
                          state.user.lastName = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return S.current.required_field;
                      }
                      return null;
                    },
                    maxLines: 1,
                  ),
                  spaceBetweenField,
                  DateTimeFormField(
                    mode: DateTimeFieldPickerMode.date,
                    initialDatePickerMode: DatePickerMode.year,
                    decoration: TextFormDecoration.copyWith(
                        labelText: S.current.birthdate),
                    dateFormat: DateFormat.yMd(),
                    initialValue: state.user.birthDate,
                    onSaved: (DateTime? value) {
                      if (value != null) {
                        setState(() {
                          state.user.birthDate = value;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return S.current.required_field;
                      }
                      return null;
                    },
                  ),
                  spaceBetweenField,
                  OutlinedButton(
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        BlocProvider.of<UserBloc>(context)
                            .updateUser(state.user);
                        context.pop();
                      }
                    },
                    child: Text(S.current.submit),
                  ),
                ])));
      } else {
        return const Text("error");
      }
    });
  }
}
