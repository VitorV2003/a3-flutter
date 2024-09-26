import 'package:flutter/material.dart';

void main() {
  runApp(const ProdutosColoniaisApp());
}

class ProdutosColoniaisApp extends StatelessWidget {
  const ProdutosColoniaisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProdutosPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProdutosPage extends StatelessWidget {
  const ProdutosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PRODUTOS'),
        backgroundColor: Colors.yellow,
      ),
      body: Column(
        children: [
          produtoItem(
              'Queijo colonial',
              'Descrição detalhada do produto (peso, embalagem, ingredientes, etc)',
              'imagens/queijo_colonial.png'),
          produtoItem(
              'Linguiça colonial',
              'Descrição detalhada do produto (peso, embalagem, ingredientes, etc)',
              'imagens/linguica_colonial.png'),
          produtoItem(
              'Vinho colonial',
              'Descrição detalhada do produto (peso, embalagem, ingredientes, etc)',
              'imagens/vinho_colonial.png'),
          const Spacer(),
          // Botão para mostrar o pedido
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue,
            width: double.infinity,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Meu pedido',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                Text('Total: R\$ XX,XX',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget produtoItem(String titulo, String descricao, String imagem) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Image.asset(imagem),
        title: Text(titulo),
        subtitle: Text(descricao),
        trailing: ElevatedButton(
          onPressed: () {
            // Lógica de adicionar ao pedido
          },
          child: const Text('Adicionar'),
        ),
      ),
    );
  }
}