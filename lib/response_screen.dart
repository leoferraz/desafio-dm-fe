import 'package:flutter/material.dart';

class ResponseScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  ResponseScreen({required this.userData});

  @override
  Widget build(BuildContext context) {
    final String? nome = userData['nome'];
    final dynamic limite = userData['limite'];
    final String? status = userData['status'];

    if (nome == null || limite == null || status == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Erro'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Text(
            'Houve um erro ao processar seus dados. Por favor, tente novamente mais tarde.',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Resposta da análise automática de crédito'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .center, // Centraliza todos os widgets na Row
              children: [
                Text(
                  'Resultado: ',
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  status == 'APROVADO' ? 'APROVADO' : 'REPROVADO',
                  style: TextStyle(
                      fontSize: 24,
                      color: status == 'APROVADO' ? Colors.green : Colors.red),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              status == 'APROVADO'
                  ? 'Parabéns $nome, seu cartão foi liberado com um limite de ${limite.toString()} pré-aprovado!'
                  : '$nome, infelizmente no momento seu pedido não foi autorizado!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }
}
