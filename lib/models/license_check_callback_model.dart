/*
 * @Author: Charley
 * @Date: 2024-11-09 15:01:42
 * @Description: In User Settings Edit
 * @FilePath: /tencent_effect_player/lib/models/license_check_callback_model.dart
 * @LastEditTime: 2024-11-15 15:39:11
 * @LastEditors: Charley
 */

enum LicenseStatus {
  success,
  fail,
}

class LicenseCheckCallbackErrorModel {
  final int errcode;
  final dynamic param;

  LicenseCheckCallbackErrorModel({required this.errcode, required this.param});
}

class LicenseCheckCallbackModel {
  LicenseStatus status;
  LicenseCheckCallbackErrorModel? error;

  LicenseCheckCallbackModel({required this.status, this.error});
}
