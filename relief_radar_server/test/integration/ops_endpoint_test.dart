import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given OpsEndpoint', (sessionBuilder, endpoints) {
    test(
      'when calling `smokeTest` then successfully writes DisasterZone and Incident with GeographyPoint and Vector',
      () async {
        final result = await endpoints.ops.smokeTest(sessionBuilder);
        expect(result, isTrue);
      },
    );
  });
}
