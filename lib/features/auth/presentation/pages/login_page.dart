import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/app/router/app_router.dart';
import 'package:riverpod_go_router_boilerplate/core/core.dart';
import 'package:riverpod_go_router_boilerplate/features/auth/presentation/providers/auth_notifier.dart';

/// Login page for user authentication.
class LoginPage extends ConsumerStatefulWidget {
  /// Creates a [LoginPage] instance.
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authProvider.notifier)
        .login(_emailController.text.trim(), _passwordController.text);

    if (!mounted) return;

    ref
        .read(authProvider)
        .whenOrNull(
          error: (final error, _) {
            context.showErrorSnackBar(error.toString());
          },
          data: (final user) {
            if (user != null) {
              context.goRoute(AppRoute.home);
            }
          },
        );
  }

  @override
  Widget build(final BuildContext context) {
    final theme = context.theme;
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUnfocus,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo
                    Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(bottom: AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.flutter_dash,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                    ),

                    // Title
                    Text(
                      'Welcome Back',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const VerticalSpace.sm(),
                    Text(
                      'Sign in to continue',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const VerticalSpace.xl(),

                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: Validators.compose([
                        Validators.required('Email is required'),
                        Validators.email('Please enter a valid email'),
                      ]),
                    ),
                    const VerticalSpace.md(),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      enabled: !isLoading,
                      onFieldSubmitted: (_) => _handleLogin(),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: Validators.compose([
                        Validators.required('Password is required'),
                        Validators.minLength(
                          6,
                          'Password must be at least 6 characters',
                        ),
                        Validators.strongPassword(
                          'Strong password required (0-9, A-Z, a-z, special char)',
                        ),
                      ]),
                    ),
                    const VerticalSpace.lg(),

                    // Login button
                    AppButton(
                      variant: .primary,
                      size: .large,
                      isExpanded: true,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _handleLogin,
                      label: 'Sign In',
                    ),
                    const VerticalSpace.md(),

                    // Forgot password
                    AppButton(
                      variant: .text,
                      size: .medium,
                      isExpanded: true,
                      onPressed: isLoading
                          ? null
                          : () {
                              // TODO: Navigate to forgot password
                            },
                      label: 'Forgot Password?',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
