
import 'package:ev_testing_app/Validation/EngineerValidator.dart';
import 'package:rxdart/rxdart.dart';

class EngineerLoginBloc extends Object with EngineerValidators implements BaseBloc{

 final _loginEmail= BehaviorSubject<String>();
 final _loginPassword=BehaviorSubject<String>();

 //getter
 Stream<String> get loginEmail => _loginEmail.stream.transform(emailValidator);
 Stream<String> get loginPassword => _loginPassword.stream.transform(passwordValidator);

 Stream<bool> get isValid => Rx.combineLatest2(loginEmail, loginPassword, (a, b) => true); 
 // This line is from rxdart, rx is validating both email and password, if both validate, then login button will work, otherwise login buttin dissable

 //setter
 Function(String) get changeLoginEmail => _loginEmail.sink.add;
 Function(String) get changeLoginPassword => _loginPassword.sink.add;

  submit() {
    print("abc");
  }

  @override
  void dispose() {
    _loginEmail.close();
    _loginPassword.close();
  }

//  void dispose(){
//    _loginEmail.close();
//    _loginPassword.close();
//  }

}

abstract class BaseBloc {
  void dispose();
}
