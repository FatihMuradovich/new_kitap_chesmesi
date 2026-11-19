import 'package:new_kitap_chesmesi/features/popup/data/data_sources/popup_data_source.dart';
import 'package:new_kitap_chesmesi/features/popup/data/models/popup_model.dart';

class PopupRepository {
  final PopupDataSource dataSource;

  PopupRepository({required this.dataSource});

  Future<PopupModel?> getLatestPopup() async {
    return await dataSource.getLatestPopup();
  }
}

