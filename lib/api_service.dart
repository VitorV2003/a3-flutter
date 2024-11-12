// lib/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, String>?> buscarEnderecoPorCEP(String cep) async {
  final response =
      await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (!data.containsKey('erro')) {
      return {
        'rua': data['logradouro'] ?? '',
        'bairro': data['bairro'] ?? '',
      };
    }
  }
  return null;
}
