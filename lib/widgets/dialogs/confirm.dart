import 'package:jstock/constants/imports.dart';

class ConfirmDialog extends StatelessWidget {
  final String? title;
  final String? description;
  final void Function()? onConfirm;

  const ConfirmDialog({
    super.key,
    this.title,
    this.description,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? ''),
      content: Text(description ?? ''),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (onConfirm != null) onConfirm!();
          },
          child: const Text(
            'Confirm',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
