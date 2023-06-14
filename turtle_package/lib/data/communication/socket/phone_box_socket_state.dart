import 'package:equatable/equatable.dart';

abstract class PhoneBoxSocketState extends Equatable{
  const PhoneBoxSocketState();

  @override
  List<Object> get props => [];

}

class BoxSocketIsConfig extends PhoneBoxSocketState{
  final String idBox;

  BoxSocketIsConfig({required this.idBox});

  @override
  List<Object> get props => [this.idBox];



}

class BoxAskPassword extends PhoneBoxSocketState{}

class BoxAcceptSmartphone extends PhoneBoxSocketState{}