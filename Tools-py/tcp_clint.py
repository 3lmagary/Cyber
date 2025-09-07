import socket

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.settimeout(5)                          # حماية: لا ينتظر للأبد
client.connect(("127.0.0.1", 9999))           # اتصل بالسيرفر المحلي
client.send(b"Hello server!")                 # أرسل رسالة
response = client.recv(4096)                  # استقبل حتى 4096 بايت
print("Server said:", response.decode(errors="ignore"))
client.close()                                # اغلق السوكيت
