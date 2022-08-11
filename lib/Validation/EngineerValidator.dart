import 'dart:async';


mixin EngineerValidators{

  // What is mixin 
  // mixin is a class which supports multiple inheritance, 
  //If another class wants to use mixin class variable or methods, then for this 
  //1.no extended keyword is required.
  //2.no Parrent Class Name is required before varibles or methods
  //3. Only with keyword is required i.e child class(B) with parent class(A)  
  //EX. i.suppose there is 
  //  class B {  //B is not allowed to extend any other class other than object
          // method(){
    
          //}
      //}

      //class A with B {
 
        //void main() {
          // A a = A();
          // a.method();  //we got the method without inheriting B
        //}
      //}

  var emailValidator= StreamTransformer<String,String>.fromHandlers(
    handleData: (email,sink){

      // if(email.contains("@")){
      //   sink.add(email);
      // }else{
      //   sink.addError("Email is not valid");
      // }
      // if(email.isEmpty){
      //   return sink.addError("This field can not be blank");
      // }

      // if(email.length>32){
      //   return sink.addError("long email");
      // }

      // if(email.length<6){
      //   return sink.addError("small email");
      // }

      // Pattern pattern =
      //   r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      //  // RegExp regex = new RegExp(pattern);
      //  RegExp regex=new RegExp(pattern);

      Pattern pattern= r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern.toString());

      // only email is not allowed, so below code is commented
      // if(regex.hasMatch(email)){

      //   sink.add(email);
      //   //return sink.addError("invalid email");
      // }

      if(email.length>=10){
        sink.add(email);
      }
      
      else{
        sink.addError("Input is not valid");
      }

      // Pattern pattern =
      //   r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      //   RegExp regex = new RegExp( pattern);

      // if(!regex.hasMatch(email)){
      //   return sink.addError("invalid email");
      // }

    }  
       
  );

  var passwordValidator= StreamTransformer<String,String>.fromHandlers(
    handleData: (password,sink){

      if(password.length>2){
        sink.add(password);
      }else{
        sink.addError("Password length should be greater than 2 chars.");
      }
      // if(password.isEmpty){
      //   return sink.addError("This field can not be blank");
      // }

      // if(password.length>32){
      //   return sink.addError("long password");
      // }

      // if(password.length<6){
      //   return sink.addError("small password");
      // }

     
    }  
       
  );
}