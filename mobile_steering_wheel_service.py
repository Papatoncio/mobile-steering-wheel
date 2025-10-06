import socket
import json
import pyvjoy

# Configuración
UDP_IP = "0.0.0.0"   # Escuchar en todas las interfaces
UDP_PORT = 5005      # Puerto de comunicación

# Inicializar vJoy
j = pyvjoy.VJoyDevice(1)

# Crear socket UDP
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((UDP_IP, UDP_PORT))

print(f"Servidor escuchando en {UDP_IP}:{UDP_PORT}")

while True:
    data, addr = sock.recvfrom(1024)
    try:
        msg = json.loads(data.decode())
        angle = msg.get("angle", 0)
        throttle = msg.get("throttle", 0.0)
        gearUp = msg.get("gearUp", False)
        gearDown = msg.get("gearDown", False)

        # Convertir ángulo (-45° a 45°) → rango vJoy (1–32767)
        x_val = int(16384 + (angle / 45.0) * 16384)
        x_val = max(1, min(x_val, 32767))

        # Convertir throttle (0.0–1.0) → rango vJoy (1–32767)
        y_val = int(throttle * 32767)
        y_val = max(1, min(y_val, 32767))

        # Aplicar valores al joystick virtual
        j.set_axis(pyvjoy.HID_USAGE_X, x_val)
        j.set_axis(pyvjoy.HID_USAGE_Y, y_val)
        j.set_button(1, 1 if gearUp else 0)
        j.set_button(2, 1 if gearDown else 0)

        print(f"[{addr[0]}] Ángulo: {angle:.1f}° | Acelerador: {throttle:.2f} → {y_val} | Gear Up: {gearUp} | Gear Down: {gearDown}")

    except json.JSONDecodeError:
        continue
