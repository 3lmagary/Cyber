import socket
import threading
import re
import time

# نظام كشف تسلل بسيط
class SimpleIDS:
    def __init__(self):
        self.patterns = [
            r"union.*select",      # حقن SQL
            r"<script>",           # هجمات XSS
            r"\.\./",              # Directory traversal
            r"bin/bash",           # محاولة تنفيذ أوامر
            r"rm -rf",             # محاولة حذف ملفات
            r"wget.*http",         # محاولة تحميل ملفات
            r"curl.*http",         # محاولة تحميل ملفات
        ]
        self.suspicious_ips = {}
    
    def analyze(self, data, client_ip):
        decoded_data = data.decode(errors='ignore').lower()
        
        # البحث عن أنماط هجومية
        for pattern in self.patterns:
            if re.search(pattern, decoded_data, re.IGNORECASE):
                print(f"🚨 كشف IDS هجوم محتمل: {pattern} من {client_ip}")
                self.log_suspicious(client_ip)
                return False
        
        return True
    
    def log_suspicious(self, client_ip):
        # تسجيل العنوان المشبوه
        if client_ip not in self.suspicious_ips:
            self.suspicious_ips[client_ip] = 1
        else:
            self.suspicious_ips[client_ip] += 1
        
        # إذا تجاوز عدد المحاولات حد معين
        if self.suspicious_ips[client_ip] > 3:
            print(f"⛔ حظر عنوان IP بسبب نشاط مشبوه: {client_ip}")

# سيرفر تعليمي مع IDS
class EducationalServer:
    def __init__(self, host='0.0.0.0', port=9999):
        self.host = host
        self.port = port
        self.ids = SimpleIDS()
        self.running = False
    
    def handle_client(self, client_socket, client_address):
        print(f"🔗 اتصال جديد من {client_address}")
        
        try:
            # استقبال البيانات من العميل
            data = client_socket.recv(1024)
            
            if data:
                # تحليل البيانات بواسطة نظام كشف التسلل
                if not self.ids.analyze(data, client_address[0]):
                    client_socket.send(b"Request blocked for security reasons")
                    client_socket.close()
                    return
                
                # معالجة الطلب الشرعي
                response = self.process_request(data)
                client_socket.send(response.encode())
        
        except Exception as e:
            print(f"❌ خطأ في معالجة العميل: {e}")
        
        finally:
            client_socket.close()
    
    def process_request(self, data):
        # معالجة الطلب (يمكن تطوير هذه الدالة)
        decoded_data = data.decode(errors='ignore')
        return f"تم استلام طلبك: {decoded_data}"
    
    def start(self):
        self.running = True
        server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        
        try:
            server_socket.bind((self.host, self.port))
            server_socket.listen(5)
            print(f"🚀 server work on {self.host}:{self.port}")
            
            while self.running:
                client_socket, client_address = server_socket.accept()
                
                # معالجة كل عميل في thread منفصل
                client_thread = threading.Thread(
                    target=self.handle_client, 
                    args=(client_socket, client_address)
                )
                client_thread.daemon = True
                client_thread.start()
        
        except Exception as e:
            print(f"❌ خطأ في تشغيل السيرفر: {e}")
        
        finally:
            server_socket.close()
    
    def stop(self):
        self.running = False

# تشغيل السيرفر
if __name__ == "__main__":
    server = EducationalServer()
    
    try:
        server.start()
    except KeyboardInterrupt:
        print("\n⏹ off server...")
        server.stop()