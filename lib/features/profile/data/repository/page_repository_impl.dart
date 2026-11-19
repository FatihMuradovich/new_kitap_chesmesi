import 'package:new_kitap_chesmesi/features/profile/data/data_source/page_data_source.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/model/page_model.dart';
import 'package:new_kitap_chesmesi/features/profile/domain/repository/page_repository.dart';

class PageRepositoryImpl implements PageRepository {
  final PageDataSource pageDataSource;

  PageRepositoryImpl({required this.pageDataSource});

  @override
  Future<PageModel> getPageContent() async {
    return await pageDataSource.getPageContent();
  }
}
