import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import 'package:librium/core/constants/app_theme.dart';
import 'package:librium/core/services/librus/api.dart';
import 'package:librium/core/services/settings/settings.dart';

import 'package:librium/shared/widgets/fullscreen_loader.dart';
import 'package:librium/shared/widgets/message_banner.dart';

import '../widgets/inbox_message_tile.dart';
import 'message_page.dart';
import 'send_message_page.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}
class _InboxPageState extends State<InboxPage> with SingleTickerProviderStateMixin {
  late TabController _tab;
  bool _isLoading = true;
  String? _successBanner;

  List<Map<String, dynamic>> _received = [];
  List<Map<String, dynamic>> _sent = [];

  @override
  void initState() {
    super.initState();

    _tab = TabController(
      length: 2,
      vsync: this
    );
    _tab.addListener(() {
      if (!mounted) return;

      final canSwipe = _tab.index == 0;
      context.getSwipeablePageRoute<void>()!.canSwipe = canSwipe;
    });

    _loadInbox();
  }

  Future<void> _loadInbox() async {
    setState(() => _isLoading = true);

    try {
      final librus = Provider.of<Librus>(context, listen: false);
      final settings = context.read<SettingsProvider>();
      final loadAllMessages = settings.getBool("loadAllMessages");

      _received = await librus.getInbox(folderId: 5, loadAllMessages: loadAllMessages);
      _sent = await librus.getInbox(folderId: 6, loadAllMessages: loadAllMessages);
    }
    catch (e) {
      debugPrint("Error: $e");
    }
    finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildList(List<Map<String, dynamic>> messages, ThemeData theme) {
    if (messages.isEmpty && !_isLoading) {
      return const Center(
        child: Text(
          "Brak wiadomości",
          style: TextStyle(
            fontSize: 16
          )
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 10
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: messages.length,
      separatorBuilder: (_, __) => Divider(
        color: theme.hintColor,
        height: 1
      ),
      itemBuilder: (context, i) {
        final message = messages[i];
        return InboxMessageTile(
          message: message,
          theme: theme,
          onTap: () {
            Navigator.of(context).push(
              SwipeablePageRoute(
                builder: (_) => MessagePage(
                  folderId: message["folderId"],
                  messageId: message["messageId"]
                ),
                backGestureDetectionWidth: MediaQuery.of(context).size.width
              )
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme().themeData;
    final settings = context.watch<SettingsProvider>();

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Wiadomości",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ]
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(
                _successBanner == null ? kToolbarHeight : kToolbarHeight + 40,
              ),
              child: Column(
                children: [
                  TabBar(
                    controller: _tab,
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    ),
                    dividerColor: Colors.transparent,
                    dividerHeight: 0,
                    tabs: const [
                      Tab(text: "Odebrane"),
                      Tab(text: "Wysłane")
                    ] 
                  ),
                  if (_successBanner != null) MessageBanner(
                    text: _successBanner!,
                    type: BannerType.success,
                  )
                ]
              )
            )
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                SwipeablePageRoute(
                  builder: (_) => SendMessagePage(),
                  backGestureDetectionWidth: MediaQuery.of(context).size.width
                )
              );

              if (result != null && result["success"] == true) {
                final receiver = result["receiver"];

                setState(() => _successBanner = "Wysłano wiadomość do ${receiver["fullName"]}");
                
                await _loadInbox();

                Future.delayed(const Duration(seconds: 4), () {
                  if (mounted) {
                    setState(() => _successBanner = null);
                  }
                });
              }
            },
            child: Icon(
              Icons.add,
              color: theme.colorScheme.onSurface,
            ),
          ),
          body: TabBarView(
            controller: _tab,
            physics: settings.getBool("disableTabBarScroll")
              ? NeverScrollableScrollPhysics()
              : ClampingScrollPhysics(),
            children: [
              _buildList(_received, theme),
              _buildList(_sent, theme)
            ]
          )
        ),
        FullscreenLoader(isLoading: _isLoading)
      ],
    );
  }
}