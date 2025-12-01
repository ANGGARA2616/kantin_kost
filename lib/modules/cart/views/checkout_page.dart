import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:latlong2/latlong.dart';

import '../controllers/cart_controller.dart';
import '../../../data/repositories/order_repository.dart';
import '../../location/views/location_status_widget.dart';

class CheckoutPage extends GetView<CartController> {
  final _formKey = GlobalKey<FormState>();
  final _roomNumberController = TextEditingController();
  final _notesController = TextEditingController();

  CheckoutPage({super.key}) {
    _roomNumberController.text = controller.roomNumber.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Obx(() {
        if (controller.isCartEmpty) {
          return const Center(
            child: Text('Keranjang kosong'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderSummary(),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _roomNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Alamat *',
                    prefixIcon: Icon(Icons.home),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat harus di isi';
                    }
                    return null;
                  },
                  onChanged: (value) => controller.roomNumber.value = value,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Lokasi Pengantaran',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                LocationStatusWidget(
                  onTap: () async {
                    final result = await Get.toNamed('/map');
                    if (result != null) {
                      //final LatLng location = result['location'];
                      final double? distance = result['distance'];

                      Get.snackbar('Lokasi Dipilih',
                          'Jarak: ${distance?.toStringAsFixed(2) ?? '0'} km');
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Catatan Tambahan (Opsional)',
                    prefixIcon: Icon(Icons.note),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onChanged: (value) => controller.notes.value = value,
                ),
                const SizedBox(height: 24),
                _buildPaymentMethod(),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _checkout,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Pesan Sekarang'),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildOrderSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Pesanan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...controller.cartItems.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${item.product.name} (${item.quantity}x)'),
                      Text(
                          'Rp ${(item.product.price * item.quantity).toStringAsFixed(0)}'),
                    ],
                  ),
                )),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                  'Rp ${controller.totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Metode Pembayaran',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Obx(() => Row(
              children: [
                Expanded(
                  child: RadioListTile.adaptive(
                    title: const Text('Cash on Delivery'),
                    value: 'Cash',
                    groupValue: controller.paymentMethod.value,
                    onChanged: (value) {
                      if (value != null) controller.paymentMethod.value = value;
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile.adaptive(
                    title: const Text('QRIS'),
                    value: 'QRIS',
                    groupValue: controller.paymentMethod.value,
                    onChanged: (value) {
                      if (value != null) controller.paymentMethod.value = value;
                    },
                  ),
                ),
              ],
            )),
      ],
    );
  }

  void _checkout() async {
    if (_formKey.currentState!.validate()) {
      try {
        final orderRepository = Get.find<OrderRepository>();
        await orderRepository.createOrder(
          cartItems: controller.cartItems,
          roomNumber: controller.roomNumber.value,
          notes: controller.notes.value,
          paymentMethod: controller.paymentMethod.value,
        );
        controller.clearCart();
        Get.offAllNamed('/home');
        Get.snackbar('Success', 'Pesanan berhasil dibuat!');
      } catch (e) {
        Get.snackbar('Error', 'Gagal membuat pesanan: $e');
      }
    }
  }
}
