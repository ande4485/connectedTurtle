import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:turtle_phone/generated/l10n.dart';
import 'package:turtle_phone/presentation/bloc/login_bloc.dart';
import 'package:turtle_phone/presentation/bloc/login_state.dart';

import 'package:turtle_phone/presentation/screen/widget/loading.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoginScreen());
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LoginBloc>(context).start();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(buildWhen: (oldState, state) {
      if (state is LoginLoading ||
          state is LoginNoSignin ||
          state is LoginError) {
        return true;
      } else {
        return false;
      }
    }, builder: (context, state) {
      if (state is LoginLoading) {
        return const Loading();
      } else {
        return Stack(
          children: <Widget>[
            Center(
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: const Color(0xffdd4b39),
                    padding: const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)),
                onPressed: () =>
                    BlocProvider.of<LoginBloc>(context).logWithAuthGoogle(),
                child: Text(
                  S.current.sign_google,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            // Loading
          ],
        );
      }
    }, listener: (context, state) {
      if (state is LoginFinished) {
        context.pushReplacementNamed(
          'devices',
        );
      } else if (state is LoginError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).sign_failed),
          duration: const Duration(seconds: 2),
        ));
      }
    });
  }
}
