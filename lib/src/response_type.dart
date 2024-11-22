/// NetworkResponseType indicates which transformation should
/// be automatically applied to the response data
enum NetworkResponseType {
  /// Transform the response data to JSON object only when the
  /// content-type of response is "application/json" .
  json,

  /// Get the response stream without any transformation.
  stream,

  /// Transform the response data to a String encoded with UTF8.
  plain,

  /// Get original bytes, the type of [NetworkResponse.data] will be List<int>
  bytes
}
