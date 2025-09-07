import socket
import subprocess
import platform

def get_ip_address():
    try:
        # الحصول على اسم الجهاز
        hostname = socket.gethostname()
        
        # الحصول على عنوان IP المحلي
        ip_address = socket.gethostbyname(hostname)
        
        return ip_address
    except:
        return "Unable to get IP"

def get_network_info():
    system = platform.system()
    
    if system == "Windows":
        # على ويندوز
        result = subprocess.run(['ipconfig'], capture_output=True, text=True)
        return result.stdout
    else:
        # على لينكس/ماك
        result = subprocess.run(['ifconfig'], capture_output=True, text=True)
        return result.stdout

# عرض المعلومات
print(f"🔍 Device Name: {socket.gethostname()}")
print(f"🌐 IP: {get_ip_address()}")
print("\n📊 Network information:")
print(get_network_info())