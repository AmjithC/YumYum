import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  static const _filters = ['All', 'Active', 'Completed', 'Cancelled'];
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('My orders')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.paleYellow,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  for (final filter in _filters)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _filter = filter),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: BoxDecoration(
                            color: _filter == filter
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Text(
                            filter,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _filter == filter
                                  ? Colors.white
                                  : AppColors.dark,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: user == null
                ? const _OrdersEmptyState(
                    message: 'Sign in to see your order history.',
                  )
                : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('orders')
                        .where('uid', isEqualTo: user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const _OrdersEmptyState(
                          message: 'Your orders could not be loaded.',
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        );
                      }
                      final documents = snapshot.data?.docs.toList() ?? [];
                      documents.sort((a, b) {
                        final aDate = a.data()['createdAt'];
                        final bDate = b.data()['createdAt'];
                        final aMillis = aDate is Timestamp
                            ? aDate.millisecondsSinceEpoch
                            : 0;
                        final bMillis = bDate is Timestamp
                            ? bDate.millisecondsSinceEpoch
                            : 0;
                        return bMillis.compareTo(aMillis);
                      });
                      final orders = documents.where((document) {
                        if (_filter == 'All') return true;
                        final status =
                            (document.data()['status'] as String? ?? 'Active')
                                .toLowerCase();
                        if (_filter == 'Active') {
                          return status == 'active' ||
                              status == 'preparing' ||
                              status == 'on the way';
                        }
                        return status == _filter.toLowerCase();
                      }).toList();

                      if (orders.isEmpty) {
                        return _OrdersEmptyState(
                          message: _filter == 'All'
                              ? 'Your next favourite meal is one order away.'
                              : 'No $_filter orders yet.',
                        );
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                        itemCount: orders.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) =>
                            _OrderCard(data: orders[index].data()),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _OrderCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final status = data['status'] as String? ?? 'Active';
    final items = data['items'] is List ? data['items'] as List : const [];
    final timestamp = data['createdAt'];
    final date = timestamp is Timestamp ? timestamp.toDate() : null;
    final dateText = date == null
        ? 'Recently placed'
        : '${_month(date.month)} ${date.day}, ${date.year}';
    final total = data['total'];
    final totalText = total is num ? total.toStringAsFixed(2) : '0.00';
    final leadingItems = items.take(2).whereType<Map>().toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  dateText,
                  style: const TextStyle(
                    color: AppColors.dark,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _StatusBadge(status: status),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in leadingItems)
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.paleYellow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.restaurant,
                        color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${item['name'] ?? 'Food item'}'
                      '${item['qty'] is num ? '  × ${item['qty']}' : ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.dark,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '\$${((item['price'] is num ? item['price'] as num : 0) * (item['qty'] is num ? item['qty'] as num : 1)).toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          if (items.length > 2)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '+ ${items.length - 2} more items',
                style: const TextStyle(color: AppColors.grey, fontSize: 10),
              ),
            ),
          const Divider(height: 18),
          Row(
            children: [
              const Expanded(
                child: Text('Total',
                    style: TextStyle(color: AppColors.grey, fontSize: 12)),
              ),
              Text(
                '\$$totalText',
                style: const TextStyle(
                  color: AppColors.dark,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _month(int month) => const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ][month - 1];
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final completed = status.toLowerCase() == 'completed';
    final cancelled = status.toLowerCase() == 'cancelled';
    final color = cancelled
        ? const Color(0xFFD66A55)
        : completed
            ? const Color(0xFF5C9B73)
            : AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _OrdersEmptyState extends StatelessWidget {
  final String message;
  const _OrdersEmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: const BoxDecoration(
                color: AppColors.paleYellow,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.receipt_long,
                  color: AppColors.primary, size: 42),
            ),
            const SizedBox(height: 16),
            const Text(
              'No orders to show',
              style: TextStyle(
                color: AppColors.dark,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
