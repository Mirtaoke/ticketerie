import 'package:flutter/material.dart';
import 'package:tick/models/admin.dart';
import 'package:tick/models/dataHelper.dart';
import 'package:tick/widgets/customButton.dart';
import 'package:tick/widgets/custom_color';

class RegisterAdminScreen extends StatefulWidget {
  const RegisterAdminScreen({super.key});

  @override
  State<RegisterAdminScreen> createState() => _RegisterAdminScreenState();
}

class _RegisterAdminScreenState extends State<RegisterAdminScreen> {
  final TextEditingController _nameController = TextEditingController();
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
              boxShadow: [
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
                    "Inscription Administrateur",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? 'Nom requis'
                                : null,
                    decoration: const InputDecoration(
                      labelText: "Nom et prénoms",
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),
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
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator:
                        (value) =>
                            value == null || value.length < 6
                                ? 'Mot de passe trop court'
                                : null,
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
                      onPressed: _registerAdmin,
                      text: "Créer le compte",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Vous avez déjà un compte ?"),
                      const SizedBox(width: 5),
                      InkWell(
                        child: Text(
                          'Connectez-vous ici',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 15,
                            color: AppColors.primary,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
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

void _registerAdmin() async {
  if (formKey.currentState!.validate()) {
    final email = _emailController.text.trim();
    final exists = await DataHelper.instance.emailExists(email);

    if (exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cet email est déjà utilisé')),
      );
      return; 
    }

    final newAdmin = Admin(
      name: _nameController.text.trim(),
      email: email,
      password: _passwordController.text.trim(),
    );

    await DataHelper.instance.insertAdmin(newAdmin);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Compte créé avec succès !')),
    );
    Navigator.pushNamed(context, '/login');
  }
}

}
