import 'package:new_kitap_chesmesi/features/profile/domain/model/page_model.dart';

abstract class PageRepository {
  Future<PageModel> getPageContent();
}
