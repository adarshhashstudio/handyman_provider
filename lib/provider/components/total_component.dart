import 'package:flutter/material.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/dashboard_response.dart';
import 'package:handyman_provider_flutter/provider/components/total_widget.dart';
import 'package:handyman_provider_flutter/provider/handyman_list_screen.dart';
import 'package:handyman_provider_flutter/provider/services/service_list_screen.dart';
import 'package:handyman_provider_flutter/provider/wallet/wallet_history_screen.dart';
import 'package:handyman_provider_flutter/screens/total_earning_screen.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class TotalComponent extends StatelessWidget {
  final DashboardResponse snap;

  TotalComponent({required this.snap});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        TotalWidget(
                title: 'Total Requests',
                total: snap.totalBooking.toString(),
                icon: total_booking)
            .onTap(
          () {
            LiveStream().emit(LIVESTREAM_PROVIDER_ALL_BOOKING, 1);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        TotalWidget(
          title:
              isUserTypeProvider ? 'Open Requests' : languages.lblTotalService,
          total: snap.totalService.validate().toString(),
          icon: total_services,
        ).onTap(
          () {
            ServiceListScreen().launch(context);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        if (snap.earningType == EARNING_TYPE_SUBSCRIPTION && isUserTypeProvider)
          TotalWidget(
            title: languages.lblTotalHandyman,
            total: snap.totalHandyman.validate().toString(),
            icon: handyman,
          ).onTap(
            () {
              HandymanListScreen().launch(context);
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
        TotalWidget(
          title: isUserTypeProvider
              ? 'Total Inspections'
              : languages.monthlyEarnings,
          total: isUserTypeProvider
              ? '0'
              : "${isCurrencyPositionLeft ? appStore.currencySymbol : ""}${snap.totalRevenue.validate().toStringAsFixed(DECIMAL_POINT).formatNumberWithComma()}${isCurrencyPositionRight ? appStore.currencySymbol : ""}",
          icon: percent_line,
        ).onTap(
          () {
            TotalEarningScreen().launch(context);
          },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        if (snap.earningType == EARNING_TYPE_COMMISSION)
          TotalWidget(
            title:
                isUserTypeProvider ? 'Open Inspections' : languages.lblWallet,
            total: isUserTypeProvider
                ? '0'
                : "${isCurrencyPositionLeft ? appStore.currencySymbol : ""}${snap.providerWallet != null ? snap.providerWallet?.amount.validate().toStringAsFixed(DECIMAL_POINT).formatNumberWithComma() : "0"}${isCurrencyPositionRight ? appStore.currencySymbol : ""}",
            icon: isUserTypeProvider ? total_booking : un_fill_wallet,
          ).onTap(
            () {
              WalletHistoryScreen().launch(context);
            },
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),
      ],
    ).paddingAll(16);
  }
}
