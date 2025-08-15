import 'package:debug_mate/constants/app_constants.dart';
import 'package:debug_mate/models/settings_model.dart';
import 'package:flutter/services.dart';
import 'package:master_utility/master_utility.dart';

class SettingsService {
  final _settingChannel = MethodChannel(AppConstants.settingChannel);

  Future<SettingsModel> getSettigs() async {
    try {
      final settings = await _settingChannel.invokeMethod(
        AppConstants.getSettingsMethod,
      );

      return SettingsModel.fromJson(Map<String, dynamic>.from(settings));
    } catch (e) {
      LogHelper.logError(e.toString());
      ToastHelper.showToast(message: e.toString());
      return SettingsModel();
    }
  }

  Future<SettingsModel> updateSettings(SettingsModel settings) async {
    try {
      final updatedSettings = await _settingChannel.invokeMethod(
        AppConstants.updateSettingsMethod,
        settings.toJson(),
      );

      return SettingsModel.fromJson(Map<String, dynamic>.from(updatedSettings));
    } catch (e) {
      LogHelper.logError(e.toString());
      ToastHelper.showToast(message: e.toString());
      return SettingsModel();
    }
  }
}
