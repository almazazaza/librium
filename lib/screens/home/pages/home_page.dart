import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:librium/core/constants/app_theme.dart';
import 'package:librium/core/services/librus/api.dart';
import '../widgets/drawer.dart';
import '../widgets/lucky_number_circle.dart';
import 'package:librium/shared/widgets/fullscreen_loader.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? _data;
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      final librus = Provider.of<Librus>(context, listen: false);

      final accountInfo = await librus.getAccountInfo();
      final luckyNumber = await librus.getLuckyNumber();

      _data = {
        "fullName": "${accountInfo["firstName"]} ${accountInfo["surname"]}",
        "journalNumber": accountInfo["journalNumber"] ?? 0,
        "luckyNumber": luckyNumber ?? 0
      };
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

    final fullName = _data?["fullName"] ?? "";
    final journalNumber = _data?["journalNumber"];
    final luckyNumber = _data?["luckyNumber"];
    final isLucky = journalNumber == luckyNumber;

    return Stack(
      children: [
        Scaffold(
          drawer: AppDrawer(),
          drawerEdgeDragWidth: MediaQuery.of(context).size.width,
          appBar: AppBar(
            elevation: 2,
            title: _isLoading
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4
                            ),
                            decoration: BoxDecoration(
                              color: isLucky
                                  ? Colors.amber.withValues(alpha: 0.15)
                                  : theme.colorScheme.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "№$journalNumber",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isLucky
                                    ? Colors.amber
                                    : theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            fullName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                      LuckyNumberCircle(
                        luckyNumber: luckyNumber,
                        isLucky: isLucky,
                        theme: theme,
                      )
                    ],
                  ),
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: const IntrinsicHeight(
                      child: SizedBox(),
                    )
                  )
                );
              }
            )
          )
        ),
        FullscreenLoader(isLoading: _isLoading),
      ],
    );
  }
}