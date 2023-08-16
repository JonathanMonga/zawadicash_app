import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/auth_controller.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/controller/transaction_controller.dart';
import 'package:zawadicash_app/data/model/response/contact_model.dart';
import 'package:zawadicash_app/helper/transaction_type.dart';
import 'package:zawadicash_app/util/app_constants.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/images.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_image.dart';
import 'package:zawadicash_app/view/base/contact_view.dart';
import 'package:zawadicash_app/view/base/custom_app_bar.dart';
import 'package:zawadicash_app/view/base/custom_country_code_picker.dart';
import 'package:zawadicash_app/view/base/custom_ink_well.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';
import 'package:zawadicash_app/view/screens/transaction_money/widget/scan_button.dart';
import 'package:zawadicash_app/view/screens/transaction_money/transaction_money_balance_input.dart';

import '../auth/selfie_capture/camera_screen.dart';

class TransactionMoneyScreen extends StatefulWidget {
  final bool fromEdit;
  final String phoneNumber;
  final String transactionType;
  const TransactionMoneyScreen({Key key, this.fromEdit, this.phoneNumber, this.transactionType}) : super(key: key);

  @override
  State<TransactionMoneyScreen> createState() => _TransactionMoneyScreenState();
}

class _TransactionMoneyScreenState extends State<TransactionMoneyScreen> {
  String customerImageBaseUrl = Get.find<SplashController>().configModel.baseUrls.customerImageUrl;

  String agentImageBaseUrl = Get.find<SplashController>().configModel.baseUrls.agentImageUrl;
  final ScrollController _scrollController = ScrollController();
  String _countryCode = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _countryCode = Get.find<AuthController>().getCustomerCountryCode();
    Get.find<TransactionMoneyController>().getSuggestList(type: widget.transactionType);
  }

  @override
  Widget build(BuildContext context) {
     final TextEditingController searchController = TextEditingController();
     widget.fromEdit? searchController.text = widget.phoneNumber: const SizedBox();
     final transactionMoneyController = Get.find<TransactionMoneyController>();

    return Scaffold(
      appBar:  CustomAppbar(title: widget.transactionType.tr),

      body: CustomScrollView(
         controller: _scrollController,
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverDelegate(
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT), color: ColorResources.getGreyBaseGray3(),
                    child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              onChanged: (inputText) => transactionMoneyController.searchContact(
                                searchTerm: inputText.toLowerCase(),
                              ),
                              keyboardType: widget.transactionType == TransactionType.CASH_OUT
                                  ? TextInputType.phone : TextInputType.name,
                              decoration: InputDecoration(
                                border: InputBorder.none, contentPadding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
                                hintText: widget.transactionType == TransactionType.CASH_OUT
                                    ? 'enter_agent_number'.tr : 'enter_name_or_number'.tr,
                                hintStyle: rubikRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                  color: ColorResources.getGreyBaseGray1(),
                                ),
                                prefixIcon: CustomCountryCodePiker(
                                  onInit: (code) => _countryCode = code.toString(),
                                  onChanged: (code) => _countryCode = code.toString(),
                                ),
                              ),
                            ),),

                          Icon(Icons.search, color: ColorResources.getGreyBaseGray1()),
                        ]),
                  ),
                  Divider(height: Dimensions.DIVIDER_SIZE_SMALL, color: Theme.of(context).colorScheme.background),

                  Container(
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ScanButton(onTap: ()=> Get.to(()=> CameraScreen(
                            fromEditProfile: false,
                            isBarCodeScan: true,
                            transactionType: widget.transactionType,
                          ))),

                          InkWell(
                            onTap: () {
                              if(searchController.text.isEmpty){
                                showCustomSnackBar('input_field_is_empty'.tr,isError: true);
                              }else {
                                String phoneNumber = _countryCode + searchController.text.trim();
                                if (widget.transactionType == "cash_out") {
                                  Get.find<TransactionMoneyController>().checkAgentNumber(phoneNumber: phoneNumber).then((value) {
                                    if (value.isOk) {
                                      String agentName = value.body['data']['name'];
                                      String agentImage = value.body['data']['image'];
                                      Get.to(() => TransactionMoneyBalanceInput(transactionType: widget.transactionType,
                                          contactModel: ContactModel(
                                              phoneNumber: _countryCode + searchController.text,
                                              name: agentName,
                                              avatarImage: agentImage))
                                      );
                                    }
                                  });
                                } else {
                                  Get.find<TransactionMoneyController>().checkCustomerNumber(phoneNumber: phoneNumber).then((value) {
                                    if (value.isOk) {
                                      String customerName = value.body['data']['name'];
                                      String customerImage = value.body['data']['image'];
                                      Get.to(() =>  TransactionMoneyBalanceInput(
                                          transactionType: widget.transactionType,
                                          contactModel: ContactModel(
                                              phoneNumber: _countryCode + searchController.text,
                                              name: customerName,
                                              avatarImage: customerImage))
                                      );
                                    }
                                  });
                                }
                              }

                            },

                            child: GetBuilder<TransactionMoneyController>(
                                builder: (checkController) {
                                  return checkController.isButtonClick ? SizedBox(
                                      width: Dimensions.RADIUS_SIZE_OVER_LARGE,height:  Dimensions.RADIUS_SIZE_OVER_LARGE,
                                      child: Center(child: CircularProgressIndicator(color: Theme.of(context).textTheme.titleLarge.color)))
                                      : Container(width: Dimensions.RADIUS_SIZE_OVER_LARGE,height:  Dimensions.RADIUS_SIZE_OVER_LARGE,
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).secondaryHeaderColor),
                                      child: Icon(Icons.arrow_forward, color: ColorResources.blackColor));
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
                )
            ),
          ),

          SliverToBoxAdapter(
            child: Column( children: [
              transactionMoneyController.sendMoneySuggestList.isNotEmpty &&  widget.transactionType == 'send_money'?
              GetBuilder<TransactionMoneyController>(builder: (sendMoneyController) {
                return  Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL, horizontal: Dimensions.PADDING_SIZE_LARGE),
                  child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                        child: Text('suggested'.tr, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      ),
                      SizedBox(height: 80.0,
                        child: ListView.builder(itemCount: sendMoneyController.sendMoneySuggestList.length, scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index)=> CustomInkWell(
                              radius : Dimensions.RADIUS_SIZE_VERY_SMALL,
                              highlightColor: Theme.of(context).textTheme.titleLarge.color.withOpacity(0.3),
                              onTap: () {
                                sendMoneyController.suggestOnTap(index, widget.transactionType);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                child: Column(children: [
                                  SizedBox(
                                    height: Dimensions.RADIUS_SIZE_EXTRA_EXTRA_LARGE,width:Dimensions.RADIUS_SIZE_EXTRA_EXTRA_LARGE,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_OVER_LARGE),
                                      child: CustomImage(
                                        fit: BoxFit.cover,
                                        image: "$customerImageBaseUrl/${sendMoneyController.sendMoneySuggestList[index].avatarImage.toString()}",
                                        placeholder: Images.avatar,
                                      ),
                                    ),
                                  ), Padding(padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                                    child: Text(sendMoneyController.sendMoneySuggestList[index].name ?? sendMoneyController.sendMoneySuggestList[index].phoneNumber ,
                                        style: sendMoneyController.sendMoneySuggestList[index].name == null ? rubikLight.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL) : rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT)),
                                  )
                                ],
                                ),
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                );
              }
              ) :
              ((transactionMoneyController.requestMoneySuggestList.isNotEmpty) && widget.transactionType == 'request_money') ?
              GetBuilder<TransactionMoneyController>(builder: (requestMoneyController) {
                return requestMoneyController.isLoading ? const Center(child: CircularProgressIndicator()) : Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL, horizontal: Dimensions.PADDING_SIZE_LARGE),
                  child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(padding: const EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                        child: Text('suggested'.tr, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                      ),
                      SizedBox(height: 80.0,
                        child: ListView.builder(itemCount: requestMoneyController.requestMoneySuggestList.length, scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index)=> CustomInkWell(
                              radius : Dimensions.RADIUS_SIZE_VERY_SMALL,
                              highlightColor: Theme.of(context).textTheme.titleLarge.color.withOpacity(0.3),
                              onTap: () {
                                requestMoneyController.suggestOnTap(index, widget.transactionType);
                                },
                              child: Container(
                                margin: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                                child: Column(children: [
                                  SizedBox(
                                    height: Dimensions.RADIUS_SIZE_EXTRA_EXTRA_LARGE,width:Dimensions.RADIUS_SIZE_EXTRA_EXTRA_LARGE,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_OVER_LARGE),
                                      child: CustomImage(image: "$customerImageBaseUrl/${requestMoneyController.requestMoneySuggestList[index].avatarImage.toString()}",
                                        fit: BoxFit.cover, placeholder: Images.avatar),
                                    ),
                                  ),

                                  Padding(padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                                    child: Text(requestMoneyController.requestMoneySuggestList[index].name ?? requestMoneyController.requestMoneySuggestList[index].phoneNumber ,
                                        style: requestMoneyController.requestMoneySuggestList[index].name == null ? rubikLight.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE) : rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                                  )
                                ],
                                ),
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                );
              }
              ) :
              ((transactionMoneyController.cashOutSuggestList.isNotEmpty) && widget.transactionType == TransactionType.CASH_OUT)?
              GetBuilder<TransactionMoneyController>(builder: (cashOutController) {
                return cashOutController.isLoading ? const Center(child: CircularProgressIndicator()) : Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL, horizontal: Dimensions.PADDING_SIZE_LARGE),
                      child: Text('recent_agent'.tr, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                    ),
                    ListView.builder(
                        itemCount: cashOutController.cashOutSuggestList.length, scrollDirection: Axis.vertical, shrinkWrap:true,physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index)=> CustomInkWell(
                          highlightColor: Theme.of(context).textTheme.titleLarge.color.withOpacity(0.3),
                          onTap: () => cashOutController.suggestOnTap(index, widget.transactionType),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,vertical: Dimensions.PADDING_SIZE_SMALL),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                              SizedBox(
                                height: Dimensions.RADIUS_SIZE_EXTRA_EXTRA_LARGE,width:Dimensions.RADIUS_SIZE_EXTRA_EXTRA_LARGE,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_OVER_LARGE),
                                  child: CustomImage(
                                    fit: BoxFit.cover,
                                    image: "$agentImageBaseUrl/${
                                        cashOutController.cashOutSuggestList[index].avatarImage.toString()}",
                                    placeholder: Images.avatar,
                                  ),
                                ),
                              ),
                              const SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(cashOutController.cashOutSuggestList[index].name ?? 'Unknown',style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,color: Theme.of(context).textTheme.bodyLarge.color)),
                                  Text(cashOutController.cashOutSuggestList[index].phoneNumber ?? 'No Number',style: rubikLight.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT,color: ColorResources.getGreyBaseGray1()),),
                                ],
                              )
                            ],
                            ),
                          ),
                        )

                    ),
                  ],
                );
              }
              ) : const SizedBox(),

               if(widget.transactionType != AppConstants.CASH_OUT)
                GetBuilder<TransactionMoneyController>(
                  builder: (contactController) {
                    return ConstrainedBox(
                      constraints: contactController.filterdContacts.isNotEmpty ?
                      BoxConstraints(maxHeight: Get.find<TransactionMoneyController>().filterdContacts.length.toDouble() * 100) :
                      BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
                        child: ContactView(transactionType: widget.transactionType, contactController: contactController));
                  }
                ),
              ],),

          ),
        ],
      ),
    );
  }
}



class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  SliverDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 120;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 120 || oldDelegate.minExtent != 120 || child != oldDelegate.child;
  }
}
