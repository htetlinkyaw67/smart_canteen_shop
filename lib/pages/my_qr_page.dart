import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrPage extends StatefulWidget {
  final String shopName;
  final String walletId;

  const MyQrPage({
    super.key,
    this.shopName = "Moe's Burmese Kitchen",
    this.walletId = 'SHOP-WALLET-001',
  });

  @override
  State<MyQrPage> createState() => _MyQrPageState();
}

class _MyQrPageState extends State<MyQrPage> {
  int _refreshKey = 0;

  String get _qrData {
    return 'smart-canteen://wallet/receive'
        '?walletId=${widget.walletId}'
        '&shopName=${Uri.encodeComponent(widget.shopName)}'
        '&key=$_refreshKey';
  }

  Future<void> _copyWalletId() async {
    await Clipboard.setData(ClipboardData(text: widget.walletId));

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xff172B35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Color(0xff4CD778)),
              SizedBox(width: 10),
              Expanded(child: Text('Wallet ID ကို ကူးယူပြီးပါပြီ')),
            ],
          ),
        ),
      );
  }

  void _refreshQrCode() {
    setState(() {
      _refreshKey++;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xff172B35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: const Row(
            children: [
              Icon(Icons.refresh_rounded, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('QR Code ကို အသစ်ပြန်လုပ်ပြီးပါပြီ')),
            ],
          ),
        ),
      );
  }

  void _shareQrCode() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xffD9E1E5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: const Color(0xff0F7B94).withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.share_rounded,
                    color: Color(0xff0F7B94),
                    size: 29,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Wallet မျှဝေရန်',
                  style: TextStyle(
                    color: Color(0xff172B35),
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'Wallet အချက်အလက်ကို ကူးယူပြီး '
                  'အခြားအသုံးပြုသူနှင့် မျှဝေပါ။',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff7E8D94),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 22),

                _shareOption(
                  context: sheetContext,
                  icon: Icons.badge_outlined,
                  title: 'Wallet ID ကူးယူရန်',
                  subtitle: widget.walletId,
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    await _copyWalletId();
                  },
                ),

                const SizedBox(height: 10),

                _shareOption(
                  context: sheetContext,
                  icon: Icons.link_rounded,
                  title: 'Wallet Link ကူးယူရန်',
                  subtitle: 'QR ငွေပေးချေမှု Link ကို ကူးယူရန်',
                  onTap: () async {
                    Navigator.pop(sheetContext);

                    await Clipboard.setData(ClipboardData(text: _qrData));

                    if (!mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: const Color(0xff172B35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          content: const Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xff4CD778),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text('Wallet Link ကို ကူးယူပြီးပါပြီ'),
                              ),
                            ],
                          ),
                        ),
                      );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _shareOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xffF6F9FA),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: const Color(0xffE5ECEF)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xff0F7B94).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: const Color(0xff0F7B94), size: 22),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xff263941),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff849198),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right_rounded, color: Color(0xff97A3A8)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7F8),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xff172B35),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ကျွန်ုပ်၏ QR',
              style: TextStyle(
                color: Color(0xff172B35),
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'ပွိုင့်လက်ခံရန်',
              style: TextStyle(
                color: Color(0xff839198),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'QR အသစ်ပြန်လုပ်ရန်',
            onPressed: _refreshQrCode,
            icon: const Icon(Icons.refresh_rounded, color: Color(0xff0F7B94)),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 36),
          child: Column(
            children: [
              _buildHeaderCard(),

              const SizedBox(height: 18),

              _buildQrCard(),

              const SizedBox(height: 18),

              _buildInfoCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff0F7B94), Color(0xff18A3C3)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff0F7B94).withValues(alpha: 0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.17),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.qr_code_2_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ပွိုင့်လက်ခံရန်',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'အခြားအသုံးပြုသူအား သင်၏ QR Code ကို Scan ဖတ်ခိုင်းပါ',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xffE5EDF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xff0F7B94).withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: Color(0xff0F7B94),
              size: 28,
            ),
          ),

          const SizedBox(height: 13),

          Text(
            widget.shopName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xff172B35),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'ဆိုင်၏ ပွိုင့် Wallet',
            style: TextStyle(
              color: Color(0xff87949A),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 22),

          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(23),
              border: Border.all(color: const Color(0xffE0E9EC), width: 1.3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: QrImageView(
              key: ValueKey(_refreshKey),
              data: _qrData,
              version: QrVersions.auto,
              size: 220,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Color(0xff172B35),
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Color(0xff172B35),
              ),
              errorCorrectionLevel: QrErrorCorrectLevel.H,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'ပွိုင့်ပေးပို့ရန် Scan ဖတ်ပါ',
            style: TextStyle(
              color: Color(0xff263941),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'ပေးပို့သူအား ဤ QR Code ကို Scan ဖတ်ခိုင်းပါ။',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xff89969C), fontSize: 12),
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: const Color(0xffF6F9FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xffE5ECEF)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xff0F7B94).withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Color(0xff0F7B94),
                    size: 19,
                  ),
                ),

                const SizedBox(width: 11),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Wallet ID',
                        style: TextStyle(
                          color: Color(0xff8A979D),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.walletId,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xff25373F),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  tooltip: 'Wallet ID ကူးယူရန်',
                  onPressed: _copyWalletId,
                  icon: const Icon(
                    Icons.copy_rounded,
                    color: Color(0xff0F7B94),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    foregroundColor: const Color(0xff0F7B94),
                    side: const BorderSide(color: Color(0xffC7DDE2)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _refreshQrCode,
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text(
                    'အသစ်လုပ်ရန်',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    minimumSize: const Size(0, 50),
                    backgroundColor: const Color(0xff0F7B94),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _shareQrCode,
                  icon: const Icon(Icons.share_rounded, size: 19),
                  label: const Text(
                    'မျှဝေရန်',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffEAF7FA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffC6E5EB)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xff0F7B94), size: 21),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              'Wallet မှတ်တမ်းတွင် ငွေလွှဲမှုကို '
              'စစ်ဆေးအတည်ပြုပြီးမှ ပွိုင့်များကို လက်ခံပါ။',
              style: TextStyle(
                color: Color(0xff41616D),
                fontSize: 12,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
