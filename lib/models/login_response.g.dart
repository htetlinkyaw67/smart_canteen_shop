// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      token: json['token'] as String,
      user: ShopUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'token': instance.token,
      'user': instance.user,
    };

ShopUser _$ShopUserFromJson(Map<String, dynamic> json) => ShopUser(
  userId: (json['user_id'] as num).toInt(),
  userName: json['user_name'] as String,
  userPhone: json['user_phone'] as String,
  userEmail: json['user_email'] as String,
  roleName: json['role_name'] as String,
  fcmToken: json['fcm_token'] as String?,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
  shop: json['shop'] == null
      ? null
      : Shop.fromJson(json['shop'] as Map<String, dynamic>),
  wallet: json['wallet'] == null
      ? null
      : Wallet.fromJson(json['wallet'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ShopUserToJson(ShopUser instance) => <String, dynamic>{
  'user_id': instance.userId,
  'user_name': instance.userName,
  'user_phone': instance.userPhone,
  'user_email': instance.userEmail,
  'role_name': instance.roleName,
  'fcm_token': instance.fcmToken,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'shop': instance.shop,
  'wallet': instance.wallet,
};

Shop _$ShopFromJson(Map<String, dynamic> json) => Shop(
  shopId: (json['shop_id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  shopName: json['shop_name'] as String,
  shopPhone: json['shop_phone'] as String,
  isOpen: (json['is_open'] as num).toInt(),
  fcmToken: json['fcm_token'] as String?,
);

Map<String, dynamic> _$ShopToJson(Shop instance) => <String, dynamic>{
  'shop_id': instance.shopId,
  'user_id': instance.userId,
  'shop_name': instance.shopName,
  'shop_phone': instance.shopPhone,
  'is_open': instance.isOpen,
  'fcm_token': instance.fcmToken,
};

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
  walletId: (json['wallet_id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  shopId: (json['shop_id'] as num).toInt(),
  balance: (json['balance'] as num).toDouble(),
  isPinChanged: (json['is_pin_changed'] as num).toInt(),
  failedAttempts: (json['failed_attempts'] as num).toInt(),
  lockedUntil: json['locked_until'] as String?,
);

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
  'wallet_id': instance.walletId,
  'user_id': instance.userId,
  'shop_id': instance.shopId,
  'balance': instance.balance,
  'is_pin_changed': instance.isPinChanged,
  'failed_attempts': instance.failedAttempts,
  'locked_until': instance.lockedUntil,
};
