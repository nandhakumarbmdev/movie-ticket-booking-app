import "package:flutter/material.dart";
import "../constants/color.dart";
import "/auth/signup.dart";

class AuthSwitchPrompt extends StatelessWidget {
  final String type;

  const AuthSwitchPrompt({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isLogin = type == "login";

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin
              ? "Don't have an account? "
              : "Already have an account? ",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        GestureDetector(
          onTap: () {
            if (isLogin) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignupScreen()),
              );
            } else {
              Navigator.pop(context);
            }
          },
          child: Text(
            isLogin ? "Sign up" : "Login",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
