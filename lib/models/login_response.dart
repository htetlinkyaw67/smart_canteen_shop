import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';


@JsonSerializable()
class LoginResponse {

  final bool success;

  final String message;

  final String token;

  final ShopUser user;


  LoginResponse({
    required this.success,
    required this.message,
    required this.token,
    required this.user,
  });


  factory LoginResponse.fromJson(
      Map<String,dynamic> json)
  => _$LoginResponseFromJson(json);


  Map<String,dynamic> toJson()
  => _$LoginResponseToJson(this);

}



@JsonSerializable()
class ShopUser {


@JsonKey(name: "user_id")
final int userId;


@JsonKey(name:"user_name")
final String userName;


@JsonKey(name:"user_phone")
final String userPhone;


@JsonKey(name:"user_email")
final String userEmail;


@JsonKey(name:"role_name")
final String roleName;


@JsonKey(name:"fcm_token")
final String? fcmToken;


@JsonKey(name:"created_at")
final String createdAt;


@JsonKey(name:"updated_at")
final String updatedAt;



final Shop? shop;


final Wallet? wallet;



ShopUser({

required this.userId,
required this.userName,
required this.userPhone,
required this.userEmail,
required this.roleName,
this.fcmToken,
required this.createdAt,
required this.updatedAt,
this.shop,
this.wallet,

});



factory ShopUser.fromJson(
Map<String,dynamic> json)

=> _$ShopUserFromJson(json);



Map<String,dynamic> toJson()

=> _$ShopUserToJson(this);




bool get mustChangePin {

 return wallet?.isPinChanged == 0;

}


}






@JsonSerializable()
class Shop {


@JsonKey(name:"shop_id")
final int shopId;


@JsonKey(name:"user_id")
final int userId;


@JsonKey(name:"shop_name")
final String shopName;


@JsonKey(name:"shop_phone")
final String shopPhone;


@JsonKey(name:"is_open")
final int isOpen;


@JsonKey(name:"fcm_token")
final String? fcmToken;



Shop({

required this.shopId,
required this.userId,
required this.shopName,
required this.shopPhone,
required this.isOpen,
this.fcmToken,

});



factory Shop.fromJson(
Map<String,dynamic> json)

=> _$ShopFromJson(json);



Map<String,dynamic> toJson()

=> _$ShopToJson(this);



}





@JsonSerializable()
class Wallet {


@JsonKey(name:"wallet_id")
final int walletId;


@JsonKey(name:"user_id")
final int userId;


@JsonKey(name:"shop_id")
final int shopId;



final double balance;



@JsonKey(name:"is_pin_changed")
final int isPinChanged;



@JsonKey(name:"failed_attempts")
final int failedAttempts;



@JsonKey(name:"locked_until")
final String? lockedUntil;




Wallet({

required this.walletId,
required this.userId,
required this.shopId,
required this.balance,
required this.isPinChanged,
required this.failedAttempts,
this.lockedUntil,

});



factory Wallet.fromJson(
Map<String,dynamic> json)

=> _$WalletFromJson(json);



Map<String,dynamic> toJson()

=> _$WalletToJson(this);



}