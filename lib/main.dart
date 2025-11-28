import 'package:flutter/material.dart';
import './tab_control.dart';
import './file_functions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}




class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();


  @override
  void initState(){
    super.initState();
    GlobalVariables.createGlobalUserList();
  }

  
  bool validateUsername(String user){
    for(String line in GlobalVariables.currentUsers.keys){
      if(line == user){
        return false;
      }
    }
    return true;
  }

  bool validatePassword(String username, String password) {
    for(String k in GlobalVariables.currentUsers.keys){
      if(k == username){
        if(GlobalVariables.currentUsers[k] == password){
          return false;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager Login'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              key: _loginFormKey,
                child:
                Column(
                  children: [
                    TextFormField(
                      autofocus: true,
                      decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                      ),
                      controller: _userName,
                      validator: (value) {
                        if (value == null || value.isEmpty){
                          return 'Please enter your username';
                        }
                        else if(validateUsername(value)){
                          return 'Username not found.\nPlease correct your username or create an account';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      obscuringCharacter: '*',
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                      ),
                      controller: _password,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Password cannot be empty';
                        }
                        else if(validatePassword(_userName.text, value)) {
                          return 'Invalid password';
                        }
                        return null;
                      },
                    ),
                  ],
                )
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
                onPressed: () {
              if(_loginFormKey.currentState!.validate()){
                GlobalVariables.currentUsername = _userName.text;
                GlobalVariables.updateGlobalItemList();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TaskManager()));

                _userName.clear();
                _password.clear();
              }
            },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                child: const Text('Log In', style: TextStyle(color: Colors.white),)),
            const SizedBox(height: 20,),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccount()));
            }, child: const Text('Create Account', style: TextStyle(color: Colors.deepPurple),)),
          ],
        ),
      ),)
    );
  }
}



// Create account screen
class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {

  final _createAccountKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();



  bool validateUsername(String user){
    for(String line in GlobalVariables.currentUsers.keys){
      if(line == user){
        return true;
      }
    }
    return false;
  }


  void createAccount(){
    createNewAccount(_nameController.text, _usernameController.text, _passwordController.text);
    GlobalVariables.currentUsers[_usernameController.text] = _passwordController.text;
    GlobalVariables.currentUsername = _usernameController.text;
    GlobalVariables.updateGlobalItemList();

    _nameController.clear();
    _usernameController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Center(
        child: Padding(padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              key: _createAccountKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      autofocus: true,
                      decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty){
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15,),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        else if(validateUsername(value)){
                          return 'There is already an account with this username';
                        }
                        return null;
                      }
                    ),
                    const SizedBox(height: 15,),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a Password';
                          }
                          return null;
                        }
                    )
                  ],
                )),
            const SizedBox(height: 15,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                onPressed: (){
              if(_createAccountKey.currentState!.validate()){
                _createAccountKey.currentState!.save();
                createAccount();
                Navigator.push(context, MaterialPageRoute(builder: (context) => TaskManager()));
              }
            }, child: const Text('Create Account', style: TextStyle(color: Colors.white),))
          ],
        ),
      ),
      )
    );
  }
}


