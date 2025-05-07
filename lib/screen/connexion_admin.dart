import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tick/models/admin.dart';
import 'package:tick/models/adminSession.dart';
import 'package:tick/models/dataHelper.dart';
import 'package:tick/widgets/customButton.dart';
import 'package:tick/widgets/custom_color';


class LoginAdminScreen extends StatefulWidget {
  const LoginAdminScreen({super.key});

  @override
  State<LoginAdminScreen> createState() => _LoginAdminScreenState();
}

class _LoginAdminScreenState extends State<LoginAdminScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary.withOpacity(0.1),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Connexion Administrateur",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email requis';
                      } else if (!value.contains('@')) {
                        return "Email invalide";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.mail),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Mot de passe",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 45,
                    child: CustomButton(
                      onPressed: _loginAdmin,
                      text: "Se connecter",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Pas encore de compte ?"),
                      const SizedBox(width: 5),
                      InkWell(
                        child: Text(
                          'Inscrivez-vous ici',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 15,
                            color: AppColors.primary,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/register_admin');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

 void _loginAdmin() async {
  if (formKey.currentState!.validate()) {
    Admin? admin = await DataHelper.instance.getAdminByEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );

    if (admin != null) {
      Provider.of<AdminSession>(context, listen: false).login(admin);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connexion réussie !')),
      );

      Navigator.pushNamed(context, '/homeAdmin');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email ou mot de passe incorrect')),
      );
    }
  }
}


}
