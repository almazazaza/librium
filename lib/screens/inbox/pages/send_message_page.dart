import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import 'package:librium/core/constants/app_theme.dart';
import 'package:librium/core/services/librus/api.dart';
import 'package:librium/shared/widgets/fullscreen_loader.dart';
import 'package:librium/shared/widgets/message_banner.dart';

import 'user_select_page.dart';

class SendMessagePage extends StatefulWidget {
  const SendMessagePage({
    super.key
  });

  @override
  State<SendMessagePage> createState() => _SendMessagePageState();
}
class _SendMessagePageState extends State<SendMessagePage> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _contentController = TextEditingController();
  late FocusNode _topicFocusNode;
  late FocusNode _contentFocusNode;
  Map<String, dynamic>? _selectedUser;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _topicFocusNode = FocusNode();
    _contentFocusNode = FocusNode();

    _topicFocusNode.addListener(() {
      if (!_topicFocusNode.hasFocus) {
        _topicFocusNode.unfocus();
      }
    });
    _contentFocusNode.addListener(() {
      if (!_contentFocusNode.hasFocus) {
        _contentFocusNode.unfocus();
      }
    });
  }

  @override
  void dispose() {
    _topicController.dispose();
    _contentController.dispose();
    _topicFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  Future<bool> _showExitDialog() async {
    return (
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text("Czy chcesz porzucić tworzenie nowej wiadomości?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Nie"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Tak"),
            )
          ]
        )
      )
    ) ?? false;
  }

  Future<void> _confirmSend(BuildContext context) async {
    FocusScope.of(context).unfocus();

    setState(() => _errorMessage = null);

    final shouldSend = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Wysłać wiadomość?"),
        content: const Text("Czy na pewno chcesz wysłać wiadomość?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Anuluj"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Wyślij"),
          )
        ]
      )
    ) ?? false;

    if (shouldSend == false || !context.mounted) return;

    final librus = Provider.of<Librus>(context, listen: false);

    if (!_formKey.currentState!.validate() || _selectedUser == null) {
      setState(() => _errorMessage = "Uzupełnij wszystkie wymagane pola");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await librus.sendMessage(
        _selectedUser?["id"],
        _topicController.text.trim(),
        _contentController.text.trim()
      );

      if (success && context.mounted) {
        Navigator.pop(context, {
          "success": true,
          "receiver": _selectedUser
        });
      }
      else {
        setState(() => _errorMessage = "Nie udało się wysłać wiadomość");
      }
    }
    catch (e) {
      setState(() => _errorMessage = "Nie udało się wysłać wiadomość");
    }
    finally {
      setState(() => _isLoading = false);
    }
  }

  void _openUserSelection() async {
    final user = await Navigator.of(context).push(
      SwipeablePageRoute(
        builder: (_) => UserSelectPage(),
        backGestureDetectionWidth: MediaQuery.of(context).size.width
      )
    );

    if (user != null && mounted) {
      setState(() => _selectedUser = user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme().themeData;

    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        final shouldLeave = await _showExitDialog();

        if (shouldLeave == true && context.mounted) {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(
                "Nowa wiadomość",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              bottom: _errorMessage == null
                ? null
                : PreferredSize(
                  preferredSize: const Size.fromHeight(40),
                  child: MessageBanner(
                    text: _errorMessage!,
                    type: BannerType.error,
                  )
              )
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _confirmSend(context),
              child: Icon(
                Icons.send,
                color: theme.colorScheme.onSurface,
              )
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: _openUserSelection,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedUser?["fullName"] ?? "Wybierz odbiorcę",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _selectedUser != null
                                    ? theme.colorScheme.onSurface
                                    : theme.hintColor
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: _selectedUser != null
                                  ? theme.colorScheme.onSurface
                                  : theme.hintColor
                              )
                            ]
                          )
                        )
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        height: 1,
                        color: theme.hintColor
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _topicController,
                        focusNode: _topicFocusNode,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Error";
                          }
                          return null;
                        },
                        style: TextStyle(
                          fontSize: 16
                        ),
                        decoration: const InputDecoration(
                          hintText: "Wprowadź temat",
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          errorStyle: TextStyle(fontSize: 0)
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        height: 1,
                        color: theme.hintColor
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _contentController,
                        focusNode: _contentFocusNode,
                        maxLines: null,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Error";
                          }
                          return null;
                        },
                        style: TextStyle(
                          fontSize: 16
                        ),
                        decoration: const InputDecoration(
                          hintText: "Wprowadź treść",
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          errorStyle: TextStyle(fontSize: 0)
                        )
                      )
                    ]
                  )
                )
              )
            )
          ),
          FullscreenLoader(isLoading: _isLoading),
        ]
      )
    );
  }
}
