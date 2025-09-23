import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_connection_status_provider.g.dart';

enum ConnectionStatus {
  connected,
  disconnected,
  connecting,
  configuration_missing,
  invalid_channel_name,
}

@riverpod
class CurrentConnectionStatus extends _$CurrentConnectionStatus {
  @override
  ConnectionStatus build() {
    return ConnectionStatus.disconnected;
  }

  void setStatus(ConnectionStatus status) {
    state = status;
  }
}
