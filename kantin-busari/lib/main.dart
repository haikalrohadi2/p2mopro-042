import 'package:flutter/material.dart';

void main() => runApp(const KantinBuSariApp());

const Color brand = Color(0xFFB94725);
const Color cream = Color(0xFFFFF9F0);
const Color ink = Color(0xFF2B211D);

class KantinBuSariApp extends StatelessWidget {
  const KantinBuSariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin Bu Sari',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: brand, surface: cream),
        appBarTheme: const AppBarTheme(
          backgroundColor: cream,
          foregroundColor: ink,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const MenuListPage(),
        '/pesan': (_) => const CartPage(),
        '/riwayat': (_) => const HistoryPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final item = settings.arguments as MenuItem? ?? menuItems.first;
          return MaterialPageRoute(builder: (_) => MenuDetailPage(item: item));
        }
        return null;
      },
    );
  }
}

class MenuItem {
  final String name, description, category, emoji;
  final int price;
  final double rating;
  const MenuItem({
    required this.name, required this.description, required this.category,
    required this.emoji, required this.price, this.rating = 4.8,
  });
}

const List<MenuItem> menuItems = [
  MenuItem(name: 'Nasi Goreng Spesial', description: 'Nasi goreng gurih dengan telur, ayam suwir, dan kerupuk.', category: 'Makanan', emoji: '🍛', price: 18000, rating: 4.9),
  MenuItem(name: 'Ayam Geprek', description: 'Ayam renyah dengan sambal geprek dan nasi hangat.', category: 'Makanan', emoji: '🍗', price: 17000, rating: 4.8),
  MenuItem(name: 'Mie Goreng Jawa', description: 'Mie goreng dengan sayuran segar dan bumbu khas.', category: 'Makanan', emoji: '🍜', price: 15000, rating: 4.7),
  MenuItem(name: 'Soto Ayam', description: 'Soto ayam hangat dengan koya, seledri, dan jeruk nipis.', category: 'Makanan', emoji: '🍲', price: 16000, rating: 4.8),
  MenuItem(name: 'Es Teh Manis', description: 'Teh pilihan dengan es batu, segar untuk menemani makan.', category: 'Minuman', emoji: '🧋', price: 5000, rating: 4.7),
  MenuItem(name: 'Jus Alpukat', description: 'Jus alpukat creamy yang dibuat saat dipesan.', category: 'Minuman', emoji: '🥑', price: 12000, rating: 4.9),
  MenuItem(name: 'Pisang Goreng', description: 'Pisang goreng hangat dengan tekstur renyah di luar.', category: 'Camilan', emoji: '🍌', price: 8000, rating: 4.6),
  MenuItem(name: 'Tahu Crispy', description: 'Tahu berbumbu dengan taburan bumbu gurih.', category: 'Camilan', emoji: '🍘', price: 7000, rating: 4.6),
];

class CartEntry {
  final MenuItem item;
  int quantity;
  CartEntry(this.item, this.quantity);
}

class OrderStore {
  static final List<CartEntry> cart = [];
  static final List<String> history = [];

  static void add(MenuItem item, int quantity) {
    final index = cart.indexWhere((entry) => entry.item.name == item.name);
    if (index >= 0) {
      cart[index].quantity += quantity;
    } else {
      cart.add(CartEntry(item, quantity));
    }
  }

  static int get count => cart.fold(0, (sum, item) => sum + item.quantity);
  static int get total => cart.fold(0, (sum, item) => sum + item.item.price * item.quantity);
  static String rupiah(int value) => 'Rp${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
}

class MenuListPage extends StatefulWidget {
  const MenuListPage({super.key});
  @override
  State<MenuListPage> createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  final searchController = TextEditingController();
  String category = 'Semua';
  final categories = const ['Semua', 'Makanan', 'Minuman', 'Camilan'];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = menuItems.where((item) {
      final matchesCategory = category == 'Semua' || item.category == category;
      final matchesSearch = item.name.toLowerCase().contains(searchController.text.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [
          CircleAvatar(backgroundColor: brand, child: Icon(Icons.restaurant, color: Colors.white)),
          SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Kantin Bu Sari', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
            Text('Masakan rumahan, rasa istimewa', style: TextStyle(fontSize: 11, color: Colors.black54)),
          ]),
        ]),
        actions: [
          IconButton(
            tooltip: 'Keranjang',
            onPressed: () => Navigator.pushNamed(context, '/pesan').then((_) => setState(() {})),
            icon: Badge(label: Text('${OrderStore.count}'), isLabelVisible: OrderStore.count > 0, child: const Icon(Icons.shopping_bag_outlined)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(colors: [Color(0xFFB94725), Color(0xFFDA7547)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Lapar? Yuk, makan!', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  const Text('Menu favorit dibuat segar setiap hari.', style: TextStyle(color: Colors.white, height: 1.4)),
                  const SizedBox(height: 14),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: brand),
                    onPressed: () => setState(() => category = 'Makanan'),
                    child: const Text('Lihat menu'),
                  ),
                ])),
                const SizedBox(width: 6),
                const Text('🍱', style: TextStyle(fontSize: 66)),
              ]),
            ),
            const SizedBox(height: 22),
            const Text('Mau makan apa hari ini?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: ink)),
            const SizedBox(height: 12),
            TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Cari nasi goreng, minuman...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isEmpty ? null : IconButton(icon: const Icon(Icons.close), onPressed: () { searchController.clear(); setState(() {}); }),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final value = categories[index];
                  return ChoiceChip(
                    label: Text(value),
                    selected: category == value,
                    onSelected: (_) => setState(() => category = value),
                    selectedColor: brand,
                    labelStyle: TextStyle(color: category == value ? Colors.white : ink, fontWeight: FontWeight.w600),
                    side: BorderSide.none,
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Menu pilihan', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: ink)),
              Text('${filtered.length} menu', style: const TextStyle(color: Colors.black54)),
            ]),
            const SizedBox(height: 12),
            if (filtered.isEmpty)
              const Padding(padding: EdgeInsets.all(28), child: Center(child: Text('Menu tidak ditemukan. Coba kata kunci lain.')))
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .72),
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  return MenuCard(item: item, onTap: () => Navigator.pushNamed(context, '/detail', arguments: item).then((_) => setState(() {})));
                },
              ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/riwayat'),
              icon: const Icon(Icons.receipt_long_outlined),
              label: const Text('Lihat riwayat pesanan'),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;
  const MenuCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFFF0E7DE))),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(color: const Color(0xFFFFE8D9), borderRadius: BorderRadius.circular(15)),
                child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 52))),
              ),
            ),
            const SizedBox(height: 10),
            Text(item.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: ink)),
            const SizedBox(height: 5),
            Row(children: [const Icon(Icons.star_rounded, color: Color(0xFFE4A326), size: 16), const SizedBox(width: 3), Text(item.rating.toString(), style: const TextStyle(fontSize: 12, color: Colors.black54)), const Spacer(), Text(item.category, style: const TextStyle(fontSize: 10, color: Colors.black54))]),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: Text(OrderStore.rupiah(item.price), style: const TextStyle(fontWeight: FontWeight.w800, color: brand, fontSize: 13))),
              const CircleAvatar(radius: 15, backgroundColor: brand, child: Icon(Icons.add, color: Colors.white, size: 18)),
            ]),
          ]),
        ),
      ),
    );
  }
}

class MenuDetailPage extends StatefulWidget {
  final MenuItem item;
  const MenuDetailPage({super.key, required this.item});
  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail menu'), actions: [
        IconButton(onPressed: () => Navigator.pushNamed(context, '/pesan'), icon: Badge(label: Text('${OrderStore.count}'), isLabelVisible: OrderStore.count > 0, child: const Icon(Icons.shopping_bag_outlined))),
      ]),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Container(height: 230, decoration: BoxDecoration(color: const Color(0xFFFFE8D9), borderRadius: BorderRadius.circular(28)), child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 115)))),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(child: Text(item.name, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: ink))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7), decoration: BoxDecoration(color: const Color(0xFFFFE8D9), borderRadius: BorderRadius.circular(20)), child: Text(item.category, style: const TextStyle(color: brand, fontWeight: FontWeight.w700))),
        ]),
        const SizedBox(height: 8),
        Row(children: [const Icon(Icons.star_rounded, color: Color(0xFFE4A326)), Text('${item.rating}  •  Favorit pelanggan', style: const TextStyle(color: Colors.black54))]),
        const SizedBox(height: 16),
        Text(OrderStore.rupiah(item.price), style: const TextStyle(fontSize: 23, color: brand, fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        const Text('Tentang menu', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
        const SizedBox(height: 6),
        Text(item.description, style: const TextStyle(color: Colors.black54, height: 1.6)),
        const SizedBox(height: 20),
        const Text('Jumlah pesanan', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Row(children: [
          IconButton.filledTonal(onPressed: quantity > 1 ? () => setState(() => quantity--) : null, icon: const Icon(Icons.remove)),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text('$quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
          IconButton.filledTonal(onPressed: () => setState(() => quantity++), icon: const Icon(Icons.add)),
          const Spacer(),
          Text(OrderStore.rupiah(item.price * quantity), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        ]),
        const SizedBox(height: 24),
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: brand, padding: const EdgeInsets.all(17)),
          onPressed: () {
            OrderStore.add(item, quantity);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$quantity ${item.name} ditambahkan ke keranjang'), action: SnackBarAction(label: 'Lihat', onPressed: () => Navigator.pushNamed(context, '/pesan'))));
            Navigator.pop(context);
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Tambah ke keranjang'),
        ),
      ]),
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final nameController = TextEditingController();
  String payment = 'Tunai di kasir';
  final noteController = TextEditingController();

  @override
  void dispose() { nameController.dispose(); noteController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang & checkout')),
      body: OrderStore.cart.isEmpty
          ? Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('🛍️', style: TextStyle(fontSize: 66)),
              const SizedBox(height: 12),
              const Text('Keranjang masih kosong', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text('Pilih menu favoritmu dari halaman utama.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 18),
              FilledButton(onPressed: () => Navigator.popUntil(context, (route) => route.isFirst), child: const Text('Jelajahi menu')),
            ])))
          : ListView(padding: const EdgeInsets.all(18), children: [
              const Text('Pesanan kamu', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: ink)),
              const SizedBox(height: 12),
              ...OrderStore.cart.map((entry) => Card(
                color: Colors.white, elevation: 0, child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [
                  Container(width: 58, height: 58, decoration: BoxDecoration(color: const Color(0xFFFFE8D9), borderRadius: BorderRadius.circular(14)), child: Center(child: Text(entry.item.emoji, style: const TextStyle(fontSize: 30)))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(entry.item.name, style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 5),
                    Text(OrderStore.rupiah(entry.item.price), style: const TextStyle(color: brand)),
                  ])),
                  IconButton(onPressed: () => setState(() { if (entry.quantity > 1) { entry.quantity--; } else { OrderStore.cart.remove(entry); } }), icon: const Icon(Icons.remove_circle_outline)),
                  Text('${entry.quantity}', style: const TextStyle(fontWeight: FontWeight.w800)),
                  IconButton(onPressed: () => setState(() => entry.quantity++), icon: const Icon(Icons.add_circle_outline)),
                ])),
              )),
              const SizedBox(height: 18),
              const Text('Informasi pemesan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              TextField(controller: nameController, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Nama pemesan', prefixIcon: Icon(Icons.person_outline))),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: payment,
                decoration: const InputDecoration(labelText: 'Metode pembayaran', prefixIcon: Icon(Icons.payments_outlined)),
                items: const [DropdownMenuItem(value: 'Tunai di kasir', child: Text('Tunai di kasir')), DropdownMenuItem(value: 'QRIS', child: Text('QRIS')), DropdownMenuItem(value: 'Transfer bank', child: Text('Transfer bank'))],
                onChanged: (value) => setState(() => payment = value ?? payment),
              ),
              const SizedBox(height: 12),
              TextField(controller: noteController, maxLines: 2, decoration: const InputDecoration(labelText: 'Catatan pesanan (opsional)', prefixIcon: Icon(Icons.notes))),
              const SizedBox(height: 20),
              Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)), child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total pesanan'), Text(OrderStore.rupiah(OrderStore.total), style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: brand))]),
                const SizedBox(height: 6),
                const Align(alignment: Alignment.centerLeft, child: Text('Pastikan pesanan sudah sesuai sebelum dikonfirmasi.', style: TextStyle(color: Colors.black54, fontSize: 12))),
              ])),
              const SizedBox(height: 14),
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: brand, padding: const EdgeInsets.all(17)),
                onPressed: () {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Isi nama pemesan terlebih dahulu.')));
                    return;
                  }
                  final summary = '${nameController.text.trim()} • ${OrderStore.count} item • ${OrderStore.rupiah(OrderStore.total)} • $payment';
                  OrderStore.history.insert(0, summary);
                  OrderStore.cart.clear();
                  showDialog(context: context, barrierDismissible: false, builder: (dialogContext) => AlertDialog(
                    icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
                    title: const Text('Pesanan berhasil!'),
                    content: Text('Terima kasih, ${nameController.text.trim()}. Tunjukkan konfirmasi ini kepada kasir Bu Sari.'),
                    actions: [FilledButton(onPressed: () { Navigator.pop(dialogContext); Navigator.popUntil(context, (route) => route.isFirst); }, child: const Text('Selesai'))],
                  )).then((_) => setState(() {}));
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Konfirmasi pesanan'),
              ),
            ]),
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat pesanan')),
      body: OrderStore.history.isEmpty
          ? const Center(child: Padding(padding: EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.receipt_long_outlined, size: 60, color: brand),
              SizedBox(height: 12),
              Text('Belum ada riwayat', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              SizedBox(height: 8),
              Text('Pesanan yang sudah dikonfirmasi akan muncul di sini.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
            ])))
          : ListView.separated(
              padding: const EdgeInsets.all(18),
              itemCount: OrderStore.history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) => Card(
                color: Colors.white, elevation: 0,
                child: ListTile(
                  leading: const CircleAvatar(backgroundColor: Color(0xFFFFE8D9), child: Icon(Icons.receipt_long, color: brand)),
                  title: Text('Pesanan #${OrderStore.history.length - index}', style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text(OrderStore.history[index]),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              ),
            ),
    );
  }
}
