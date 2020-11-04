import 'protocol/sentry_stack_trace.dart';
import 'protocol.dart';
import 'sentry_stack_trace_factory.dart';

/// class to convert Dart Error and exception to SentryException
class SentryExceptionFactory {
  final SentryStackTraceFactory _stacktraceFactory;

  const SentryExceptionFactory({
    SentryStackTraceFactory stacktraceFactory = const SentryStackTraceFactory(),
  }) : _stacktraceFactory = stacktraceFactory;

  SentryException getSentryException(
    dynamic exception, {
    dynamic stackTrace,
    Mechanism mechanism,
  }) {
    if (stackTrace == null && exception is Error) {
      stackTrace = exception.stackTrace;
    } else {
      stackTrace ??= StackTrace.current;
    }

    final sentryStackTrace = SentryStackTrace(
      frames: _stacktraceFactory.getStackFrames(stackTrace),
    );

    final sentryException = SentryException(
      type: '${exception.runtimeType}',
      value: '$exception',
      mechanism: mechanism,
      stacktrace: sentryStackTrace,
    );

    return sentryException;
  }
}