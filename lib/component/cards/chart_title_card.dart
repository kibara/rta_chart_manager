import 'package:flutter/material.dart';

/// チャートタイトルが書かれたカード
class ChartTitleCard extends StatelessWidget {
  final int index;
  final String title;
  final VoidCallback? playButtonOnPressed;
  final VoidCallback? editButtonOnPressed;
  final VoidCallback? deleteButtonOnPressed;
  final VoidCallback? cardOnTap;

  const ChartTitleCard({
    super.key,
    required this.index,
    required this.title,
    required this.playButtonOnPressed,
    this.editButtonOnPressed,
    this.deleteButtonOnPressed,
    this.cardOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key,
      child: ListTile(
        title: Text(title),
        trailing: Wrap(
          children: [
            if (playButtonOnPressed != null)
              IconButton(
                icon: const Icon(Icons.play_circle),
                onPressed: playButtonOnPressed,
              ),
            if (editButtonOnPressed != null)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: editButtonOnPressed,
              ),
            if (deleteButtonOnPressed != null)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: deleteButtonOnPressed,
              ),
            SizedBox(width: 10),
          ],
        ),
        onTap: cardOnTap,
      ),
    );
  }
}
