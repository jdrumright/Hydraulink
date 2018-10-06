//
//  Client.swift
//  SocketClient
//
//  Created by Terna Kpamber on 9/18/18.
//  Copyright © 2018 Terna Kpamber. All rights reserved.
//

import Foundation

struct ServerInfo {
  var ip_addr: String
  var port: Int

  init(ip_addr: String, _ port: Int) {
    self.ip_addr = ip_addr
    self.port = port
  }
}

class Client {
  var input_stream: InputStream?
  var output_stream: OutputStream?
  var server: ServerInfo
  weak var delegate: StreamDelegate?

  init(server: ServerInfo, delegate: StreamDelegate) {
    self.server = server
    self.delegate = delegate
    create_streams()
  }

  func create_streams() {
    Stream.getStreamsToHost(withName: server.ip_addr, port: server.port,
                             inputStream: &input_stream, outputStream: &output_stream)
    for stream in [input_stream, output_stream] {
      stream?.delegate = delegate
      stream?.schedule(in: .current, forMode: .common)
      stream?.open()
    }
  }

  func close_streams() {
    input_stream?.close()
    output_stream?.close()
  }

  func send_message(message: String) {
    guard output_stream?.hasSpaceAvailable == true else {
      print("---- ERROR: server \(server) cannot be reached")
      return
    }
    let data = message.data(using: .utf8)!
    let bytes = data.withUnsafeBytes { 
      output_stream?.write($0, maxLength: data.count)
    }
    print("---- \(bytes!) bytes written")
  }

  func read_message() -> String? {
    guard input_stream?.hasBytesAvailable == true else {
      print("---- ERROR: server \(server) cannot be reached")
      return nil
    }
    var data = Data.init(count: 1024)
    let bytes = data.withUnsafeMutableBytes {
      input_stream?.read($0, maxLength: 1024)
    }
    print("---- \(bytes!) bytes read")
    let messsage = String.init(data: data, encoding: .utf8)
    return messsage
  }
}
