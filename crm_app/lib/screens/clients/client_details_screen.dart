import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../widgets/base_scaffold.dart';

class ClientDetailsScreen extends StatelessWidget {
  final String clientId;

  const ClientDetailsScreen({
    Key? key,
    required this.clientId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Client Details',
      body: const Center(
        child: Text('Client details will be displayed here'),
      ),
    );
  }
}
