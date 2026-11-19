import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/page/page_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/page/page_state.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

@RoutePage()
class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
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

  String _processNestedLists(String htmlContent) {
    final document = html_parser.parse(htmlContent);

    // Tüm ol listelerini bul (listeyi ters çevirerek en içtekilerden başla)
    final allOlLists =
        document.querySelectorAll('ol').toList().reversed.toList();

    for (var olList in allOlLists) {
      // Eğer bu ol listesi başka bir li elementi içindeyse (iç içe liste)
      var parent = olList.parent;
      bool isNested = false;

      // Parent'ı kontrol et - eğer bir li içindeyse ve o li bir ol/ul içindeyse nested
      if (parent != null && parent.localName == 'li') {
        var grandParent = parent.parent;
        if (grandParent != null &&
            (grandParent.localName == 'ol' || grandParent.localName == 'ul')) {
          isNested = true;
        }
      }

      // İç içe geçmiş ol listelerini ul'ye çevir
      if (isNested) {
        final newElement = dom.Element.tag('ul');
        newElement.attributes.addAll(olList.attributes);
        newElement.nodes.addAll(olList.nodes);
        olList.replaceWith(newElement);
      }
    }

    return document.body!.innerHtml;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          context.l10n.privacy,
        ),
      ),
      body: BlocBuilder<PageCubit, PageState>(
        builder: (context, state) {
          if (state is PageLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: CustomColors.orangeColor,
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    context.l10n.viewing,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Poppins-regular',
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is PageLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Privacy Policy Content
                  Html(
                    data: _processNestedLists(state.pageModel.privacyPolicy), 
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

                  SizedBox(height: 24.h),
                ],
              ),
            );
          } else if (state is PageError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline,
                        size: 64.sp,
                        color: Colors.red[400],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      context.l10n.errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: 'Poppins-regular',
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Sahypa ýüklenende ýalňyşlyk ýüze çykdy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Poppins-regular',
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton.icon(
                      onPressed: () {
                        final localeCode =
                            Localizations.localeOf(context).languageCode;
                        context
                            .read<PageCubit>()
                            .fetchPageContent(force: true, localeCode: localeCode);
                      },
                      icon: Icon(Icons.refresh, size: 20.sp),
                      label: Text(
                        context.l10n.tryAgain,
                        style: TextStyle(
                          fontFamily: 'Poppins-regular',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.orangeColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
