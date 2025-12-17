import 'package:flutter/material.dart';
import 'package:librium/core/constants/app_theme.dart';

import 'package:provider/provider.dart';

import 'package:librium/core/services/librus/api.dart';
import 'package:librium/shared/widgets/fullscreen_loader.dart';
import '../widgets/users_type_tile.dart';

class UserSelectPage extends StatefulWidget {
  const UserSelectPage({
    super.key
  });

  @override
  State<UserSelectPage> createState() => _UserSelectPageState();
}
class _UserSelectPageState extends State<UserSelectPage> {
  bool _isLoading = true;
  int? _expandedIndex;

  List<Map<String, dynamic>> _receiverTypes = [];
  List<Map<String, dynamic>> _receivers = [];

  @override
  void initState() {
    super.initState();
    _loadReceiversTypes();
  }

  Future<void> _loadReceiversTypes() async {
    setState(() => _isLoading = true);

    try {
      final librus = Provider.of<Librus>(context, listen: false);

      _receiverTypes = await librus.getReceiverTypes();
    }
    catch (e) {
      debugPrint("Error $e");
    }
    finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadReceivers({
    required int? index,
    required String type,
    required int groupId,
    required bool isVirtualClass,
    required int? classId
  }) async {
    setState(() {
      _isLoading = true;
      _expandedIndex = null;
    });

    try {
      final librus = Provider.of<Librus>(context, listen: false);
      
      _receivers = await librus.getReceivers(
        type,
        groupId,
        isVirtualClass,
        classId: classId
      );

      setState(() => _expandedIndex = index);
    }
    catch (e) {
      debugPrint("Error $e");
    }
    finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildUsersList(ThemeData theme) {
    if (_receivers.isEmpty && !_isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Center(
          child: Text(
            "Brak odbiorców",
            style: TextStyle(
              fontSize: 16
            )
          )
        )
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _receivers.length,
        itemBuilder: (context, i) {
          final receiver = _receivers[i];
          return InkWell(
            onTap: () => Navigator.pop(context, receiver),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                receiver["fullName"] ?? "Nieznany odbiorca",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: theme.hintColor,
        ),
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> types, ThemeData theme) {
    if (types.isEmpty && !_isLoading) {
      return const Center(
        child: Text(
          "Brak odbiorców",
          style: TextStyle(
            fontSize: 16
          )
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 20
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: types.length,
      separatorBuilder: (_, __) => Divider(
        color: theme.hintColor,
        height: 1
      ),
      itemBuilder: (context, i) {
        final type = types[i];
        return Column(
          children: [
            UsersTypeTile(
              type: type,
              onTap: () {
                if (_expandedIndex == i) {
                  setState(() => _expandedIndex = null);
                  return;
                }

                _loadReceivers(
                  index: i,
                  type: type["type"],
                  groupId: type["groupId"],
                  isVirtualClass: type["isVirtualClass"],
                  classId: type["classId"]
                );
              },
              theme: theme,
              isExpanded: _expandedIndex == i,
            ),
            if (_expandedIndex == i) _buildUsersList(theme)
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme().themeData;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              "Wybierz odbiorcę",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              )
            )
          ),
          body: SafeArea(
            child: _buildList(_receiverTypes, theme)
          )
        ),
        FullscreenLoader(isLoading: _isLoading)
      ],
    );
  }
}