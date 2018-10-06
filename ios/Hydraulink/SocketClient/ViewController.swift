//
//  ViewController.swift
//  SocketClient
//
//  Created by Terna Kpamber on 9/18/18.
//  Copyright © 2018 Terna Kpamber. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, StreamDelegate {

  var client: Client!

  override func viewDidLoad() {
    super.viewDidLoad()

    let server_info = ServerInfo(ip_addr: "192.168.1.83", 9999)
    client = Client(server: server_info, delegate: self)
  }

  @IBAction func send_message(_ sender: NSButtonCell) {
    client.send_message(message: "hi! from the client")
  }

  func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
    switch eventCode {
    case Stream.Event.hasBytesAvailable:
      print(client.read_message()!)

    case Stream.Event.openCompleted:
      print("---- \(aStream): successfully opened")

    case Stream.Event.errorOccurred:
      print("---- ERROR!")
      client.close_streams()
      
    default:
      break
    }
  }
}

