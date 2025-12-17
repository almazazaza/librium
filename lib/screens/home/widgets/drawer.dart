import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:provider/provider.dart';

import 'package:librium/core/constants/app_theme.dart';
import 'package:librium/core/routes/app_routes.dart';
import 'package:librium/core/services/librus/api.dart';

final theme = AppTheme().themeData;

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final librus = Provider.of<Librus>(context, listen: false);

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      backgroundColor: theme.drawerTheme.backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: theme.appBarTheme.backgroundColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: SizedBox(
                  width: 75,
                  height: 75,
                  child: SvgPicture.asset(
                    "assets/icons/app_logo.svg",
                    colorFilter: ColorFilter.mode(
                        theme.colorScheme.onSurface,
                        BlendMode.srcIn
                      )
                    )
                  )
                ),
                const SizedBox(height: 12),
                Text(
                  "Librium",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.appBarTheme.foregroundColor,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.inbox_outlined,
            title: "Wiadomości",
            route: AppRoutes.inbox
          ),
          Divider(
            height: 1,
            color: theme.hintColor,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings_outlined,
            title: "Ustawienia",
            route: AppRoutes.settings
          ),
          _buildDrawerItem(
            context,
            icon: Icons.info_outlined,
            title: "O programie",
            route: AppRoutes.about
          ),
          Divider(
            height: 1,
            color: theme.hintColor,
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              "Wyloguj"
            ),
            onTap: () async {
              await librus.destroySession();
              
              if (!context.mounted) return;

              Navigator.pushReplacementNamed(context, AppRoutes.auth);
            }
          )
        ]
      )
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    {
      IconData? icon,
      required String title,
      required String route, 
    }
  ) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isSelected = currentRoute == route;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? theme.colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? theme.colorScheme.primary : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);

        if (!isSelected) {
          if (route == AppRoutes.home) {
            Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
          }
          else {
            Navigator.of(context).push(
              SwipeablePageRoute(
                builder: (_) => AppRoutes.routes[route]!(context),
                backGestureDetectionWidth: MediaQuery.of(context).size.width
              )
            );
          }
        }
      }
    );
  }
}