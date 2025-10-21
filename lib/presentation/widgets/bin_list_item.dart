import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/models/bin_model.dart';

class BinListItem extends StatelessWidget {
  final BinModel bin;

  const BinListItem({super.key, required this.bin});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(bin.status).withValues(alpha: 0.2),
          child: Icon(Icons.delete, color: _getStatusColor(bin.status)),
        ),
        title: Text(
          bin.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(bin.location),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: bin.fillLevel / 100,
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(
                        _getStatusColor(bin.status),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${bin.fillLevel.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(bin.status),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Updated: ${DateFormat('MMM dd, HH:mm').format(bin.lastUpdated)}',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: () => context.push('/bin/${bin.id}'),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Color _getStatusColor(BinStatus status) {
    switch (status) {
      case BinStatus.normal:
        return Colors.green;
      case BinStatus.warning:
        return Colors.orange;
      case BinStatus.full:
        return Colors.red;
    }
  }
}
