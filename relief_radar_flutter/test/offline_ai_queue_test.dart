import 'package:flutter_test/flutter_test.dart';
import 'package:relief_radar_flutter/src/services/offline_sync_service.dart';

void main() {
  test('OfflineSyncService queues offline AI SOS triage messages', () {
    const testSos = 'HAZMAT chemical fire, 4 casualties, need decontamination team';

    expect(OfflineSyncService.pendingAiRequests, isEmpty);
    final initialPendingCount = OfflineSyncService.pendingSyncCountNotifier.value;

    OfflineSyncService.queueAiTriage(testSos);

    expect(OfflineSyncService.pendingAiRequests, contains(testSos));
    expect(
      OfflineSyncService.pendingSyncCountNotifier.value,
      initialPendingCount + 1,
    );
  });
}
