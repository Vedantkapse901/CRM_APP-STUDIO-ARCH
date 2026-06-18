import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../widgets/base_scaffold.dart';

class ClientsListScreen extends StatelessWidget {
  const ClientsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'Clients',
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: AppColors.textLighter,
            ),
            const SizedBox(height: 16),
            const Text(
              'No clients yet',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
