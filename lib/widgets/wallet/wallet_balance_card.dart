import 'package:flutter/material.dart';

class WalletBalanceCard extends StatelessWidget {
  final VoidCallback onExchange;

  const WalletBalanceCard({super.key, required this.onExchange});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xff117992),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -35,
            right: -45,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),

          Positioned(
            bottom: -40,
            right: -55,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_outlined,
                      color: Colors.white.withOpacity(.85),
                      size: 18,
                    ),

                    const SizedBox(width: 8),

                    Text(
                      "SHOP WALLET",
                      style: TextStyle(
                        color: Colors.white.withOpacity(.75),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .5,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                /// BALANCE
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      "1,600",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        height: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 6, bottom: 8),
                      child: Text(
                        "pts",
                        style: TextStyle(
                          color: Colors.white.withOpacity(.85),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  "≈ 12,800 Ks at 8 Ks/pt",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.75),
                    fontSize: 13,
                  ),
                ),

                const Spacer(),

                /// ACTIONS
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: onExchange,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.currency_exchange,
                          color: Color(0xff117992),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Exchange to cash",
                          style: TextStyle(
                            color: Color(0xff117992),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
