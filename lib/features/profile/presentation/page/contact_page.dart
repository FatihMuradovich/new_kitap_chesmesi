import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/common/utils/notification_helper.dart';
import 'package:new_kitap_chesmesi/common/widgets/custom_button.dart';
import 'package:new_kitap_chesmesi/features/auth/presentation/widget/custom_text_form_field.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/contact/contact_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/contact/contact_state.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

@RoutePage()
class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  // final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      NotificationHelper.showError(
        context,
        context.l10n.messageCannotBeEmpty,
      );
      return;
    }
    context.read<ContactCubit>().sendMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.contact),
        backgroundColor: Colors.white,
        foregroundColor: CustomColors.blueColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              Text(
                context.l10n.contactHint,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'Poppins-regular',
                ),
              ),
              SizedBox(height: 10.h),
              CustomTextFormField(
                controller: _messageController,
                hintText: context.l10n.contact,
                inputType: TextInputType.multiline,
                maxLines: 6,
                isPrefix: false,
                isCalendar: false,
                isPassword: false,
              ),
              SizedBox(height: 20.h),
              BlocConsumer<ContactCubit, ContactState>(
                listener: (context, state) {
                  if (state is ContactSuccess) {
                    _messageController.clear();
                    NotificationHelper.showSuccess(
                      context,
                      context.l10n.messageSentSuccessfully,
                    );
                    // Başarıdan sonra state'i reset et
                    context.read<ContactCubit>().resetState();
                  } else if (state is ContactError) {
                    NotificationHelper.showError(
                      context,
                      context.l10n.errorMessage,
                    );
                  }
                },
                builder: (context, state) {
                  return SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      backgroundColor: state is ContactLoading
                          ? Colors.grey
                          : CustomColors.orangeColor,
                      onTap: state is ContactLoading ? null : _sendMessage,
                      child: state is ContactLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              context.l10n.sendMessage,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Poppins-regular',
                              ),
                            ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: CustomColors.blueColor,
                          size: 18.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          context.l10n.notification,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: CustomColors.blueColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      context.l10n.contactResponse,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[700],
                        fontFamily: 'Poppins-regular',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
