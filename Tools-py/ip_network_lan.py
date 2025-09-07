import socket
import netifaces

def get_network_interfaces():
    interfaces = netifaces.interfaces()
    
    for interface in interfaces:
        addresses = netifaces.ifaddresses(interface)
        if netifaces.AF_INET in addresses:
            for link in addresses[netifaces.AF_INET]:
                if 'addr' in link and link['addr'] != '127.0.0.1':
                    print(f"🔌 Interface: {interface}")
                    print(f"📡 IP Address: {link['addr']}")
                    if 'netmask' in link:
                        print(f"🎭 Netmask: {link['netmask']}")
                    if 'broadcast' in link:
                        print(f"📢 Broadcast: {link['broadcast']}")
                    print("---")

# إذا كانت netifaces غير مثبتة، يمكنك تثبيتها بـ: pip install netifaces
try:
    get_network_interfaces()
except ImportError:
    print("⚠️ netifaces غير مثبتة. جرب: pip install netifaces")
    print(f"🌐 عنوان IP مبسط: {socket.gethostbyname(socket.gethostname())}")