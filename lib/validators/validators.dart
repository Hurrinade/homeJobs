
class Validators{

   String checkPassword(String password){
    if(password.isEmpty){
      return 'Type in your password!';
    }else if(password.length < 8){
      return 'Password is to small';
    }else return null;
  }

  String checkEmail(String email){
    if(email.isEmpty){
      return 'Type in your email';
    }else if(email.trimRight().contains(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')){
      return 'Invalid email';
    }else return null;
  }

}