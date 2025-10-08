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
        throttle = msg.get("throttle", False)
        brake = msg.get("brake", False)
        gearUp = msg.get("gearUp", False)
        gearDown = msg.get("gearDown", False)
        cruiseControl = msg.get("cruiseControl", False)
        turnOnOfEngine = msg.get("turnOnOfEngine", False)
        interact = msg.get("interact", False)
        pickDropTrailer = msg.get("pickDropTrailer", False)
        leftSignal = msg.get("leftSignal", False)
        blinker = msg.get("blinker", False)
        rightSignal = msg.get("rightSignal", False)
        windshieldWiper = msg.get("windshieldWiper", False)
        handBrake = msg.get("handBrake", False)
        headlights = msg.get("headlights", False)
        highBeams = msg.get("highBeams", False)
        horn = msg.get("horn", False)

        # Cameras
        cameraOne = msg.get("cameraOne", False)
        cameraTwo = msg.get("cameraTwo", False)
        cameraThree = msg.get("cameraThree", False)

        # Convertir ángulo (-45° a 45°) → rango vJoy (1–32767)
        x_val = int(16384 + (angle / 45.0) * 16384)
        x_val = max(1, min(x_val, 32767))

        # Aplicar valores al joystick virtual
        j.set_axis(pyvjoy.HID_USAGE_X, x_val)
        j.set_button(1, 1 if throttle else 0)
        j.set_button(2, 1 if brake else 0)
        j.set_button(3, 1 if gearUp else 0)
        j.set_button(4, 1 if gearDown else 0)
        j.set_button(5, 1 if cruiseControl else 0)
        j.set_button(6, 1 if turnOnOfEngine else 0)
        j.set_button(7, 1 if interact else 0)
        j.set_button(8, 1 if pickDropTrailer else 0)
        j.set_button(9, 1 if leftSignal else 0)
        j.set_button(10, 1 if blinker else 0)
        j.set_button(11, 1 if rightSignal else 0)
        j.set_button(12, 1 if windshieldWiper else 0)
        j.set_button(13, 1 if handBrake else 0)
        j.set_button(14, 1 if headlights else 0)
        j.set_button(15, 1 if highBeams else 0)
        j.set_button(16, 1 if horn else 0)

        # Cameras
        j.set_button(17, 1 if cameraOne else 0)
        j.set_button(18, 1 if cameraTwo else 0)
        j.set_button(19, 1 if cameraThree else 0)

        print(f"[{addr[0]}] Ángulo: {angle:.1f}° | Acelerador: {throttle} | Freno: {brake}")        

    except json.JSONDecodeError:
        continue
