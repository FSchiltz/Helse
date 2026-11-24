import 'package:flutter_test/flutter_test.dart';
import 'package:helse/services/api/service_error.dart';

void main() {
  group('ServiceError', () {
    test('returns a client error response body', () {
      final error = ServiceError(
        400,
        message: 'Error during the call',
        description: 'Wrong metric type',
      );

      expect(error.toString(), 'Wrong metric type');
    });

    test('formats validation errors from a structured response body', () {
      final error = ServiceError(
        422,
        message: 'Error during the call',
        description: {
          'title': 'Validation failed',
          'errors': {
            'Name': ['Required'],
            'Age': ['Must be positive', 'Must be an integer'],
          },
        },
      );

      expect(
        error.toString(),
        'Name: Required; Age: Must be positive, Must be an integer',
      );
    });

    test('falls back to the message for an empty client error body', () {
      final error = ServiceError(
        404,
        message: 'Resource not found',
        description: '  ',
      );

      expect(error.toString(), 'Resource not found');
    });

    test('does not expose server error response details', () {
      final error = ServiceError(
        500,
        message: 'Error during the call',
        description: 'Internal exception details',
      );

      expect(error.toString(), 'Server error');
    });
  });
}
