import 'package:flutter/material.dart';
import '../controller/calc_controller.dart';

class MemoryDrawer extends StatelessWidget {
  final CalculatorController controller;

  const MemoryDrawer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'MEMORY',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: controller.memory.isNotEmpty
                  ? ListView.builder(
                      itemCount: controller.memory.length,
                      itemBuilder: (context, index) {
                        final item = controller.memory[index];
                        return ListTile(
                          // Show a small badge with the base mode next to the input
                          title: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  item.mode.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSecondaryContainer,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(item.input)),
                            ],
                          ),
                          subtitle: Text(
                            "=${item.output}",
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              controller.removeFromMemory(index);
                            },
                          ),
                          onTap: () {
                            // Pass the whole item so the controller can base-convert it
                            controller.loadFromMemory(item);
                            Scaffold.of(context).closeEndDrawer();
                          },
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'Nothing saved yet',
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
