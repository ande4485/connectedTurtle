import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:turtle_package/model/device.dart';

import '../../../generated/l10n.dart';
import '../../bloc/device_bloc.dart';
import '../../bloc/device_state.dart';
import '../design/limitations.dart';
import '../design/style.dart';

import '../widget/loading.dart';
import '../widget/turtle_error.dart';

class DeviceSettingsAdmin extends StatelessWidget {
  final String idDevice;

  const DeviceSettingsAdmin({super.key, required this.idDevice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.current.settings,
        ),
      ),
      body: DeviceSettingsAdminScreen(
        idDevice: idDevice,
      ),
    );
  }
}

class DeviceSettingsAdminScreen extends StatefulWidget {
  final String idDevice;

  const DeviceSettingsAdminScreen({super.key, required this.idDevice});

  @override
  State createState() => DeviceSettingsAdminScreenState();
}

class DeviceSettingsAdminScreenState extends State<DeviceSettingsAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  late String fontSize;
  late DeviceBloc _deviceBloc;

  @override
  void initState() {
    _deviceBloc = BlocProvider.of<DeviceBloc>(context);
    _deviceBloc.getDeviceSettings(widget.idDevice, DeviceType.turtle);

    super.initState();
  }

  void _saveDevice(Device deviceSettings) async {
    await _deviceBloc
        .updateDeviceSettings(deviceSettings)
        .then((value) => context.pop());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeviceBloc, DeviceState>(
        builder: (context, state) {
          if (state is DeviceSettings) {
            Turtle turtle = (state.device as Turtle);
            return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: TextFormDecoration.copyWith(
                              labelText: S.current.font_size),
                          initialValue: turtle.fontSize.toString(),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                maxCharForFontSize),
                          ],
                          keyboardType: TextInputType.number,
                          onSaved: (String? value) {
                            if (value != null) {
                              setState(() {
                                turtle.fontSize = int.parse(value);
                              });
                            }
                          },
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return S.current.wrong_font_size;
                            }
                            return null;
                          },
                          maxLines: 1,
                        ),
                        spaceBetweenField,
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                S.current.display_information,
                              ),
                              const Spacer(),
                              Expanded(
                                  child: Switch(
                                value: turtle.showInfo,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (bool val) {
                                  turtle.showInfo = val;
                                },
                              ))
                            ]),
                        spaceBetweenField,
                        TextFormField(
                          decoration: TextFormDecoration.copyWith(
                              labelText: S.current.message_before_switch),
                          initialValue: turtle.messageBeforeEnd,
                          onSaved: (String? value) {
                            if (value != null) {
                              setState(() {
                                turtle.messageBeforeEnd = value;
                              });
                            }
                          },
                          maxLines: 4,
                        ),
                        spaceBetweenField,
                        OutlinedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _saveDevice(turtle);
                            }
                          },
                          child: Text(S.current.save),
                        ),
                      ],
                    ))));
          }
          if (state is DeviceError) {
            return const TurtleError();
          } else {
            return const Loading();
          }
        },
        listener: (context, state) {});
  }
}
