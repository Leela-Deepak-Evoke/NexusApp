import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  final VoidCallback onPressed; // Change the type to VoidCallback

  EditButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: onPressed,
    );
  }
}

class DeleteButton extends StatelessWidget {
  final VoidCallback onPressed; // Change the type to VoidCallback

  DeleteButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: onPressed,
    );
  }
}
