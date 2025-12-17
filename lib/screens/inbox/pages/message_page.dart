import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:librium/core/constants/app_theme.dart';
import 'package:librium/core/services/librus/api.dart';
import 'package:librium/shared/widgets/fullscreen_loader.dart';

import '../data/build_message.dart';

class MessagePage extends StatefulWidget {
  final int? folderId;
  final int? messageId;

  const MessagePage({
    super.key,
    this.folderId,
    this.messageId
  });

  @override
  State<MessagePage> createState() => _MessagePageState();
}
class _MessagePageState extends State<MessagePage> {
  bool _isLoading = true;
  Map<String, dynamic>? _message;
  String _addresser = "";

  @override
  void initState() {
    super.initState();
    _loadMessage();
  }

  Future<void> _loadMessage() async {
    setState(() => _isLoading = true);

    try {
      final librus = Provider.of<Librus>(context, listen: false);

      _message = await librus.getMessage(widget.folderId, widget.messageId);

      if (_message?["meta"]?["sender"] != null) {
        _addresser = "Od: ${_message?["meta"]?["sender"]}";
      }
      else if (_message?["meta"]?["receiver"] != null) {
        _addresser = "Do: ${_message?["meta"]?["receiver"]}";
      }
    }
    catch (e) {
      debugPrint("Error: $e");
    }
    finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme().themeData;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 25,
                    right: 25
                  ),
                  physics: BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 15),
                          Text(
                            _message?["meta"]?["topic"] ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          Text(
                            _addresser,
                            style: const TextStyle(
                              fontSize: 14,
                            )
                          ),
                          Text(
                            _message?["meta"]?["sent"] ?? "",
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.hintColor
                            )
                          ),
                          SizedBox(height: 5),
                          Divider(
                            color: theme.hintColor,
                            height: 1
                          ),
                          SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: theme.appBarTheme.foregroundColor,
                                fontSize: 14,
                              ),
                              children: buildTextSpans(
                                plainText: _message?["plainText"] ?? "",
                                links: List<String>.from(_message?["links"] ?? []),
                                theme: theme
                              )
                            )
                          )
                        ]
                      )
                    )
                  )
                );
              }
            )
          )
        ),
        FullscreenLoader(isLoading: _isLoading)
      ],
    );
  }
}