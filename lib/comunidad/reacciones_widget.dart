import 'package:flutter/material.dart';
import '../services/reacciones_service.dart';  // El servicio para manejar las reacciones

class ReaccionesWidget extends StatefulWidget {
  final int publicacionId;

  const ReaccionesWidget({Key? key, required this.publicacionId}) : super(key: key);

  @override
  _ReaccionesWidgetState createState() => _ReaccionesWidgetState();
}

class _ReaccionesWidgetState extends State<ReaccionesWidget> {
  bool _isLiked = false;
  String _selectedEmoji = '';

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });

    ReaccionesService.reaccionar(widget.publicacionId, _isLiked ? 'like' : 'unlike');
  }

  void _selectEmoji(String emoji) {
    setState(() {
      _selectedEmoji = emoji;
    });

    ReaccionesService.reaccionar(widget.publicacionId, emoji);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border, color: _isLiked ? Colors.red : Colors.grey),
          onPressed: _toggleLike,
        ),
        IconButton(
          icon: const Icon(Icons.insert_emoticon),
          onPressed: () {
            _selectEmoji('😊');
          },
        ),
        Text(_selectedEmoji),
      ],
    );
  }
}
