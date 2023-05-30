import 'package:flutter/material.dart';
import 'pedir_cartao.dart';
import 'consultar_pedidos.dart';

void main() {
  runApp(MeuAplicativo());
}

class MeuAplicativo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desafio - Solicitação de Cartões',
      home: TelaInicial(),
    );
  }
}

class TelaInicial extends StatelessWidget {
  void _navigateToPedirCartao(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PedirCartao(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitação de Cartões DM'),
      ),
      body: Center(
        child: Text('Bem vindo(a) ao app do Desafio!'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // TODO: Implementar ação ao tocar na opção "Home"
              },
            ),
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Pedir Cartão'),
              onTap: () {
                _navigateToPedirCartao(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Listar Pedidos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConsultarPedidos()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
