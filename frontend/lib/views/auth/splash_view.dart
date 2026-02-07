import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/task_viewmodel.dart';
import '../auth/login_view.dart';
import '../dashboard/dashboard_view.dart';
import '../widgets/app_logo.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Splash Screen
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Checking validation after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  // Check if user is already logged in
  Future<void> _checkAuth() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    await authViewModel.init();
    
    // Wait a bit to show logo
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      if (authViewModel.isAuthenticated) {
        // If authenticated, go to Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardView()),
        );
      } else {
        // Else, go to Login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginView()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final taskVM = Provider.of<TaskViewModel>(context, listen: false);
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLogo(size: 120),
            SizedBox(height: 50),
            SpinKitThreeBounce(
              color: Colors.blue,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
