import 'package:network/network.dart';

abstract class NetworkException extends StandardException {
  NetworkException({
    required super.userMessage,
    required super.technicalMessage,
    super.technicalCode = '',
    super.cause,
  }) : super();

  static const clientKey = "clientRelatedExceptionMessageKey";
  static const serverKey = "serverRelatedExceptionMessageKey";
  static const connectionKey = "connectionRelatedExceptionMessageKey";
  static const badDataKey = "badDataExceptionMessageKey";
  static const failDecoderKey = "failDecoderExceptionMessageKey";
  static const authKey = "authRelatedExceptionMessageKey";
  static const requestCancelledKey = "requestCancelledExceptionMessageKey";
}

class ResponseException extends NetworkException {
  ResponseException({
    required super.technicalMessage,
    super.technicalCode,
    String? userMessage,
    required this.response,
  }) : super(
          userMessage: userMessage ?? NetworkException.clientKey,
          cause: response,
        );

  NetworkResponse response;
}

class ClientRelatedException extends ResponseException {
  ClientRelatedException({
    required super.technicalMessage,
    super.technicalCode,
    String? userMessage,
    required super.response,
  }) : super(userMessage: userMessage ?? NetworkException.clientKey);
}

class ServerRelatedException extends ResponseException {
  ServerRelatedException({
    required super.technicalMessage,
    super.technicalCode,
    required super.response,
  }) : super(userMessage: NetworkException.serverKey);
}

class AuthRelatedException extends ResponseException {
  AuthRelatedException({
    required super.technicalMessage,
    super.technicalCode,
    required super.response,
  }) : super(userMessage: NetworkException.authKey);
}

class BadDataException extends NetworkException {
  BadDataException({
    required super.technicalMessage,
    super.technicalCode,
    dynamic super.cause,
  }) : super(userMessage: NetworkException.badDataKey);
}

class FailDecoderException extends NetworkException {
  FailDecoderException({
    required super.technicalMessage,
    super.technicalCode,
    dynamic super.cause,
  }) : super(userMessage: NetworkException.failDecoderKey);
}

class RequestCancelledException extends NetworkException {
  RequestCancelledException({
    super.technicalCode,
    dynamic super.cause,
  }) : super(
          userMessage: NetworkException.requestCancelledKey,
          technicalMessage: "The request is manually cancelled",
        );
}

class ConnectionRelatedException extends NetworkException {
  ConnectionRelatedException({
    required super.technicalMessage,
    super.technicalCode,
    dynamic super.cause,
  }) : super(userMessage: NetworkException.connectionKey);
}

class InterceptorRelatedException extends NetworkException {
  InterceptorRelatedException({
    required super.technicalMessage,
    super.technicalCode,
    dynamic super.cause,
  }) : super(userMessage: NetworkException.connectionKey);
}
