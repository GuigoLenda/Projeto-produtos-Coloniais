import 'package:flutter/material.dart';

void main() 
{
  runApp(ProdutosColoniais());
}

class ProdutosColoniais extends StatelessWidget
{
  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Produtos Coloniais',
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: PaginaInicial(),
    );
  }
}

class PaginaInicial extends StatefulWidget
{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PaginaInicial>
{
  List<Map<String, dynamic>> _carrinho = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos Coloniais do seu Zé', style: TextStyle( fontSize: 28,fontWeight: FontWeight.bold,color: Colors.white )),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: 
        [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () 
            {
              showSearch
              (
                context: context,
                delegate: ProdutoSearchDelegate(_carrinho, setState),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () 
            {
              Navigator.push
              (
                context,
                MaterialPageRoute
                (
                  builder: (context) => CarrinhoPage(carrinho: _carrinho, limparCarrinho: _limparCarrinho),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack
      (
        children: 
        [
          Positioned.fill
          (
            child: Image.asset('imagens/fundo.jpg', fit: BoxFit.cover ),
          ),
          Column(
            children: 
            [
              Container
              (
                padding: EdgeInsets.symmetric(vertical: 10),
                color: Colors.green[700],
                child: Row
                (
                  children:
                   [
                    Expanded(child: botaoCategoria('Vinhos', Icons.local_drink, context)),
                    Expanded(child: botaoCategoria('Queijos', Icons.food_bank_outlined, context)),
                    Expanded(child: botaoCategoria('Embutidos', Icons.restaurant_menu, context)),
                    Expanded(child: botaoCategoria('Carnes', Icons.set_meal, context)),
                    Expanded(child: botaoCategoria('Doces & Geleias', Icons.icecream, context)),
                    Expanded(child: botaoCategoria('Pimentas', Icons.local_fire_department, context)),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding
              (
                padding: const EdgeInsets.all(8.0),
                child: Align
                (
                  alignment: Alignment.centerLeft,
                  child: Text( 'Promoções',style: TextStyle( fontSize: 24,fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 255, 255, 255))),
                ),
              ),

              Expanded
              (
                child: GridView.builder
                (
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount
                  (
                    crossAxisCount: 5, 
                    childAspectRatio: 1, 
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: produtos.length,
                  itemBuilder: (context, index) 
                  {
                    return produtoItem(produtos[index], _carrinho, setState);
                  },
                ),
              ),

              Container
              (
                padding: EdgeInsets.all(20),
                color: Colors.grey[800],
                child: Text( 'Endereço: Rua das Flores, 123\nTelefone: (11) 98765-4321\nHorário de funcionamento: 9h às 18h', style: TextStyle(color: Colors.white,fontSize: 16),textAlign: TextAlign.center),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _limparCarrinho() 
  {
    setState(() 
    {
      _carrinho.clear();
    });
  }
  Widget botaoCategoria(String title, IconData icon, BuildContext context)
   {
    return GestureDetector(
      onTap: () 
      {
        Navigator.push
        (
          context,
          MaterialPageRoute
          (
            builder: (context) => CategoriaPag(categoria: title),
          ),
        );
      },
      child: Column
      (
        mainAxisAlignment: MainAxisAlignment.center,
        children: 
        [
          Icon(icon, color: Colors.white, size: 40),
          SizedBox(height: 5),
          Text
          (
            title,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
Widget produtoItem(Map<String, dynamic> produto, List<Map<String, dynamic>> carrinho, Function setState) 
{
  return Card
  (
    child: Column
    (
      children: 
      [
        Image.asset(produto['imagem'], height: 80, fit: BoxFit.cover),
        SizedBox(height: 10),
        Text(produto['nome']!, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(produto['preco']!),
        Row
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
            IconButton
            (
              icon: Icon(Icons.remove),
              onPressed: () 
              {
                if (produto['quantidade'] > 1) 
                {
                  setState(() 
                  {
                    produto['quantidade']--;
                  });
                }
              },
            ),
            Text('${produto['quantidade']}'),
            IconButton
            (
              icon: Icon(Icons.add),
              onPressed: () 
              {
                setState(() 
                {
                  produto['quantidade']++;
                });
              },
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () 
          {
            setState(() 
            {
              if (carrinho.contains(produto)) 
              {
                produto['quantidade']++;
              } 
              else 
              {
                carrinho.add(produto);
              }
            });
          },
          child: Text('Adicionar ao Carrinho'),
        ),
      ],
    ),
  );
}
class CarrinhoPage extends StatefulWidget 
{
  final List<Map<String, dynamic>> carrinho;
  final Function limparCarrinho;

  const CarrinhoPage({required this.carrinho, required this.limparCarrinho});

  @override
  _CarrinhoPageState createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> 
{
  double calcularTotal() 
  {
    double total = 0.0;
    for (var item in widget.carrinho) 
    {
      final preco = double.tryParse(item['preco'].replaceAll('R\$', '').replaceAll(',', '.')) ?? 0.0;
      total += preco * item['quantidade'];
    }
    return total;
  }

  void removerUmItem(int index) 
  {
    setState(() 
    {
      if (widget.carrinho[index]['quantidade'] > 1) 
      {
        widget.carrinho[index]['quantidade']--;
      } 
      else 
      {
        widget.carrinho.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar( title: Text('Carrinho de Compras',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: Colors.white) ), backgroundColor: Colors.red),
      body: widget.carrinho.isEmpty
          ? Center(child: Text('O carrinho está vazio.'))
          : Column
          (
              children: 
              [
                Expanded
                (
                  child: ListView.builder
                  (
                    itemCount: widget.carrinho.length,
                    itemBuilder: (context, index) 
                    {
                      return ListTile
                      (
                        leading: Image.asset(widget.carrinho[index]['imagem'], width: 50),
                        title: Text(widget.carrinho[index]['nome']!),
                        subtitle: Text('Quantidade: ${widget.carrinho[index]['quantidade']} - ${widget.carrinho[index]['preco']} cada'),
                        trailing: IconButton
                        (
                          icon: Icon(Icons.remove_circle),
                          onPressed: () 
                          {
                            removerUmItem(index);
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column
                  (
                    children: 
                    [
                      Text ('Total: R\$ ${calcularTotal().toStringAsFixed(2)}',style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () 
                        {
                          widget.limparCarrinho();
                          ScaffoldMessenger.of(context).showSnackBar
                          (
                            SnackBar(content: Text('Compra realizada com sucesso!')),
                          );
                          Navigator.pop(context);
                        },
                        child: Text('Comprar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
class CategoriaPag extends StatelessWidget 
{
  final String categoria;

  CategoriaPag({required this.categoria});

  @override
  Widget build(BuildContext context) 
  {
    final produtosCategoria = produtos.where((produto) 
    {
      return produto['categoria'] == categoria;
    }).toList();

    return Scaffold(
      appBar: AppBar( title: Text( categoria,style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold,color: Colors.white)),backgroundColor: Colors.red),
      body: produtosCategoria.isEmpty
          ? Center(child: Text('Nenhum produto disponível nesta categoria.'))
          : GridView.builder
           (
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount (crossAxisCount: 5,childAspectRatio: 0.6,crossAxisSpacing: 10,mainAxisSpacing: 10,),
              itemCount: produtosCategoria.length,
              itemBuilder: (context, index) 
              {
                return produtoItem(produtosCategoria[index], [], (fn) => fn());
              },
            ),
    );
  }
}
class ProdutoSearchDelegate extends SearchDelegate 
{
  final List<Map<String, dynamic>> carrinho;
  final Function setState;

  ProdutoSearchDelegate(this.carrinho, this.setState);

  @override
  List<Widget> buildActions(BuildContext context) 
  {
    return 
    [
      IconButton
      (
        icon: Icon(Icons.clear),
        onPressed: () 
        {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) 
  {
    return IconButton
    (
      icon: Icon(Icons.arrow_back),
      onPressed: () 
      {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) 
  {
    final resultados = produtos.where((produto) 
    {
      return produto['nome']!.toLowerCase().contains(query.toLowerCase());
    }
    )
    .toList();

    return ListView.builder
    (
      itemCount: resultados.length,
      itemBuilder: (context, index) 
      {
        return ListTile
        (
          title: Text(resultados[index]['nome']!),
          subtitle: Text(resultados[index]['preco']!),
          leading: Image.asset(resultados[index]['imagem'], width: 500),
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              setState(() 
              {
                if (carrinho.contains(resultados[index])) 
                {
                  resultados[index]['quantidade']++;
                } 
                else
                {
                  carrinho.add(resultados[index]);
                }
              }
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) 
  {
    final suggestions = produtos.where((produto) 
    {
      return produto['nome']!.toLowerCase().contains(query.toLowerCase());
    }
    )
    .toList();

    return ListView.builder
    (
      itemCount: suggestions.length,
      itemBuilder: (context, index) 
      {
        return ListTile(
          title: Text(suggestions[index]['nome']!),
          subtitle: Text(suggestions[index]['preco']!),
          leading: Image.asset(suggestions[index]['imagem'], width: 50),
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () 
            {
              setState(() 
              {
                if (carrinho.contains(suggestions[index]))
                {
                  suggestions[index]['quantidade']++;
                } 
                else 
                {
                  carrinho.add(suggestions[index]);
                }
              });
            },
          ),
        );
      },
    );
  }
}

final List<Map<String, dynamic>> produtos = [
  // Vinhos
  {'nome': 'Vinho Tinto Seco', 'preco': 'R\$ 40.00', 'imagem': 'imagens/tinto_seco.jpg', 'categoria': 'Vinhos', 'quantidade': 1, 'promocao': true},
  {'nome': 'Vinho Branco Doce', 'preco': 'R\$ 50.00', 'imagem': 'imagens/vinho_branco.jpg', 'categoria': 'Vinhos', 'quantidade': 1, 'promocao': false},
  {'nome': 'Vinho Rosé', 'preco': 'R\$ 45.00', 'imagem': 'imagens/vinho_rose.jpg', 'categoria': 'Vinhos', 'quantidade': 1, 'promocao': false},

  // Queijos
  {'nome': 'Queijo Brie', 'preco': 'R\$ 30.00', 'imagem': 'imagens/queijo_brie.jpg', 'categoria': 'Queijos', 'quantidade': 1, 'promocao': true},
  {'nome': 'Queijo Gouda', 'preco': 'R\$ 28.00', 'imagem': 'imagens/queijo_gouda.jpg', 'categoria': 'Queijos', 'quantidade': 1, 'promocao': false},
  {'nome': 'Queijo Parmesão', 'preco': 'R\$ 35.00', 'imagem': 'imagens/queijo_parmesao.jpg', 'categoria': 'Queijos', 'quantidade': 1, 'promocao': false},

  // Embutidos
  {'nome': 'Salame Italiano', 'preco': 'R\$ 25.00', 'imagem': 'imagens/salame_italiano.jpg', 'categoria': 'Embutidos', 'quantidade': 1, 'promocao': false},
  {'nome': 'Presunto Parma', 'preco': 'R\$ 40.00', 'imagem': 'imagens/presunto_de_parma.jpg', 'categoria': 'Embutidos', 'quantidade': 1, 'promocao': true},
  {'nome': 'Mortadela Italiana', 'preco': 'R\$ 22.00', 'imagem': 'imagens/mortadela_italiana.jpg', 'categoria': 'Embutidos', 'quantidade': 1, 'promocao': false},

  // Carnes
  {'nome': 'Picanha Maturada', 'preco': 'R\$ 70.00', 'imagem': 'imagens/picanha_maturada.jpg', 'categoria': 'Carnes', 'quantidade': 1, 'promocao': false},
  {'nome': 'Costela Suína', 'preco': 'R\$ 55.00', 'imagem': 'imagens/costela_suina.jpg', 'categoria': 'Carnes', 'quantidade': 1, 'promocao': true},

  // Doces & Geleias
  {'nome': 'Doce de Leite', 'preco': 'R\$ 15.00', 'imagem': 'imagens/doce_de_leite.jpg', 'categoria': 'Doces & Geleias', 'quantidade': 1, 'promocao': false},
  {'nome': 'Geleia de Morango', 'preco': 'R\$ 18.00', 'imagem': 'imagens/geleia_de_morango.jpg', 'categoria': 'Doces & Geleias', 'quantidade': 1, 'promocao': true},
  {'nome': 'Doce de Abóbora', 'preco': 'R\$ 12.00', 'imagem': 'imagens/doce_de_abobora.jpg', 'categoria': 'Doces & Geleias', 'quantidade': 1, 'promocao': false},

  // Pimentas
  {'nome': 'Pimenta Malagueta', 'preco': 'R\$ 10.00', 'imagem': 'imagens/pimenta_malagueta.jpg', 'categoria': 'Pimentas', 'quantidade': 1, 'promocao': false},
  {'nome': 'Pimenta Jalapeño', 'preco': 'R\$ 12.00', 'imagem': 'imagens/pimenta_jalapeno.jpg', 'categoria': 'Pimentas', 'quantidade': 1, 'promocao': true},
  {'nome': 'Pimenta Biquinho', 'preco': 'R\$ 8.00', 'imagem': 'imagens/pimenta_biquinho.jpg', 'categoria': 'Pimentas', 'quantidade': 1, 'promocao': false},
];
