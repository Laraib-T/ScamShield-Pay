import 'package:flutter/material.dart';

import '../../models/compare_result.dart';
import '../../services/compare_service.dart';

class _SellerInput {
  final TextEditingController url = TextEditingController();
  final TextEditingController price = TextEditingController();
  bool claimsOfficial = false;

  void dispose() {
    url.dispose();
    price.dispose();
  }
}

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  final TextEditingController brand = TextEditingController();
  final TextEditingController product = TextEditingController();
  final List<_SellerInput> sellers = List.generate(3, (_) => _SellerInput());

  bool loading = false;
  String? error;
  CompareResult? result;

  @override
  void dispose() {
    brand.dispose();
    product.dispose();
    for (final s in sellers) {
      s.dispose();
    }
    super.dispose();
  }

  Future<void> runCompare() async {
    if (brand.text.trim().isEmpty || product.text.trim().isEmpty) {
      setState(() => error = 'Please enter the brand and the product name.');
      return;
    }

    final listings = <Map<String, dynamic>>[];

    for (final s in sellers) {
      final url = s.url.text.trim();
      if (url.isEmpty) continue;

      final price = double.tryParse(s.price.text.trim());
      if (price == null || price <= 0) {
        setState(() => error = 'Enter a valid price for every seller you add.');
        return;
      }

      listings.add({
        'url': url,
        'price': price,
        'claimsOfficial': s.claimsOfficial,
      });
    }

    if (listings.isEmpty) {
      setState(() => error = 'Add at least one seller website.');
      return;
    }

    setState(() {
      loading = true;
      error = null;
      result = null;
    });

    try {
      final r = await CompareService.compare(
        brand: brand.text.trim(),
        product: product.text.trim(),
        listings: listings,
      );
      if (!mounted) return;
      setState(() => result = r);
    } catch (e) {
      if (!mounted) return;
      final text = e.toString();
      setState(() {
        error = (text.contains('Failed to fetch') || text.contains('ClientException'))
            ? 'Cannot reach the ScamShield server. Make sure the backend is running.'
            : text.replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Color noteColor(String type) {
    switch (type) {
      case 'good':
        return Colors.green;
      case 'warn':
        return Colors.orange;
      case 'bad':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  IconData noteIcon(String type) {
    switch (type) {
      case 'good':
        return Icons.check_circle_rounded;
      case 'warn':
        return Icons.warning_amber_rounded;
      case 'bad':
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  Color verdictColor(String verdict) {
    switch (verdict) {
      case 'safe':
        return Colors.green;
      case 'risky':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  Widget sellerForm(int index) {
    final s = sellers[index];
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seller ${index + 1}${index == 2 ? ' (optional)' : ''}',
              style: TextStyle(fontWeight: FontWeight.bold, color: cs.primary),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: s.url,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Website link',
                hintText: 'https://shop.example.com/product',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: s.price,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Price (same currency for all sellers)',
                border: OutlineInputBorder(),
              ),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              value: s.claimsOfficial,
              onChanged: (v) => setState(() => s.claimsOfficial = v ?? false),
              title: const Text('Seller says it is an official partner'),
            ),
          ],
        ),
      ),
    );
  }

  Widget resultCard(SellerResult r, bool isBest) {
    final color = verdictColor(r.verdict);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: isBest ? color : Colors.transparent, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    r.domain,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '${r.trustScore}',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: color),
                ),
                const Text(' / 100'),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: r.trustScore / 100,
                minHeight: 8,
                color: color,
                backgroundColor: color.withValues(alpha: 0.15),
              ),
            ),
            const SizedBox(height: 12),
            ...r.notes.map(
              (n) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(noteIcon(n.type), size: 18, color: noteColor(n.type)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(n.text, style: const TextStyle(fontSize: 13))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResults() {
    final res = result!;
    final best = res.results[res.bestIndex];
    final verified = best.authorization == 'verified';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: (verified ? Colors.green : Colors.orange).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            verified
                ? 'Best verified option: ${best.domain}'
                : 'None of these sellers could be verified from the brand registry. '
                    'Higher score only means fewer warning signs.',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 12),
        for (int i = 0; i < res.results.length; i++)
          resultCard(res.results[i], i == res.bestIndex),
        const Text(
          'These checks collect evidence. They are an estimate, not a guarantee.',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compare Sellers'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Same product on different websites? Enter them to see which seller has the strongest evidence.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: brand,
              decoration: const InputDecoration(
                labelText: 'Brand',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: product,
              decoration: const InputDecoration(
                labelText: 'Product name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < sellers.length; i++) sellerForm(i),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              ),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: loading ? null : runCompare,
                child: loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      )
                    : const Text('Compare Sellers'),
              ),
            ),
            if (result != null) buildResults(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}