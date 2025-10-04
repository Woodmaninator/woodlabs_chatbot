import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'command_received_provider.g.dart';

@riverpod
class CommandReceived extends _$CommandReceived {
  @override
  bool build() {
    return false;
  }

  void setCommandReceived(bool received) {
    state = received;
  }
}
