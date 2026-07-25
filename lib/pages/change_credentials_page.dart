import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/shop_user.dart';
import 'home_page.dart';

class ChangeCredentialsPage extends StatefulWidget {
  const ChangeCredentialsPage({super.key});

  @override
  State<ChangeCredentialsPage> createState() => _ChangeCredentialsPageState();
}

class _ChangeCredentialsPageState extends State<ChangeCredentialsPage> {
  int _currentStep = 1;

  // Step 1 Controllers (PIN)
  final currentPinController = TextEditingController();
  final newPinController = TextEditingController();
  final confirmPinController = TextEditingController();

  // Step 2 Controllers (Password)
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Obscure Toggles for Password Fields
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    currentPinController.dispose();
    newPinController.dispose();
    confirmPinController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void _validateAndProcessStep() {
    if (_currentStep == 1) {
      _processPinChange();
    } else {
      _processPasswordChange();
    }
  }

  void _processPinChange() {
    if (currentPinController.text != ShopUser.pin) {
      _showSnackBar("Current PIN is incorrect");
      return;
    }

    if (newPinController.text.length != 6) {
      _showSnackBar("PIN must be 6 digits");
      return;
    }

    if (newPinController.text != confirmPinController.text) {
      _showSnackBar("PIN confirmation does not match");
      return;
    }

    ShopUser.pin = newPinController.text;
    ShopUser.mustChangePin = false;

    setState(() {
      _currentStep = 2;
    });
  }

  void _processPasswordChange() {
    if (currentPasswordController.text != ShopUser.password) {
      _showSnackBar("Current password is incorrect");
      return;
    }

    if (newPasswordController.text.length < 6) {
      _showSnackBar("Password must be at least 6 characters long");
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      _showSnackBar("Password confirmation does not match");
      return;
    }

    ShopUser.password = newPasswordController.text;
    ShopUser.mustChangePassword = false;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isStepOne = _currentStep == 1;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              /// HEADER ROW WITH ICON & STEP BADGE (1/2 or 2/2)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xff0F7B94),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(
                      isStepOne ? Icons.lock_reset : Icons.key_outlined,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),

                  /// STEP BADGE (1/2 or 2/2)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffEAF7FA),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xffB8DDE6)),
                    ),
                    child: Text(
                      isStepOne ? "Step 1/2" : "Step 2/2",
                      style: const TextStyle(
                        color: Color(0xff0F7B94),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// TITLE
              Text(
                isStepOne ? "Change Default PIN" : "Change Default Password",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              /// SUBTITLE
              Text(
                isStepOne
                    ? "For security reasons, you must change your default PIN before entering the dashboard."
                    : "Next, update your default account password to finish securing your account.",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 24),

              /// INFO CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xffEAF7FA),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xffB8DDE6)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xff0F7B94)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isStepOne
                            ? "Your account was created with a temporary PIN. Create a new 6-digit PIN that only you know."
                            : "Your account was created with a temporary password. Choose a strong password to continue.",
                        style: const TextStyle(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// FORM CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: isStepOne ? _buildPinForm() : _buildPasswordForm(),
              ),

              const SizedBox(height: 28),

              /// SAVE / NEXT BUTTON
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: _validateAndProcessStep,
                  icon: Icon(isStepOne ? Icons.arrow_forward : Icons.check),
                  label: Text(
                    isStepOne ? "Next Step" : "Save Password",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0F7B94),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// STEP 1: PIN FORM
  Widget _buildPinForm() {
    return Column(
      children: [
        _buildInputField(
          controller: currentPinController,
          label: "Current PIN",
          icon: Icons.lock_outline,
          isNumeric: true,
          maxLength: 6,
        ),
        const SizedBox(height: 18),
        _buildInputField(
          controller: newPinController,
          label: "New PIN",
          icon: Icons.password,
          isNumeric: true,
          maxLength: 6,
        ),
        const SizedBox(height: 18),
        _buildInputField(
          controller: confirmPinController,
          label: "Confirm New PIN",
          icon: Icons.verified_user_outlined,
          isNumeric: true,
          maxLength: 6,
        ),
      ],
    );
  }

  /// STEP 2: PASSWORD FORM
  Widget _buildPasswordForm() {
    return Column(
      children: [
        _buildInputField(
          controller: currentPasswordController,
          label: "Current Password",
          icon: Icons.key_outlined,
          obscureText: _obscureCurrentPassword,
          onToggleVisibility: () {
            setState(() => _obscureCurrentPassword = !_obscureCurrentPassword);
          },
        ),
        const SizedBox(height: 18),
        _buildInputField(
          controller: newPasswordController,
          label: "New Password",
          icon: Icons.lock_reset_outlined,
          obscureText: _obscureNewPassword,
          onToggleVisibility: () {
            setState(() => _obscureNewPassword = !_obscureNewPassword);
          },
        ),
        const SizedBox(height: 18),
        _buildInputField(
          controller: confirmPasswordController,
          label: "Confirm New Password",
          icon: Icons.check_circle_outline,
          obscureText: _obscureConfirmPassword,
          onToggleVisibility: () {
            setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
          },
        ),
      ],
    );
  }

  /// Original Input Field Widget Style
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumeric = false,
    int? maxLength,
    bool obscureText = true,
    VoidCallback? onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLength: maxLength,
          keyboardType: isNumeric
              ? TextInputType.number
              : TextInputType.visiblePassword,
          inputFormatters: isNumeric
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          obscureText: obscureText,
          decoration: InputDecoration(
            counterText: "",
            prefixIcon: Icon(icon, color: const Color(0xff0F7B94)),
            suffixIcon: onToggleVisibility != null
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
            filled: true,
            fillColor: const Color(0xffF8F8F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(color: Color(0xff0F7B94), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
