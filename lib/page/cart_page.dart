import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bo/article.dart';
import '../bo/cart.dart';

import 'package:go_router/go_router.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});
  final List<Article> listArticles = <Article>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EPSI Shop"),
      ),
      body: Consumer<Cart>(
        builder: (BuildContext context, Cart cart, Widget? child) {
          return cart.listArticles.isEmpty
              ? const EmptyCart()
              : ListCart(
                  listArticles: cart.listArticles,
                  prixEuro: cart.getTotalPrice(),
                );
        },
      ),
    );
  }
}

class ListCart extends StatelessWidget {
  final List<Article> listArticles;
  final String prixEuro;
  const ListCart({super.key, 
    required this.listArticles,
    required this.prixEuro,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Votre panier total est de "),
                Text(
                  prixEuro,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: listArticles.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(listArticles[index].nom),
                subtitle: Text(listArticles[index].getPrixEuro()),
                leading: Image.network(
                  listArticles[index].image,
                  width: 80,
                ),
                trailing: TextButton(
                  child: const Text("SUPPRIMER"),
                  onPressed: () {
                    context.read<Cart>().remove(listArticles[index]);
                  },
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: ElevatedButton(
              onPressed: () => context.go('/cart/buy'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                'Procéder au paiement',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Votre panier est actuellement vide"),
                Icon(Icons.image)
              ],
            ),
          )
        ],
      ),
    );
  }
}
