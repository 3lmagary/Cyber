import socket

# Create a socket object
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Set a timeout for the connection attempt
client.settimeout(3)

try:
    # --- The fix: pass the host and port as a single tuple ---
    client.connect(("127.0.0.1", 9999))
    print("Connection successful!")
    
    # Send data to the server as a byte string
    client.send(b"My Name Is Mohamed Tamer Fared Alip,\nI'm client!!")
    
    # Receive a response from the server
    response = client.recv(4096)
    
    # Decode the response and print it
    print(f"Server said: {response.decode(errors='ignore')}")
    
except socket.error as e:
    # Catch any connection-related errors
    print(f"Connection failed: {e}")

finally:
    # Ensure the socket is always closed, whether the connection succeeded or failed
    client.close()
    print("Socket connection closed.")
