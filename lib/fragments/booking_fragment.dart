import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handyman_provider_flutter/components/app_widgets.dart';
import 'package:handyman_provider_flutter/components/booking_item_component.dart';
import 'package:handyman_provider_flutter/components/booking_status_dropdown.dart';
import 'package:handyman_provider_flutter/fragments/shimmer/booking_shimmer.dart';
import 'package:handyman_provider_flutter/main.dart';
import 'package:handyman_provider_flutter/models/booking_list_response.dart';
import 'package:handyman_provider_flutter/models/booking_status_response.dart';
import 'package:handyman_provider_flutter/networks/rest_apis.dart';
import 'package:handyman_provider_flutter/utils/colors.dart';
import 'package:handyman_provider_flutter/utils/common.dart';
import 'package:handyman_provider_flutter/utils/configs.dart';
import 'package:handyman_provider_flutter/utils/constant.dart';
import 'package:handyman_provider_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/empty_error_state_widget.dart';

// ignore: must_be_immutable
class BookingFragment extends StatefulWidget {
  String? statusType;

  BookingFragment({this.statusType});

  @override
  BookingFragmentState createState() => BookingFragmentState();
}

class BookingFragmentState extends State<BookingFragment>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();

  int page = 1;
  int inspectionPage = 1;
  List<BookingData> bookings = [];
  List<BookingData> inspectionBookings = [];

  String selectedValue = BOOKING_PAYMENT_STATUS_ALL;
  bool isLastPage = false;
  bool isLastPageInspection = false;
  bool hasError = false;
  bool isApiCalled = false;

  Future<List<BookingData>>? future;
  Future<List<BookingData>>? inspactionFuture;
  UniqueKey keyForStatus = UniqueKey();

  @override
  void initState() {
    super.initState();
    LiveStream().on(LIVESTREAM_HANDY_BOARD, (index) {
      if (index is Map && index["index"] == 1) {
        selectedValue = BookingStatusKeys.accept;
        fetchAllBookingList();
        setState(() {});
      }
    });

    LiveStream().on(LIVESTREAM_HANDYMAN_ALL_BOOKING, (index) {
      if (index == 1) {
        selectedValue = '';
        fetchAllBookingList();
        setState(() {});
      }
    });

    LiveStream().on(LIVESTREAM_UPDATE_BOOKINGS, (p0) {
      page = 1;
      fetchAllBookingList();
      setState(() {});
    });

    init();
  }

  void init() async {
    if (widget.statusType.validate().isNotEmpty) {
      selectedValue = widget.statusType.validate();
    }

    fetchAllBookingList(loading: true);
    fetchInspectionList(loading: true);
  }

  Future<void> fetchAllBookingList({bool loading = true}) async {
    appStore.setLoading(loading);
    future = getBookingList(page, status: selectedValue, bookings: bookings,
        lastPageCallback: (b) {
      isLastPage = b;
    });
  }

  Future<void> fetchInspectionList({bool loading = true}) async {
    appStore.setLoading(loading);
    var request = {'customer_id': appStore.uid};
    inspactionFuture = getInspectionList(inspectionPage, request,
        status: selectedValue,
        bookings: inspectionBookings, lastPageCallback: (b) {
      isLastPageInspection = b;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(LIVESTREAM_UPDATE_BOOKINGS);
    LiveStream().dispose(LIVESTREAM_HANDY_BOARD);
    // LiveStream().dispose(LIVESTREAM_HANDYMAN_ALL_BOOKING);
    // LiveStream().dispose(LIVESTREAM_HANDY_BOARD);
    super.dispose();
  }

  Widget servicesWidget() {
    return Center(
      child: Stack(
        children: [
          SnapHelperWidget<List<BookingData>>(
            initialData: cachedBookingList,
            future: future,
            loadingWidget: BookingShimmer(),
            onSuccess: (list) {
              if (isUserTypeProvider) {
                // Sort the list based on the date in descending order
                list.sort((a, b) => DateTime.parse(b.date ?? '')
                    .compareTo(DateTime.parse(a.date ?? '')));
              }
              return AnimatedListView(
                controller: scrollController,
                onSwipeRefresh: () async {
                  page = 1;
                  await fetchAllBookingList(loading: true);
                  setState(() {});
                  return await 1.seconds.delay;
                },
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                itemCount: list.length,
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                emptyWidget: NoDataWidget(
                  title: languages.noBookingTitle,
                  subTitle: languages.noBookingSubTitle,
                  imageWidget: EmptyStateWidget(),
                ),
                itemBuilder: (_, index) => BookingItemComponent(
                    bookingData: list[index], index: index),
                //disposeScrollController: false,
                onNextPage: () {
                  if (!isLastPage) {
                    page++;
                    appStore.setLoading(true);

                    fetchAllBookingList();
                    setState(() {});
                  }
                },
              ).paddingOnly(left: 0, right: 0, bottom: 0, top: 76);
            },
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: languages.reload,
                imageWidget: ErrorStateWidget(),
                onRetry: () {
                  keyForStatus = UniqueKey();
                  appStore.setLoading(true);
                  page = 1;

                  fetchAllBookingList();
                  setState(() {});
                },
              );
            },
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 16,
            child: BookingStatusDropdown(
              isValidate: false,
              statusType: selectedValue,
              key: keyForStatus,
              onValueChanged: (BookingStatusResponse value) {
                page = 1;
                appStore.setLoading(true);

                selectedValue =
                    value.value.validate(value: BOOKING_PAYMENT_STATUS_ALL);
                fetchAllBookingList(loading: true);
                setState(() {});

                if (bookings.isNotEmpty) {
                  scrollController.animateTo(0,
                      duration: 1.seconds, curve: Curves.easeOutQuart);
                } else {
                  scrollController = ScrollController();
                }
              },
            ),
          ),
          Observer(builder: (_) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }

  Widget inspectionWidget() {
    return Stack(
      children: [
        SnapHelperWidget<List<BookingData>>(
          initialData: cachedBookingListInspection,
          future: inspactionFuture,
          loadingWidget: BookingShimmer(),
          onSuccess: (inspectionList) {
            return AnimatedListView(
              controller: scrollController,
              onSwipeRefresh: () async {
                inspectionPage = 1;
                await fetchInspectionList(loading: true);
                setState(() {});
                return await 1.seconds.delay;
              },
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              listAnimationType: ListAnimationType.FadeIn,
              fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
              itemCount: inspectionList.length,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              emptyWidget: NoDataWidget(
                title: languages.noBookingTitle,
                subTitle: languages.noBookingSubTitle,
                imageWidget: EmptyStateWidget(),
              ),
              itemBuilder: (_, index) => BookingItemComponent(
                  bookingData: inspectionList[index],
                  index: index,
                  inspection: true),
              //disposeScrollController: false,
              onNextPage: () {
                if (!isLastPageInspection) {
                  inspectionPage++;
                  appStore.setLoading(true);

                  fetchInspectionList();
                  setState(() {});
                }
              },
            ).paddingOnly(left: 0, right: 0, bottom: 0, top: 10);
          },
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              retryText: languages.reload,
              imageWidget: ErrorStateWidget(),
              onRetry: () {
                keyForStatus = UniqueKey();
                appStore.setLoading(true);
                inspectionPage = 1;

                fetchInspectionList();
                setState(() {});
              },
            );
          },
        ),
        Observer(builder: (_) => LoaderWidget().visible(appStore.isLoading)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return isUserTypeHandyman
        ? servicesWidget()
        : DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: PreferredSize(
                  preferredSize:
                      Size.fromHeight(AppBar().preferredSize.height) * 0.06,
                  child: Container(
                    height: context.height() * 0.07,
                    padding: EdgeInsets.only(top: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        color: secondaryPrimaryColor,
                      ),
                      child: TabBar(
                        splashBorderRadius: BorderRadius.circular(10),
                        labelColor: Colors.white,
                        labelStyle: primaryTextStyle(),
                        unselectedLabelColor: black,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          border: Border.all(color: transparentColor),
                          color: primaryColor,
                        ),
                        tabs: const [
                          Tab(
                            text: 'Request',
                          ),
                          Tab(
                            text: 'Inspection',
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  servicesWidget(),
                  inspectionWidget(),
                ],
              ),
            ),
          );
  }
}
