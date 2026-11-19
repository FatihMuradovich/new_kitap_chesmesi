import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:new_kitap_chesmesi/common/widgets/error_retry_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;
import 'package:new_kitap_chesmesi/common/constants/custom_colors.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/page/page_cubit.dart';
import 'package:new_kitap_chesmesi/features/profile/presentation/cubit/page/page_state.dart';
import 'package:new_kitap_chesmesi/localization/localization.dart';

@RoutePage()
class TermsOfUsePage extends StatefulWidget {
  const TermsOfUsePage({super.key});

  @override
  State<TermsOfUsePage> createState() => _TermsOfUsePageState();
}

class _TermsOfUsePageState extends State<TermsOfUsePage> {
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
      appBar: AppBar(
        title: Text(context.l10n.rules),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Html(
                    data: _processNestedLists(state.pageModel.termsOfUse),
                    style: {
                      "body": Style(
                        fontSize: FontSize(12.sp),
                        lineHeight: LineHeight(1.5),
                        margin: Margins.zero,
                        fontFamily: 'Poppins-regular',
                        fontWeight: FontWeight.normal,
                        textAlign: TextAlign.justify,
                        padding: HtmlPaddings.zero,
                        color: Colors.black,
                      ),
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
                        margin: Margins.only(bottom: 12, top: 10),
                      ),
                      "h3": Style(
                        fontSize: FontSize(16.sp),
                        fontWeight: FontWeight.bold,
                        margin: Margins.only(bottom: 10, top: 10),
                      ),
                      "strong": Style(
                        fontWeight: FontWeight.bold,
                      ),
                      "b": Style(
                        fontWeight: FontWeight.bold,
                      ),
                      "ul": Style(
                        margin: Margins.only(bottom: 20, top: 10),
                      ),
                      "ol": Style(
                        margin: Margins.only(bottom: 16, top: 10),
                      ),
                      "li": Style(
                        margin: Margins.only(bottom: 5),
                      ),
                    },
                  ),
                ],
              ),
            );
          } else if (state is PageError) {
            return ErrorRetryView(
              onRetry: () => context.read<PageCubit>().fetchPageContent(
                    force: true,
                    localeCode: Localizations.localeOf(context).languageCode,
                  ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
