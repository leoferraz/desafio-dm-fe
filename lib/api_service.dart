import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl =
      'http://api-desafio-dm.us-east-2.elasticbeanstalk.com';

  Future<dynamic> insertPedido(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/insertPedido'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final pedidoJson = responseBody['pedido'];
      if (pedidoJson != null) {
        return jsonDecode(pedidoJson);
      } else {
        throw Exception('Falha ao carregar dados do pedido');
      }
    } else {
      throw Exception('Falha ao inserir pedido');
    }
  }

  Future<dynamic> getAllPedidos() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/listAll'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao buscar os pedidos');
    }
  }

  Future<void> deletePedido(String cpf) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/deletePedido/$cpf'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao excluir o pedido');
    }
  }
}
