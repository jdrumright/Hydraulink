//
//  ViewController.swift
//  iOSClient
//
//  Created by Terna Kpamber on 9/22/18.
//  Copyright © 2018 Terna Kpamber. All rights reserved.
//

import UIKit

class ViewController: UIViewController, StreamDelegate {

  var client: Client!
  @IBOutlet weak var addr_box: UITextField!
  @IBOutlet weak var info_label: UILabel!
  @IBOutlet var tap: UITapGestureRecognizer!

  override func viewDidLoad() {
    super.viewDidLoad()
    info_label.text = "DISCONNECTED"
  }

  @IBAction func hide_keyboard(_ sender: UITextField) {
    addr_box.endEditing(true)
  }

  @IBAction func tap(_ sender: UITapGestureRecognizer) {
    addr_box.endEditing(true)
  }

  @IBAction func button_one(_ sender: UIButton) {
    self.client.send_message(message: "switch:gpio_FL;")
  }

  @IBAction func button_two(_ sender: UIButton) {
    self.client.send_message(message: "switch:gpio_FR;")
  }

  @IBAction func button_three(_ sender: UIButton) {
    self.client.send_message(message: "switch:gpio_BL;")
  }

  @IBAction func button_four(_ sender: UIButton) {
    self.client.send_message(message: "switch:gpio_BR;")
  }

  @IBAction func connect_button(_ sender: UIButton) {
    let addr = addr_box.text
    let server_info = ServerInfo.init(ip_addr: addr!, 9999)
    client = Client(server: server_info, delegate: self)
  }

  func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
    switch eventCode {
    case Stream.Event.openCompleted:
        info_label.text = "CONNECTED"
        addr_box.endEditing(true)
    case Stream.Event.hasBytesAvailable:
      if let message = client.read_message() {
        info_label.text = message
      }
    case Stream.Event.errorOccurred:
      client.close_streams()
      info_label.text = "DISCONNECTED"
    default:
      break
    }
  }
}

