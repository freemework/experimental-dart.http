// Copyright 2021, the Freemework.ORG project authors. Please see the AUTHORS
// file for details. All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:http/src/streamed_response.dart';
import 'package:http/src/response.dart';
import 'package:http/src/base_request.dart';

import 'package:freemework/freemework.dart';

class HttpClientException extends FreemeworkException {
  HttpClientException([String message, FreemeworkException innerException])
      : super(message, innerException);
}

class HttpClientProtocolException extends HttpClientException {
  final int statusCode;
  final String statusDescription;
  // private readonly _responseHeaders: http.IncomingHttpHeaders;
  // private readonly _responseBody: Buffer;

  HttpClientProtocolException(this.statusCode, this.statusDescription);

  // public get headers(): http.IncomingHttpHeaders { return this._responseHeaders; }
  // public get body(): Buffer { return this._responseBody; }
  // public get object(): any {
  // 	const headers: http.IncomingHttpHeaders = this.headers;
  // 	const contentTypeHeaderName: string | undefined = Object.keys(headers).find(header => header.toLowerCase() === "content-type");
  // 	if (contentTypeHeaderName !== undefined && headers[contentTypeHeaderName] !== "application/json") {
  // 		throw new InvalidOperationError("Wrong operation. The property available only for 'application/json' content type responses.");
  // 	}
  // 	return JSON.parse(this.body.toString());
  // }
}

///
/// `HttpClientCommunicationException` is a wrapper over underlaying network errors.
/// Such a DNS lookup issues, TCP connection issues, etc...
///
class HttpClientCommunicationException extends HttpClientException {
  HttpClientCommunicationException(FreemeworkException innerException)
      : super('Cannot establish connection.', innerException);
}

class HttpClient {
  final Client _wrap;

  HttpClient({Client wrap}) : _wrap = wrap ?? Client();

  void close() => _wrap.close();

  static Future<Response> handleResponse(
      Future<Response> responseFuture) async {
    Response response;
    try {
      response = await responseFuture;
    } catch (e) {
      throw HttpClientCommunicationException(
          FreemeworkException.wrapIfNeeded(e));
    }

    final statusCode = response.statusCode;
    if (statusCode >= 200 && statusCode < 300) {
      return response;
    }
    throw HttpClientProtocolException(statusCode, response.reasonPhrase);
  }

  Future<Response> delete(
    ExecutionContext executionContext,
    Uri url, {
    Map<String, String> headers,
  }) {
    return handleResponse(_wrap.delete(url, headers: headers));
  }

  Future<Response> get(
    ExecutionContext executionContext,
    Uri url, {
    Map<String, String> headers,
  }) {
    return handleResponse(_wrap.get(url, headers: headers));
  }

  Future<Response> head(
    ExecutionContext executionContext,
    Uri url, {
    Map<String, String> headers,
  }) {
    return handleResponse(_wrap.head(url, headers: headers));
  }

  // Future<Response> patch(url,
  //     {Map<String, String> headers, body, Encoding encoding}) {
  //   // TODO: implement patch
  //   throw UnimplementedError();
  // }

  Future<Response> post(
    ExecutionContext executionContext,
    Uri url, {
    Map<String, String> headers,
    body,
    Encoding encoding,
  }) {
    return handleResponse(_wrap.post(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    ));
  }

  Future<Response> put(
    ExecutionContext executionContext,
    Uri url, {
    Map<String, String> headers,
    body,
    Encoding encoding,
  }) {
    return handleResponse(_wrap.put(
      url,
      headers: headers,
      body: body,
      encoding: encoding,
    ));
  }

  // Future<String> read(url, {Map<String, String> headers}) {
  //   // TODO: implement read
  //   throw UnimplementedError();
  // }

  // Future<Uint8List> readBytes(url, {Map<String, String> headers}) {
  //   // TODO: implement readBytes
  //   throw UnimplementedError();
  // }

  // Future<StreamedResponse> send(BaseRequest request) {
  //   // TODO: implement send
  //   throw UnimplementedError();
  // }
}
