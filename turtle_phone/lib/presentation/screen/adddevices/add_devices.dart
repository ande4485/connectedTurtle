import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:turtle_package/model/config_devices.dart';
import 'package:turtle_package/model/device.dart';

import '../../../generated/l10n.dart';
import '../../bloc/init_device_bloc.dart';
import '../../bloc/init_device_state.dart';
import '../design/color.dart';
import '../design/style.dart';
import '../widget/loading.dart';

class AddDevicesScreen extends StatefulWidget {
  final DeviceType deviceType;

  const AddDevicesScreen({
    super.key,
    required this.deviceType,
  });

  @override
  State<StatefulWidget> createState() => AddDevicesScreenState();
}

class AddDevicesScreenState extends State<AddDevicesScreen> {
  late ConfigDevices _configDevices;
  int currentStep = 0;
  bool complete = false;
  final _formKey = GlobalKey<FormState>();
  final _formKeyWifi = GlobalKey<FormState>();
  final _formKeyInit = GlobalKey<FormState>();
  final _formKeySmartphonePassword = GlobalKey<FormState>();
  late String _passwordSmartphone;
  late InitDeviceBloc _initDeviceBloc;
  late String ssid = "";

  next() {
    switch (currentStep) {
      case 0:
        {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            _initDeviceBloc.connectToBox(_configDevices.ipBox);
          }
          break;
        }
      case 1:
        {
          if (_formKeySmartphonePassword.currentState!.validate()) {
            _formKeySmartphonePassword.currentState!.save();
            _initDeviceBloc.sendPassword(_passwordSmartphone);
          }
          break;
        }
      case 2:
        {
          if (_formKeyWifi.currentState!.validate()) {
            _formKeyWifi.currentState!.save();
            _configDevices.ssid = ssid;
            _initDeviceBloc.testWifiDevice(_configDevices);
          }
          break;
        }
      case 3:
        {
          if (_formKeyInit.currentState!.validate()) {
            _formKeyInit.currentState!.save();

            _initDeviceBloc.createDeviceAndBox(_configDevices);
          }
          break;
        }
    }
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    } else {
      context.pop();
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  @override
  void initState() {
    if (widget.deviceType == DeviceType.turtle) {
      _configDevices = ConfigTurtle.empty();
    } else {
      _configDevices = ConfigEmergency.empty();
    }
    //_configDevices.userId = widget.idUser;
    //_configDevices.userName = widget.currentUser.name;
    _initDeviceBloc = BlocProvider.of<InitDeviceBloc>(context);
    //find devices with bluetooth
    _initDeviceBloc.findDevice(_configDevices.type);
    super.initState();
  }

  @override
  void dispose() {
    _initDeviceBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<InitDeviceBloc, InitDeviceState>(
            builder: (context, state) {
      if (state is InitSearchDevice) {
        return const Loading();
      } else {
        return Stepper(
          controlsBuilder:
              (BuildContext context, ControlsDetails controlDetails) {
            return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      key: const Key("bt_next"),
                      onPressed: controlDetails.onStepContinue,
                      child: state is InitPhoneProcessing
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.background),
                              ))
                          : Text(S.current.next),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    OutlinedButton(
                      key: const Key("bt_cancel"),
                      onPressed: controlDetails.onStepCancel,
                      child: Text(S.current.cancel),
                    )
                  ],
                ));
          },
          steps: [
            Step(
                title: Text(S.current.box,
                    style: Theme.of(context).primaryTextTheme.titleLarge!),
                isActive: true,
                state: StepState.indexed,
                content: Form(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Center(
                            child: Form(
                                key: _formKey,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      TextFormField(
                                          key: const Key("field_ip"),
                                          //TODO inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.|$)){4}'))],
                                          keyboardType: TextInputType.number,
                                          autocorrect: false,
                                          onSaved: (String? value) {
                                            if (value != null) {
                                              setState(() {
                                                _configDevices.ipBox = value;
                                              });
                                            }
                                          },
                                          initialValue: _configDevices.ipBox,
                                          maxLines: 1,
                                          validator: (value) {
                                            if (value != null &&
                                                (value.isEmpty ||
                                                    value.isEmpty)) {
                                              return S.current.required_field;
                                            }
                                            return null;
                                          },
                                          decoration:
                                              TextFormDecoration.copyWith(
                                                  hintText:
                                                      S.current.enter_ip_box)

                                          //filled: true,
                                          ),
                                      //SizedBox(height: 20,),
                                    ])))))),
            Step(
                title: Text(S.current.box_pswd_smartphone,
                    style: Theme.of(context).primaryTextTheme.titleLarge!),
                isActive: true,
                state: StepState.indexed,
                content: Form(
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Center(
                            child: Form(
                                key: _formKeySmartphonePassword,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      TextFormField(
                                          key: const Key("field_password_box"),
                                          autocorrect: false,
                                          onSaved: (String? value) {
                                            if (value != null) {
                                              setState(() {
                                                _passwordSmartphone = value;
                                              });
                                            }
                                          },
                                          maxLines: 1,
                                          validator: (value) {
                                            if (value != null &&
                                                (value.isEmpty ||
                                                    value.isEmpty)) {
                                              return S.current.required_field;
                                            }
                                            return null;
                                          },
                                          decoration:
                                              TextFormDecoration.copyWith(
                                                  hintText: S.current
                                                      .enter_password_on_tv)

                                          //filled: true,
                                          ),
                                      //SizedBox(height: 20,),
                                    ])))))),
            Step(
              isActive: false,
              state: StepState.indexed,
              title: Text(S.current.wifi,
                  style: Theme.of(context).primaryTextTheme.titleLarge!),
              content: Form(
                  key: _formKeyWifi,
                  child: Column(children: <Widget>[
                    Text(ssid),
                    TextFormField(
                      key: const Key("wifi_field_password"),
                      decoration:
                          InputDecoration(labelText: S.current.wifi_password),
                      onSaved: (String? value) {
                        if (value != null) {
                          setState(() {
                            _configDevices.passwd = value;
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
                  ])),
            ),
            _configDevices.type == DeviceType.emergency
                ? Step(
                    isActive: false,
                    state: StepState.indexed,
                    title: Text(S.current.emergency_message,
                        style: Theme.of(context).primaryTextTheme.titleLarge!),
                    content: Form(
                        key: _formKeyInit,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                  onSaved: (String? value) {
                                    if (value != null) {
                                      setState(() {
                                        (_configDevices as ConfigEmergency)
                                            .message = value;
                                      });
                                    }
                                  },
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value != null &&
                                        (value.isEmpty || value.isEmpty)) {
                                      return S.current.required_field;
                                    }
                                    return null;
                                  },
                                  decoration: TextFormDecoration.copyWith(
                                      labelText: S.current.enter_turtle_name)),
                            ])))
                : Step(
                    isActive: false,
                    state: StepState.indexed,
                    title: Text(S.current.turtle_properties,
                        style: Theme.of(context).primaryTextTheme.titleLarge!),
                    content: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Form(
                            key: _formKeyInit,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextFormField(
                                      key: const Key("name_turtle"),
                                      onSaved: (String? value) {
                                        if (value != null) {
                                          setState(() {
                                            (_configDevices as ConfigTurtle)
                                                .nameForTurtle = value;
                                          });
                                        }
                                      },
                                      maxLines: 1,
                                      validator: (value) {
                                        if (value != null &&
                                            (value.isEmpty || value.isEmpty)) {
                                          return S.current.required_field;
                                        }
                                        return null;
                                      },
                                      decoration: TextFormDecoration.copyWith(
                                          labelText:
                                              S.current.enter_turtle_name)),
                                ])))),
          ],
          currentStep: currentStep,
          onStepContinue: next,
          onStepTapped: (step) {},
          onStepCancel: cancel,
        );
      }
    }, listener: (context, state) {
      if (state is BoxAskForPassword) {
        setState(() {
          currentStep = currentStep + 1;
        });
        goTo(currentStep);
      } else if (state is BoxConnected) {
        _initDeviceBloc.getSSidFromPhone();
      } else if (state is InitWifiOK) {
        setState(() {
          currentStep = currentStep + 1;
        });
        goTo(currentStep);
      } else if (state is PhoneSsid) {
        setState(() {
          ssid = state.ssid;
          currentStep = currentStep + 1;
        });
        goTo(currentStep);
      } else if (state is BtSetupEnd) {
        context.pushReplacementNamed('endInit',
            pathParameters: {'devicetype': _configDevices.type.name});
      } else if (state is InitPhoneNoDeviceFound) {
        context.pushReplacementNamed('devicenotfound',
            pathParameters: {'devicetype': _configDevices.type.name});
      } else if (state is InitPhoneError) {
        String message = "";
        if (state is InitWifiNOK) {
          message = S.current.error_wifi_connection;
        } else if (state is InitWifiError) {
          message = S.current.error_wifi;
        } else if (state is BoxConnectionError) {
          message = S.current.no_connection_box;
        } else if (state is ErrorCreationTurtle) {
          message = S.current.pb_creation_turtle;
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.redAccent,
        ));
      }
    }));
  }
}
