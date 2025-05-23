// ... existing imports ...
import 'home_screen.dart';

// ... inside _AuthScreenState ...
void _submit() async {
  if (isLogin) {
    final token = await AuthService.login(_emailController.text, _passwordController.text);
    setState(() => error = token == null ? "Login failed" : "");
    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(token: token)),
      );
    }
  } else {
    bool success = await AuthService.register(
      _emailController.text,
      _passwordController.text,
      _nameController.text,
      isDoctor,
    );
    setState(() => error = success ? "" : "Registration failed");
    if (success) setState(() => isLogin = true);
  }
}