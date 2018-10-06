import socket

server = socket.socket()
server.bind(("", 9999))

while(1):
  server.listen(1)
  conn, addr = server.accept()
  print("connected to ", addr)
  while(1):
    data = conn.recv(1024)
    if not data:
      break
    else:
      print("message: ", data)
      conn.send("server:OK")
  conn.close()
  print("closing connection: ", addr)
