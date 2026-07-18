import 'package:flutter/material.dart';
import '../models/shop_user.dart';
import 'home_page.dart';

class ChangePinPage extends StatefulWidget {
  const ChangePinPage({super.key});

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  final currentPinController = TextEditingController();
  final newPinController = TextEditingController();
  final confirmPinController = TextEditingController();

  void _changePin() {
    if (currentPinController.text != ShopUser.pin) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Current PIN is incorrect")));
      return;
    }

    if (newPinController.text.length != 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("PIN must be 6 digits")));
      return;
    }

    if (newPinController.text != confirmPinController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PIN confirmation does not match")),
      );
      return;
    }

    ShopUser.pin = newPinController.text;
    ShopUser.mustChangePin = false;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              /// HEADER
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xff0F7B94),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.lock_reset,
                  color: Colors.white,
                  size: 34,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Change Default PIN",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 8),

              Text(
                "For security reasons, you must change your default PIN before entering the dashboard.",
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
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Color(0xff0F7B94)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Your account was created with a temporary PIN. Create a new 6-digit PIN that only you know.",
                        style: TextStyle(height: 1.4),
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
                child: Column(
                  children: [
                    _buildPinField(
                      controller: currentPinController,
                      label: "Current PIN",
                      icon: Icons.lock_outline,
                    ),

                    const SizedBox(height: 18),

                    _buildPinField(
                      controller: newPinController,
                      label: "New PIN",
                      icon: Icons.password,
                    ),

                    const SizedBox(height: 18),

                    _buildPinField(
                      controller: confirmPinController,
                      label: "Confirm New PIN",
                      icon: Icons.verified_user_outlined,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              /// SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: _changePin,
                  icon: const Icon(Icons.check),
                  label: const Text(
                    "Save PIN",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
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

  Widget _buildPinField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),

        const SizedBox(height: 8),

        TextField(
          controller: controller,
          maxLength: 6,
          keyboardType: TextInputType.number,
          obscureText: true,
          decoration: InputDecoration(
            counterText: "",
            prefixIcon: Icon(icon, color: const Color(0xff0F7B94)),
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
