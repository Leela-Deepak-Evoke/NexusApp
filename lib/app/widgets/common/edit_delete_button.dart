import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  final VoidCallback onPressed; // Change the type to VoidCallback

  const EditButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: onPressed,
    );
  }
}

class DeleteButton extends StatelessWidget {
  final VoidCallback onPressed; // Change the type to VoidCallback

  const DeleteButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: onPressed,
    );
  }
}
