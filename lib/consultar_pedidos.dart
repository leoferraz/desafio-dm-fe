import 'package:flutter/material.dart';
import 'api_service.dart';

class ConsultarPedidos extends StatefulWidget {
  @override
  _ConsultarPedidosState createState() => _ConsultarPedidosState();
}

class _ConsultarPedidosState extends State<ConsultarPedidos> {
  final apiService = ApiService();
  List<dynamic> pedidos = [];
  List<dynamic> pedidosFiltrados = [];
  List<bool> selectedPedidos = [];

  final cpfController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPedidos();
  }

  Future<void> fetchPedidos() async {
    try {
      final response = await apiService.getAllPedidos();
      setState(() {
        pedidos = response['pedidos'] ?? [];
        pedidosFiltrados = pedidos;
        selectedPedidos = List<bool>.filled(pedidosFiltrados.length, false);
      });
    } catch (e) {
      print('Erro ao buscar os pedidos: $e');
    }
  }

  void filtrarPedidos() {
    final String cpf = cpfController.text;

    setState(() {
      if (cpf.isEmpty) {
        pedidosFiltrados = pedidos;
      } else {
        pedidosFiltrados =
            pedidos.where((pedido) => pedido['cpf'].contains(cpf)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listar Pedidos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: cpfController,
              decoration: InputDecoration(
                labelText: 'Filtrar por CPF',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                filtrarPedidos();
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Selecionar')),
                  DataColumn(label: Text('Nome')),
                  DataColumn(label: Text('CPF')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Score')),
                  DataColumn(label: Text('Renda')),
                ],
                rows: pedidosFiltrados.map((pedido) {
                  final index = pedidosFiltrados.indexOf(pedido);
                  final nome = pedido['nome'];
                  final cpf = pedido['cpf'];
                  final status = pedido['status'];
                  final score = pedido['score'];
                  final renda = pedido['renda'];

                  return DataRow(
                    cells: [
                      DataCell(
                        Checkbox(
                          value: selectedPedidos[index],
                          onChanged: (value) {
                            setState(() {
                              selectedPedidos[index] = value!;
                            });
                          },
                        ),
                      ),
                      DataCell(Text(nome)),
                      DataCell(Text(cpf)),
                      DataCell(Text(status)),
                      DataCell(Text(score.toString())),
                      DataCell(Text(renda.toString())),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirmar exclusão'),
                    content: Text(
                        'Deseja realmente excluir o(s) pedido(s) selecionado(s)?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () async {
                          List<dynamic> pedidosExcluir = [];

                          for (int i = 0; i < selectedPedidos.length; i++) {
                            if (selectedPedidos[i]) {
                              pedidosExcluir.add(pedidosFiltrados[i]);
                            }
                          }

                          if (pedidosExcluir.isNotEmpty) {
                            try {
                              for (var pedido in pedidosExcluir) {
                                final cpf = pedido['cpf'];
                                await apiService.deletePedido(cpf);
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Pedido(s) excluído(s) com sucesso'),
                                ),
                              );

                              setState(() {
                                fetchPedidos();
                              });
                            } catch (e) {
                              print('Erro ao excluir o(s) pedido(s): $e');
                            }
                          }

                          Navigator.of(context).pop();
                        },
                        child: Text('Confirmar'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Excluir Pedido(s)'),
          ),
        ],
      ),
    );
  }
}
