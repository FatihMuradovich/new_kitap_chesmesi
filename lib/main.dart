import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_kitap_chesmesi/app/app.dart';
import 'package:new_kitap_chesmesi/app/di.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocatorService();

  Bloc.observer = TalkerBlocObserver(talker: di<Talker>());
  runApp(const App());
}
