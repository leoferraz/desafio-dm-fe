import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'api_service.dart';
import 'response_screen.dart';

class PedirCartao extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final cpfController = MaskedTextController(mask: '000.000.000-00');
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = MaskedTextController(mask: '(00) 00000-0000');
  final _rendaController = TextEditingController();
  num _rendaValidada =
      0; // Aqui nós mantemos a renda válida depois da validação
  final apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedir Cartão"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                hintText: 'Insira seu nome',
                labelText: 'Nome',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu nome';
                }
                return null;
              },
            ),
            TextFormField(
              controller: cpfController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Insira seu CPF',
                labelText: 'CPF',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu CPF';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Insira seu e-mail',
                labelText: 'E-mail',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu e-mail';
                }
                if (!EmailValidator.validate(value)) {
                  return 'Por favor, insira um e-mail válido';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _telefoneController,
              decoration: const InputDecoration(
                hintText: 'Insira seu telefone',
                labelText: 'Telefone',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu telefone';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _rendaController,
              decoration: const InputDecoration(
                hintText: 'Insira sua renda',
                labelText: 'Renda (ex: 1000)',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira sua renda';
                }
                final n = num.tryParse(value);
                if (n == null) {
                  return '"$value" não é um valor válido';
                }
                _rendaValidada = n;
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final response = await apiService.insertPedido({
                      'nome': _nomeController.text,
                      'cpf': cpfController.text,
                      'email': _emailController.text,
                      'telefone': _telefoneController.text,
                      'renda': _rendaValidada.toString(),
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ResponseScreen(userData: response),
                      ),
                    );
                  }
                },
                child: Text('Solicitar Cartão'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
