import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:librium/core/services/librus/api.dart';
import 'package:librium/core/constants/app_theme.dart';
import 'package:librium/core/routes/app_routes.dart';
import 'package:librium/shared/widgets/message_banner.dart';

import '../widgets/auth_input.dart';
import '../widgets/app_info.dart';
import '../widgets/footer.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}
class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  LoginStatus? _loginStatus;

  Future<void> _handleLogin(BuildContext context) async {
    final librus = Provider.of<Librus>(context, listen: false);

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _loginStatus = null;
    });

    try {
      final status = await librus.authenticate(
        _loginController.text.trim(),
        _passwordController.text.trim(),
      );

      if (status == LoginStatus.success) {
        if (!context.mounted) return;
        
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
      else {
        setState(() => _loginStatus = status);
      }
    }
    catch (e) {
      setState(() => _loginStatus = LoginStatus.unknownError);
    }
    finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme().themeData;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 30,
                right: 30
              ),
              physics: BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        const AppInfo(),
                        const SizedBox(height: 25),
                        if (_loginStatus != null && _loginStatus != LoginStatus.success)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: MessageBanner(
                            text: _loginStatus!.message ?? "Nieznany błąd",
                            type: BannerType.error
                          )
                        ),
                        const SizedBox(height: 25),
                        Text(
                          "Logowanie do systemu Librus Synergia",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500
                          )
                        ),
                        const SizedBox(height: 15),
                        LoginField(
                          controller: _loginController,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Error";
                            }
                            return null;
                          },
                          obscureText: false,
                          labelText: "Login",
                          hintText: "Wprowadź login",
                          errorText: _loginStatus == LoginStatus.forbidden
                            ? _loginStatus!.message
                            : null,
                        ),
                        const SizedBox(height: 15),
                        LoginField(
                          controller: _passwordController,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Error";
                            }
                            return null;
                          },
                          obscureText: true,
                          labelText: "Hasło",
                          hintText: "Wprowadź hasło",
                          errorText: _loginStatus == LoginStatus.forbidden
                            ? _loginStatus!.message
                            : null,
                        ),
                        const SizedBox(height: 25),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            minimumSize: const Size(240, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: _isLoading ? null : () => _handleLogin(context),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  "Zaloguj",
                                  style: TextStyle(
                                    fontSize: 17,
                                    letterSpacing: 0.9,
                                    fontWeight: FontWeight.w600
                                  ),
                                )
                        ),
                        const SizedBox(height: 30),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: const FooterInfo()
                            )
                          )
                        )
                      ]
                    )
                  )
                )
              )
            );
          }
        )
      )
    );
  }
}