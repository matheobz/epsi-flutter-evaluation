import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../bo/cart.dart';

class BuyPage extends StatefulWidget {
  const BuyPage({super.key});

  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  String? selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {


    
    final cart = Provider.of<Cart>(context);
    final double subTotal = cart.getSubTotal();
    final double tva = subTotal * 0.20;
    final double total = subTotal + tva;

    const address = 'Michel Le Poney\n8 rue des ouvertures de portes\n93204 COBREAUX';

    final jsonData = {
      'total': total,
      'address': address,
      'paymentMethod': selectedPaymentMethod,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalisation de la commande'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Theme.of(context).colorScheme.outline),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Récapitulatif de votre commande',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Sous-Total'),
                            Text('${subTotal.toStringAsFixed(2)}€'),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Vous économisez', style: TextStyle(color: Colors.green)),
                            Text('-0.00€', style: TextStyle(color: Colors.green)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('TVA (20%)'),
                            Text('${tva.toStringAsFixed(2)}€'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('${total.toStringAsFixed(2)}€', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Adresse de livraison',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Theme.of(context).colorScheme.outline),
                  ),
                  child: ListTile(
                    subtitle: Text(address),
                    trailing: const Icon(Icons.navigate_next),
                    onTap: () {// Boutton de l'adresse mais qui marche pas
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Méthode de paiement',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPaymentOption(FontAwesomeIcons.apple, 'apple_pay', Theme.of(context).colorScheme.primary, isPayPal: true),
                    _buildPaymentOption(FontAwesomeIcons.ccVisa, 'visa', Theme.of(context).colorScheme.primary, isPayPal: true),
                    _buildPaymentOption(FontAwesomeIcons.ccMastercard, 'master_card', Theme.of(context).colorScheme.primary, isPayPal: true),
                    _buildPaymentOption(FontAwesomeIcons.paypal, 'paypal', Theme.of(context).colorScheme.primary, isPayPal: true),
                  ],
                ),
              ],
            ),
          ),
          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        Text(
          'En cliquant sur \'Confirmer l\'achat\', vous acceptez les Conditions de vente de EPSI Shop International. Besoin d’aide ? Désolé on peut rien faire.\n\nEn poursuivant, vous acceptez Les Conditions d\'utilisation du fournisseur de paiement CoffeeDis.',
          style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16.0),
          ElevatedButton(
  style: ElevatedButton.styleFrom(
    minimumSize: const Size.fromHeight(50),
    backgroundColor: selectedPaymentMethod != null ? Theme.of(context).primaryColor : Colors.grey,
  ),
  onPressed: selectedPaymentMethod != null
      ? () {
          //_envoyerCommande(jsonData); // Appel de la méthode d'envoi de la commande
        }
      : null,
  child: const Text(
    'Confirmer l\'achat',
    style: TextStyle(fontSize: 18.0, color: Colors.white),
  ),
),

        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildPaymentOption(IconData icon, String paymentMethod, Color color, {bool isPayPal = false}) {
    final isSelected = selectedPaymentMethod == paymentMethod;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = paymentMethod;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: FittedBox(
          child: Icon(
            icon,
            color: isPayPal && isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
