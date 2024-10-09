import 'package:flutter/material.dart';

void main() {
  runApp(const ProdutosColoniaisApp());
}

class ProdutosColoniaisApp extends StatelessWidget {
  const ProdutosColoniaisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.yellow[700],
        hintColor: Colors.blueAccent,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.yellow,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blueAccent,
          ),
        ),
      ),
      home: const ProdutosPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProdutosPage extends StatefulWidget {
  const ProdutosPage({super.key});

  @override
  _ProdutosPageState createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage>
    with SingleTickerProviderStateMixin {
  final Map<String, int> _quantidade = {};
  final Map<String, String> _imagens = {};
  final Map<String, double> _precos = {};
  double _total = 0.0;

  String _selectedPaymentMethod = 'Crédito';
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
  }

  void _adicionarCarrinho(String titulo, double preco, String imagem) {
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

  void _removerCarrinho(String titulo, double preco) {
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

      _total -= (precoProduto * quantidadeProduto);
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
              children: [
                ..._quantidade.keys.map((String key) {
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
                const SizedBox(height: 16),
                _metodoPagamentoWidget(),
                const SizedBox(height: 16),
                _enderecoEntregaWidget(),
              ],
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
            ElevatedButton(
              onPressed: _finalizarPedido,
              child: const Text('Finalizar Pedido'),
            ),
          ],
        );
      },
    );
  }

  void _finalizarPedido() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pedido Realizado com Sucesso'),
          content: const Text(
            'Seu pedido foi realizado com sucesso!\n'
            'Os dados da entrega chegaram no seu zap.',
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _limparCarrinho();
              },
            ),
          ],
        );
      },
    );
  }

  void _limparCarrinho() {
    setState(() {
      _quantidade.clear();
      _imagens.clear();
      _precos.clear();
      _total = 0.0;
    });
  }

  Widget _metodoPagamentoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Método de Pagamento',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Column(
          children: [
            ListTile(
              title: const Text('PIX'),
              leading: const Icon(Icons.qr_code),
              trailing: Radio<String>(
                value: 'PIX',
                groupValue: _selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Crédito'),
              leading: const Icon(Icons.credit_card),
              trailing: Radio<String>(
                value: 'Crédito',
                groupValue: _selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Débito ou Dinheiro'),
              leading: const Icon(Icons.attach_money),
              trailing: Radio<String>(
                value: 'Débito ou Dinheiro',
                groupValue: _selectedPaymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Método selecionado: $_selectedPaymentMethod',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _enderecoEntregaWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Endereço de Entrega',
            style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(
          controller: _ruaController,
          decoration: const InputDecoration(labelText: 'Rua'),
        ),
        TextField(
          controller: _bairroController,
          decoration: const InputDecoration(labelText: 'Bairro'),
        ),
        TextField(
          controller: _numeroController,
          decoration: const InputDecoration(labelText: 'Número'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('imagens/logo.png', width: 50, height: 50),
        title: const Text('Produtos Coloniais'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: _mostrarPedido,
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: const [
              Tab(text: 'Carnes'),
              Tab(text: 'Queijos'),
              Tab(text: 'Linguiças'),
              Tab(text: 'Vinhos'),
              Tab(text: 'Embutidos e Defumados'),
              Tab(text: 'Manteigas e Cremes'),
              Tab(text: 'Cachaça'),
              Tab(text: 'Conservas'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _produtosCategoriaCarnes(),
                _produtosCategoriaQueijos(),
                _produtosCategoriaLinguicas(),
                _produtosCategoriaVinhos(),
                _produtosCategoriaEmbutidoseDefumados(),
                _produtosCategoriaManteigaseCremes(),
                _produtosCategoriaCachaca(),
                _produtosCategoriaConservas(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _produtosCategoriaCarnes() {
    return ListView(
      children: [
        produtoItem(
          'Costela Bovina',
          'Costela macia, ideal para churrasco. Peso: 1kg',
          'imagens/costela.png',
          75.00,
        ),
        produtoItem(
          'Picanha Premium',
          'Picanha suculenta, perfeita para grelhar. Peso: 1kg',
          'imagens/picanha.png',
          120.00,
        ),
      ],
    );
  }

  Widget _produtosCategoriaQueijos() {
    return ListView(
      children: [
        produtoItem(
          'Queijo Colonial',
          'Queijo artesanal, maturado, com sabor marcante. Peso: 300g',
          'imagens/queijo_colonial.png',
          40.00,
        ),
      ],
    );
  }

  Widget _produtosCategoriaLinguicas() {
    return ListView(
      children: [
        produtoItem(
          'Linguiça Colonial',
          'Linguiça feita com carne suína e temperos especiais. Peso: 500g',
          'imagens/linguica_colonial.png',
          30.00,
        ),
      ],
    );
  }

  Widget _produtosCategoriaVinhos() {
    return ListView(
      children: [
        produtoItem(
          'Vinho Colonial',
          'Um vinho artesanal, produzido a partir de uvas selecionadas, com sabor encorpado e aromas frutados. Perfeito para acompanhar refeições ou para um brinde especial. Volume: 750ml',
          'imagens/vinho_colonial.png',
          30.00,
        ),
      ],
    );
  }

  Widget _produtosCategoriaEmbutidoseDefumados() {
    return ListView(
      children: [
        produtoItem(
          'Embutido e defumado',
          'Obrigado sr defumado',
          'imagens/vinho_colonial.png',
          30.00,
        ),
      ],
    );
  }

  Widget _produtosCategoriaManteigaseCremes() {
    return ListView(
      children: [
        produtoItem(
          'Manteiga Colonial',
          'Manteiga',
          'imagens/vinho_colonial.png',
          30.00,
        ),
      ],
    );
  }

  Widget _produtosCategoriaCachaca() {
    return ListView(
      children: [
        produtoItem(
          'Cachaça',
          'Cachaça',
          'imagens/vinho_colonial.png',
          30.00,
        ),
      ],
    );
  }

  Widget _produtosCategoriaConservas() {
    return ListView(
      children: [
        produtoItem(
          'Conserva',
          'Conserva',
          'imagens/vinho_colonial.png',
          30.00,
        ),
      ],
    );
  }

  Widget produtoItem(
      String titulo, String descricao, String imagem, double preco) {
    int quantidade = _quantidade[titulo] ?? 0;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(imagem, width: 70, height: 70, fit: BoxFit.cover),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '$descricao\nPreço: R\$ ${preco.toStringAsFixed(2)}\nQuantidade no carrinho: $quantidade',
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () => _removerCarrinho(titulo, preco),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.green),
              onPressed: () => _adicionarCarrinho(titulo, preco, imagem),
            ),
          ],
        ),
      ),
    );
  }
}
