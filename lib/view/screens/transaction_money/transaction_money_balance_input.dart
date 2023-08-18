import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zawadicash_app/controller/add_money_controller.dart';
import 'package:zawadicash_app/controller/profile_screen_controller.dart';
import 'package:zawadicash_app/controller/splash_controller.dart';
import 'package:zawadicash_app/controller/transaction_controller.dart';
import 'package:zawadicash_app/data/model/purpose_models.dart';
import 'package:zawadicash_app/data/model/response/contact_model.dart';
import 'package:zawadicash_app/data/model/withdraw_model.dart';
import 'package:zawadicash_app/helper/email_checker.dart';
import 'package:zawadicash_app/helper/price_converter.dart';
import 'package:zawadicash_app/helper/transaction_type.dart';
import 'package:zawadicash_app/util/dimensions.dart';
import 'package:zawadicash_app/util/styles.dart';
import 'package:zawadicash_app/view/base/custom_app_bar.dart';
import 'package:zawadicash_app/view/base/custom_loader.dart';
import 'package:zawadicash_app/view/base/custom_snackbar.dart';
import 'package:zawadicash_app/view/screens/transaction_money/transaction_money_confirmation.dart';
import 'package:zawadicash_app/view/screens/transaction_money/widget/input_box_view.dart';
import 'package:zawadicash_app/view/screens/transaction_money/widget/purpose_widget.dart';
import 'package:zawadicash_app/view/screens/transaction_money/widget/field_item_view.dart';
import 'package:zawadicash_app/view/screens/transaction_money/widget/for_person_widget.dart';
import 'package:zawadicash_app/view/screens/transaction_money/widget/next_button.dart';

class TransactionMoneyBalanceInput extends StatefulWidget {
  final String? transactionType;
  final ContactModel? contactModel;
  final String? countryCode;

  const TransactionMoneyBalanceInput(
      {Key? key, this.transactionType, this.contactModel, this.countryCode})
      : super(key: key);
  @override
  State<TransactionMoneyBalanceInput> createState() =>
      _TransactionMoneyBalanceInputState();
}

class _TransactionMoneyBalanceInputState
    extends State<TransactionMoneyBalanceInput> {
  static final TextEditingController _inputAmountController =
      TextEditingController();
  late String _selectedMethodId;
  late List<MethodField> _fieldList;
  late List<MethodField> _gridFieldList;
  Map<String, TextEditingController> _textControllers = {};
  Map<String, TextEditingController> _gridTextController = {};
  final FocusNode _inputAmountFocusNode = FocusNode();

  void setFocus() {
    _inputAmountFocusNode.requestFocus();
    Get.back();
  }

  @override
  void initState() {
    super.initState();
    if (widget.transactionType == TransactionType.WITHDRAW_REQUEST) {
      Get.find<TransactionMoneyController>().getWithdrawMethods();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();
    final SplashController splashController = Get.find<SplashController>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: CustomAppbar(title: widget.transactionType!.tr),
          body: GetBuilder<TransactionMoneyController>(
              builder: (transactionMoneyController) {
            if (widget.transactionType == TransactionType.WITHDRAW_REQUEST &&
                transactionMoneyController.withdrawModel.isBlank!) {
              return CustomLoader(color: Theme.of(context).primaryColor);
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.transactionType != TransactionType.ADD_MONEY &&
                      widget.transactionType !=
                          TransactionType.WITHDRAW_REQUEST)
                    ForPersonWidget(contactModel: widget.contactModel!),
                  if (widget.transactionType ==
                      TransactionType.WITHDRAW_REQUEST)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.PADDING_SIZE_DEFAULT,
                        horizontal: Dimensions.PADDING_SIZE_SMALL,
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: context.height * 0.05,
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_SIZE_SMALL),
                              border: Border.all(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.4)),
                            ),
                            child: DropdownButton<String>(
                              menuMaxHeight: Get.height * 0.5,
                              hint: Text(
                                'select_a_method'.tr,
                                style: rubikRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL),
                              ),
                              value: _selectedMethodId,
                              items: transactionMoneyController
                                  .withdrawModel.withdrawalMethods
                                  .map((withdraw) => DropdownMenuItem<String>(
                                        value: withdraw.id.toString(),
                                        child: Text(
                                          withdraw.methodName ?? 'no method',
                                          style: rubikRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_SMALL),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (id) {
                                _selectedMethodId = id!;
                                _gridFieldList = [];
                                _fieldList = [];

                                for (var _method in transactionMoneyController
                                    .withdrawModel.withdrawalMethods
                                    .firstWhere((_method) =>
                                        _method.id.toString() == id)
                                    .methodFields!) {
                                  _gridFieldList.addIf(
                                      _method.inputName!.contains('cvv') ||
                                          _method.inputType == 'date',
                                      _method);
                                }

                                for (var _method in transactionMoneyController
                                    .withdrawModel.withdrawalMethods
                                    .firstWhere((_method) =>
                                        _method.id.toString() == id)
                                    .methodFields!) {
                                  _fieldList.addIf(
                                      !_method.inputName!.contains('cvv') &&
                                          _method.inputType != 'date',
                                      _method);
                                }

                                _textControllers = _textControllers =
                                    <String, TextEditingController>{};
                                _gridTextController = _gridTextController =
                                    <String, TextEditingController>{};

                                for (var _method in _fieldList) {
                                  _textControllers[_method.inputName!] =
                                      TextEditingController();
                                }
                                for (var _method in _gridFieldList) {
                                  _gridTextController[_method.inputName!] =
                                      TextEditingController();
                                }

                                transactionMoneyController.update();
                              },
                              isExpanded: true,
                              underline: const SizedBox(),
                            ),
                          ),
                          const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT),
                          if (_fieldList.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _fieldList.length,
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                horizontal: 10,
                              ),
                              itemBuilder: (context, index) => FieldItemView(
                                methodField: _fieldList[index],
                                textControllers: _textControllers,
                              ),
                            ),
                          if (_gridFieldList.isNotEmpty)
                            GridView.builder(
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                horizontal: 10,
                              ),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                              ),
                              itemCount: _gridFieldList.length,
                              itemBuilder: (context, index) => FieldItemView(
                                methodField: _gridFieldList[index],
                                textControllers: _gridTextController,
                              ),
                            ),
                        ],
                      ),
                    ),
                  InputBoxView(
                    inputAmountController: _inputAmountController,
                    focusNode: _inputAmountFocusNode,
                    transactionType: widget.transactionType!,
                  ),
                  if (widget.transactionType == TransactionType.CASH_OUT)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_LARGE,
                        vertical: Dimensions.PADDING_SIZE_DEFAULT,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'save_future_cash_out'.tr,
                            style: rubikRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_LARGE),
                          ),
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.zero,
                            child: CupertinoSwitch(
                              value: transactionMoneyController.isFutureSave,
                              onChanged: transactionMoneyController
                                  .cupertinoSwitchOnChange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  widget.transactionType == TransactionType.SEND_MONEY &&
                          transactionMoneyController.purposeList.isNotEmpty
                      ? MediaQuery.of(context).viewInsets.bottom > 10
                          ? Container(
                              color: Colors.white.withOpacity(0.92),
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_LARGE,
                                vertical: Dimensions.PADDING_SIZE_SMALL,
                              ),
                              child: Row(
                                children: [
                                  transactionMoneyController.purposeList.isEmpty
                                      ? Center(
                                          child: CircularProgressIndicator(
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .color,
                                        ))
                                      : const SizedBox(),
                                  const SizedBox(
                                      width: Dimensions.PADDING_SIZE_SMALL),
                                  Text('change_purpose'.tr,
                                      style: rubikRegular.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE,
                                      ))
                                ],
                              ),
                            )
                          : const PurposeWidget()
                      : const SizedBox(),
                ],
              ),
            );
          }),
          floatingActionButton: GetBuilder<TransactionMoneyController>(
              builder: (transactionMoneyController) {
            return FloatingActionButton(
              onPressed: () {
                double amount;
                if (_inputAmountController.text.isEmpty) {
                  showCustomSnackBar('please_input_amount'.tr, isError: true);
                } else {
                  String balance = _inputAmountController.text;
                  if (balance
                      .contains(splashController.configModel.currencySymbol!)) {
                    balance = balance.replaceAll(
                        splashController.configModel.currencySymbol!, '');
                  }
                  if (balance.contains(',')) {
                    balance = balance.replaceAll(',', '');
                  }
                  if (balance.contains(' ')) {
                    balance = balance.replaceAll(' ', '');
                  }
                  amount = double.parse(balance);
                  if (amount == 0) {
                    showCustomSnackBar('transaction_amount_must_be'.tr,
                        isError: true);
                  } else {
                    bool _inSufficientBalance = false;

                    final bool _isCheck = widget.transactionType !=
                            TransactionType.REQUEST_MONEY &&
                        widget.transactionType != TransactionType.ADD_MONEY;

                    if (_isCheck &&
                        widget.transactionType == TransactionType.SEND_MONEY) {
                      _inSufficientBalance =
                          PriceConverter.withSendMoneyCharge(amount) >
                              profileController.userInfo.balance!;
                    } else if (_isCheck &&
                        widget.transactionType == TransactionType.CASH_OUT) {
                      _inSufficientBalance =
                          PriceConverter.withCashOutCharge(amount) >
                              profileController.userInfo.balance!;
                    } else if (_isCheck) {
                      _inSufficientBalance =
                          amount > profileController.userInfo.balance!;
                    }

                    if (_inSufficientBalance) {
                      showCustomSnackBar('insufficient_balance'.tr,
                          isError: true);
                    } else {
                      _confirmationRoute(amount);
                    }
                  }
                }
              },
              child: const NextButton(isSubmittable: true),
              backgroundColor: Theme.of(context).secondaryHeaderColor,
            );
          })),
    );
  }

  void _confirmationRoute(double amount) {
    final transactionMoneyController = Get.find<TransactionMoneyController>();
    if (widget.transactionType == 'add_money') {
      Get.find<AddMoneyController>().addMoney(context, amount.toString());
    } else if (widget.transactionType == TransactionType.WITHDRAW_REQUEST) {
      late String _message;
      WithdrawalMethod _withdrawMethod = transactionMoneyController
          .withdrawModel.withdrawalMethods
          .firstWhere((_method) => _selectedMethodId == _method.id.toString());

      List<MethodField> _list = [];
      late String _validationKey;

      for (var _method in _withdrawMethod.methodFields!) {
        if (_method.inputType == 'email') {
          _validationKey = _method.inputName!;
        }
        if (_method.inputType == 'date') {
          _validationKey = _method.inputName!;
        }
      }

      _textControllers.forEach((key, textController) {
        _list.add(MethodField(
          inputName: key,
          inputType: null,
          inputValue: textController.text,
          placeHolder: null,
        ));

        if ((_validationKey == key) &&
            EmailChecker.isNotValid(textController.text)) {
          _message = 'please_provide_valid_email'.tr;
        } else if ((_validationKey == key) &&
            textController.text.contains('-')) {
          _message = 'please_provide_valid_date'.tr;
        }

        if (textController.text.isEmpty && _message.isEmpty) {
          _message = 'please fill ${key.replaceAll('_', ' ')} field';
        }
      });

      _gridTextController.forEach((key, textController) {
        _list.add(MethodField(
          inputName: key,
          inputType: null,
          inputValue: textController.text,
          placeHolder: null,
        ));

        if ((_validationKey == key) && textController.text.contains('-')) {
          _message = 'please_provide_valid_date'.tr;
        }
      });

      if (_message.isNotEmpty) {
        showCustomSnackBar(_message);
      } else {
        Get.to(() => TransactionMoneyConfirmation(
              inputBalance: amount,
              transactionType: TransactionType.WITHDRAW_REQUEST,
              withdrawMethod: WithdrawalMethod(
                methodFields: _list,
                methodName: _withdrawMethod.methodName,
                id: _withdrawMethod.id,
              ),
              callBack: setFocus,
            ));
      }
    } else {
      Get.to(() => TransactionMoneyConfirmation(
            inputBalance: amount,
            transactionType: widget.transactionType!,
            purpose: transactionMoneyController.purposeList.isEmpty
                ? Purpose().title
                : transactionMoneyController
                    .purposeList[transactionMoneyController.selectedItem].title,
            contactModel: widget.contactModel!,
            callBack: setFocus,
          ));
    }
  }
}
