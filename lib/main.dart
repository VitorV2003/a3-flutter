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

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  _ProdutosPageState createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  final Map<String, int> _quantidade = {};
  final Map<String, String> _imagens = {};
  final Map<String, double> _precos = {};
  double _total = 0.0;

  void _incrementCounter(String titulo, double preco, String imagem) {
    setState(() {
      if (_quantidade.containsKey(titulo)) {
        _quantidade[titulo] = (_quantidade[titulo] ?? 0) + 1;
      } else {
        _quantidade[titulo] = 1;
        _imagens[titulo] = imagem;
        _precos[titulo] = preco;
      }
      _total += preco;
    });
  }

  void _decrementCounter(String titulo, double preco) {
    setState(() {
      if (_quantidade.containsKey(titulo) && _quantidade[titulo]! > 0) {
        _quantidade[titulo] = (_quantidade[titulo] ?? 0) - 1;
        _total -= preco;

        if (_quantidade[titulo] == 0) {
          _quantidade.remove(titulo);
          _imagens.remove(titulo);
          _precos.remove(titulo);
        }
      }
    });
  }

  void _removerProduto(String titulo) {
    setState(() {
      double precoProduto = _precos[titulo] ?? 0.0;
      int quantidadeProduto = _quantidade[titulo] ?? 0;

      // Subtrai o valor total do produto do total geral
      _total -= (precoProduto * quantidadeProduto);

      // Remove o produto do pedido
      _quantidade.remove(titulo);
      _imagens.remove(titulo);
      _precos.remove(titulo);
    });
  }

  void _mostrarPedido() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Meu pedido'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: _quantidade.keys.map((String key) {
                return ListTile(
                  leading: Image.asset(_imagens[key]!),
                  title: Text(key),
                  subtitle: Text('Quantidade: ${_quantidade[key]}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _removerProduto(key);
                      Navigator.of(context).pop();
                      _mostrarPedido();
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            Text(
              'Total: R\$ ${_total.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PRODUTOS'),
        backgroundColor: Colors.yellow,
        centerTitle: true, // Centraliza o título
      ),
      body: Column(
        children: [
          produtoItem(
            'Queijo Colonial',
            'O Queijo Colonial é um queijo típico da região rural, conhecido por seu sabor intenso e textura cremosa. Ideal para acompanhar pães, frutas e vinhos. Peso: 300g',
            'imagens/queijo_colonial.png',
            40.00,
          ),
          produtoItem(
            'Linguiça Colonial',
            'A Linguiça Colonial é um embutido saboroso, feito com carne suína e temperos especiais. Ideal para grelhar e acompanhar com molhos ou em pratos típicos. Peso: 500g',
            'imagens/linguica_colonial.png',
            30.00,
          ),
          produtoItem(
            'Vinho Colonial',
            'Um vinho artesanal, produzido a partir de uvas selecionadas, com sabor encorpado e aromas frutados. Perfeito para acompanhar refeições ou para um brinde especial. Volume: 750ml',
            'imagens/vinho_colonial.png',
            60.00,
          ),
          const Spacer(),
          // Botão para mostrar o pedido
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue,
            width: double.infinity,
            child: TextButton(
              onPressed: _mostrarPedido,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Meu pedido',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  Text('Total: R\$ ${_total.toStringAsFixed(2)}',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget produtoItem(
      String titulo, String descricao, String imagem, double preco) {
    int quantidade = _quantidade[titulo] ?? 0;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Image.asset(imagem),
        title: Text(titulo),
        subtitle: Text(
            '$descricao\nPreço: R\$ ${preco.toStringAsFixed(2)}\nQuantidade: $quantidade'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.red),
              onPressed: () {
                _decrementCounter(titulo, preco);
              },
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.green),
              onPressed: () {
                _incrementCounter(titulo, preco, imagem);
              },
            ),
          ],
        ),
      ),
    );
  }
}
