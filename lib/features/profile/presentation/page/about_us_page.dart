import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/page/page_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/page/page_state.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  String? _lastLocaleCode;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localeCode = Localizations.localeOf(context).languageCode;
    if (_lastLocaleCode != localeCode) {
      _lastLocaleCode = localeCode;
      context.read<PageCubit>().fetchPageContent(localeCode: localeCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.aboutUs),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: BlocBuilder<PageCubit, PageState>(
        builder: (context, state) {
          if (state is PageLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: CustomColors.orangeColor,
              ),
            );
          } else if (state is PageLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About Us Content
                  Html(
                    data: state.pageModel.aboutUs,
                    style: {
                      "body": Style(
                          fontSize: FontSize(12.sp),
                          lineHeight: LineHeight(1.5),
                          margin: Margins.zero,
                          fontFamily: 'Poppins-regular',
                          fontWeight: FontWeight.normal,
                          textAlign: TextAlign.justify,
                          padding: HtmlPaddings.zero,
                          color: Colors.black),
                      "p": Style(
                        fontSize: FontSize(12.sp),
                        lineHeight: LineHeight(1.5),
                        margin: Margins.only(bottom: 10),
                      ),
                      "h1": Style(
                        fontSize: FontSize(20.sp),
                        fontWeight: FontWeight.bold,
                        margin: Margins.only(bottom: 10, top: 10),
                      ),
                      "h2": Style(
                        fontSize: FontSize(18.sp),
                        fontWeight: FontWeight.bold,
                        margin: Margins.only(bottom: 10, top: 10),
                      ),
                      "h3": Style(
                        fontSize: FontSize(16.sp),
                        fontWeight: FontWeight.bold,
                        margin: Margins.only(bottom: 10, top: 10),
                      ),
                      "ul": Style(
                        margin: Margins.only(left: 20, bottom: 10),
                      ),
                      "ol": Style(
                        margin: Margins.only(left: 20, bottom: 10),
                      ),
                      "li": Style(
                        margin: Margins.only(bottom: 5),
                      ),
                    },
                  ),
                  SizedBox(height: 15.h),

                  // Contact Information Section
                  Text(
                    context.l10n.contact_information,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'Poppins-regular',
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Phone Number
                  _buildContactItem(
                    icon: Icons.phone,
                    title: context.l10n.our_phone_number,
                    value: '+993 64 77 82 40',
                    onTap: () => _makePhoneCall('+99364778240'),
                  ),

                  // Email
                  _buildContactItem(
                    icon: Icons.email,
                    title: context.l10n.email_address,
                    value: 'kitapchesmesi@gmail.com',
                    onTap: () => _sendEmail('kitapchesmesi@gmail.com'),
                  ),

                  // Instagram
                  _buildContactItem(
                    icon: Icons.camera_alt,
                    title: context.l10n.instagram,
                    value: '@kitapchesmesi',
                    onTap: () => _openSocialMedia('instagram', 'kitapchesmesi'),
                  ),

                  // TikTok
                  _buildContactItem(
                    icon: Icons.music_note,
                    title: context.l10n.tiktok,
                    value: '@kitapchesmesi',
                    onTap: () => _openSocialMedia('tiktok', 'kitapchesmesi'),
                  ),
                ],
              ),
            );
          } else if (state is PageError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    context.l10n.errorMessage,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PageCubit>().fetchPageContent(force: true);
                    },
                    child: Text(context.l10n.tryAgain),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Colors.orange,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 12.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      value,
                      style: TextStyle(
                        fontFamily: 'Poppins-regular',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  void _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Kitap Çeşmesi - Sorag',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  void _openSocialMedia(String platform, String username) async {
    String url;
    String fallbackUrl;

    switch (platform) {
      case 'instagram':
        url = 'instagram://user?username=$username';
        fallbackUrl = 'https://www.instagram.com/$username';
        break;
      case 'tiktok':
        url = 'tiktok://user?username=$username';
        fallbackUrl = 'https://www.tiktok.com/@$username';
        break;
      default:
        return;
    }

    try {
      final Uri launchUri = Uri.parse(url);
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        // Fallback to web version
        final Uri fallbackUri = Uri.parse(fallbackUrl);
        if (await canLaunchUrl(fallbackUri)) {
          await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      // If native app fails, try web version
      final Uri fallbackUri = Uri.parse(fallbackUrl);
      if (await canLaunchUrl(fallbackUri)) {
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    }
  }
}
