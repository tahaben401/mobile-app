import 'package:flutter/material.dart';
import '../database_helper.dart';
import 'register_screen.dart';
class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(


        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xff0277BD), Color(0xff03A9F4) , Color(0xff80D8FF)] ,begin: Alignment.topLeft , end: Alignment.topRight),
          ),


          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),

              Text("Signe in",style:TextStyle(
                fontWeight:FontWeight.w700 ,
                color: Colors.white ,
                fontSize: 28 ,
              ),

              ),
              SizedBox(height: 50,),
              Expanded(
                child: Container(
                    padding: EdgeInsets.only(top: 50 ,left: 20 , right: 20),
                    width: MediaQuery.of(context).size.width,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child:Column(
                      children: [
                        Form(child: Column(
                          key: _formKey,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextFormField(
                              controller: _emailController,
                              obscureText: false,
                              decoration: InputDecoration(labelText: 'Email' ,
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.email_outlined),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value){
                                if(value==null || value.isEmpty){
                                  return 'Error' ;
                                }
                                if(!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)){
                                  return "Error" ;
                                }
                                return null ;
                              },


                            ),

                            SizedBox(height: 50,),

                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(labelText: 'Password' ,
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.password),

                              ),


                              onSaved: (Value){
                                //stock email
                              },

                            ),
                            SizedBox(height: 10,),
                            SizedBox(height: 50,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(



                                  child: ElevatedButton( onPressed: () async {
                                      final user = await DatabaseHelper.instance.getUser(
                                      _emailController.text,
                                      _passwordController.text,
                                      );

                                      if (user != null) {
                                        Navigator.pushReplacementNamed(
                                        context,
                                        '/home',
                                        arguments: user, // Pass the user object
                                      );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Login failed')),
                                      );
                                      }
                                      },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 132,
                                          vertical: 20,
                                        )
                                    ),


                                    child: Text("Login",style:TextStyle(
                                      color: Colors.white ,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold ,

                                    ),),

                                  ),

                                ),


                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Don't have account?",
                                  style:TextStyle(
                                    color: Colors.blue ,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold ,

                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              child: Text('Create Account'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => RegisterScreen()),
                                );
                              },
                            ),



                          ],


                        ), ),
                      ],
                    )
                ),
              )
            ],
          ),
        )
    );
  }
}