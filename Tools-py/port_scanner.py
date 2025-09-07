import socket
import threading
import time

# ماسح بورتات بسيط لأغراض تعليمية
class EducationalPortScanner:
    def __init__(self, target, start_port, end_port, max_threads=50):
        self.target = target
        self.start_port = start_port
        self.end_port = end_port
        self.max_threads = max_threads
        self.open_ports = []
        self.lock = threading.Lock()
    
    def scan_port(self, port):
        try:
            # إنشاء سوكيت من نوع TCP
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(1)  # وقت انتظار قصير
            
            # محاولة الاتصال بالبورت
            result = sock.connect_ex((self.target, port))
            
            if result == 0:  # إذا كان البورت مفتوحاً
                with self.lock:
                    self.open_ports.append(port)
                    print(f"✅ Port:{port} open.")
            
            sock.close()
            
        except Exception as e:
            pass
    
    def start_scan(self):
        print(f"🎯 Start scanning ports on {self.target}")
        start_time = time.time()
        
        threads = []
        for port in range(self.start_port, self.end_port + 1):
            # التحكم في عدد الثreads النشطة
            while threading.active_count() > self.max_threads:
                time.sleep(0.1)
            
            thread = threading.Thread(target=self.scan_port, args=(port,))
            thread.daemon = True
            thread.start()
            threads.append(thread)
        
        # انتظار انتهاء جميع الثreads
        for thread in threads:
            thread.join()
        
        end_time = time.time()
        print(f"\n⏰ Scannig Time: {end_time - start_time:.2f} Second.")
        print(f"🔓 Open Ports: {sorted(self.open_ports)}")
        
        return self.open_ports

# استخدام الماسح (لأغراض تعليمية فقط على أجهزتك الخاصة)
if __name__ == "__main__":
    # استهدف جهازك المحلي أو جهاز في شبكتك الداخلية
       
    scanner = EducationalPortScanner(input("Enter The IP Scannig : "), 1, 1000)  # مسح البورتات من 1 إلى 100
    open_ports = scanner.start_scan()