import socket
import threading # مكتبة للتعامل مع عده اتصالات 

def handle_client(conn, addr):# 
    # conn -- socket العميل ,, 
    # addr ---(IP, port) الخاص بالعميل.

    print(f"[+] Connected by {addr}")
    try:
        # اقرأ بيانات حتى 1024 بايت
        request = conn.recv(1024)
        print("[*] Received:", request.decode(errors="ignore"))
        # رد بسيط
        conn.send(b"The server has been contacted......")
    except Exception as e:
        print("[!] Error handling client:", e)
    finally:
        conn.close()

def main():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)  # يسمح بإعادة استخدام البورت بسرعة
    server.bind(("0.0.0.0", 9999))   # "0.0.0.0" يعنى استقبل على كل الواجهات
    server.listen(5)                 # طابق انتظار حتى 5 اتصالات
    print("[*] Listening on port 9999...")

    while True:
        client_socket, addr = server.accept()   # ينتظر اتصال جديد
        t = threading.Thread(target=handle_client, args=(client_socket, addr))
        t.daemon = True                         # حتى يغلق مع البرنامج لو خرجنا
        t.start()

if __name__ == "__main__":
    main()
