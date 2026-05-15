import 'package:flutter/material.dart';
import 'package:social_network_flutter/common/framework/theme/vertigo_theme.dart';

class CreateMessageWidget extends StatefulWidget {
  const CreateMessageWidget({super.key, required this.onSendMessage});
  final Function({String type, required String content}) onSendMessage;

  @override
  State<CreateMessageWidget> createState() => _CreateMessageWidgetState();
}

class _CreateMessageWidgetState extends State<CreateMessageWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = controller.text.trim();

    if (text.isEmpty) return;

    widget.onSendMessage(content: text);

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: context.color.black,
          border: Border(
            top: BorderSide(color: context.color.lightGray.withOpacity(0.2)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Напишите сообщение...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: context.color.gray,
                  ),
                  filled: true,
                  fillColor: context.color.lightGray.withOpacity(0.15),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: context.color.purple,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
