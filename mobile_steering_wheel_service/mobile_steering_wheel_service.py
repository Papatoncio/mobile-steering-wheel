import socket
import json
import pyvjoy
import tkinter as tk
from tkinter import ttk
import threading
import time

UDP_IP = "0.0.0.0"
UDP_PORT = 5005

j = pyvjoy.VJoyDevice(1)

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((UDP_IP, UDP_PORT))

last_data_time = 0
running = True
current_angle = 0

# ---------------------------
# OBTENER IP DEL DISPOSITIVO
# ---------------------------

def obtener_ip_local():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
    finally:
        s.close()
    return ip

ip_local = obtener_ip_local()

# ---------------------------
# INTERFAZ
# ---------------------------

root = tk.Tk()
root.title("Servidor Joystick UDP")
root.geometry("460x380")

ip_label = ttk.Label(root, text=f"IP: {ip_local}")
ip_label.pack(pady=5)

port_label = ttk.Label(root, text=f"Puerto: {UDP_PORT}")
port_label.pack(pady=5)

client_label = ttk.Label(root, text="Cliente: Ninguno")
client_label.pack(pady=5)

status_label = ttk.Label(root, text="Estado: Esperando conexión", foreground="red")
status_label.pack(pady=5)

# ---------------------------
# LED DE CONEXIÓN
# ---------------------------

led_canvas = tk.Canvas(root, width=40, height=40)
led_canvas.pack()

led = led_canvas.create_oval(10,10,30,30, fill="red")

# ---------------------------
# MEDIDOR DE VOLANTE
# ---------------------------

meter_label = ttk.Label(root, text="Ángulo del volante")
meter_label.pack()

meter_canvas = tk.Canvas(root, width=300, height=60)
meter_canvas.pack()

meter_bg = meter_canvas.create_rectangle(10,20,290,40, fill="lightgray")
meter_bar = meter_canvas.create_rectangle(150,20,150,40, fill="blue")

angle_text = meter_canvas.create_text(150,10,text="0°")

# ---------------------------
# INFO DATOS
# ---------------------------

data_label = ttk.Label(root, text="Datos: ---")
data_label.pack(pady=10)

activity_label = ttk.Label(root, text="Actividad: Sin datos")
activity_label.pack(pady=5)

# ---------------------------
# BOTÓN CERRAR
# ---------------------------

def cerrar_aplicacion():
    global running
    running = False
    try:
        sock.close()
    except:
        pass
    root.destroy()

close_button = ttk.Button(root, text="Cerrar servidor", command=cerrar_aplicacion)
close_button.pack(pady=15)

root.protocol("WM_DELETE_WINDOW", cerrar_aplicacion)

# ---------------------------
# ACTUALIZAR LED
# ---------------------------

def set_led(color):
    led_canvas.itemconfig(led, fill=color)

# ---------------------------
# ACTUALIZAR MEDIDOR
# ---------------------------

def actualizar_medidor(angle):

    pos = 150 + (angle / 45) * 140
    pos = max(10, min(290, pos))

    meter_canvas.coords(meter_bar,150,20,pos,40)
    meter_canvas.itemconfig(angle_text,text=f"{angle:.1f}°")

# ---------------------------
# SERVIDOR SOCKET
# ---------------------------

def servidor():
    global last_data_time, running, current_angle

    while running:
        try:
            data, addr = sock.recvfrom(1024)
        except:
            break

        last_data_time = time.time()

        try:
            msg = json.loads(data.decode())

            # BOTONES
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

            # CAMARAS
            cameraOne = msg.get("cameraOne", False) 
            cameraTwo = msg.get("cameraTwo", False) 
            cameraThree = msg.get("cameraThree", False)

            # ASESOR DE RUTAS
            routeAdvisorNavigation = msg.get("routeAdvisorNavigation", False) 
            routeAdvisorCurrentDelivery = msg.get("routeAdvisorCurrentDelivery", False) 
            routeAdvisorAssistance = msg.get("routeAdvisorAssistance", False) 
            routeAdvisorInformation = msg.get("routeAdvisorInformation", False) 
            routeAdvisorChat = msg.get("routeAdvisorChat", False)

            current_angle = angle

            status_label.config(text="Estado: Conectado", foreground="green")
            client_label.config(text=f"Cliente: {addr[0]}")
            set_led("green")

            data_label.config(
                text=f"Ángulo: {angle:.1f} | Acel: {throttle} | Freno: {brake}"
            )

            activity_label.config(text="Actividad: Recibiendo datos")

            actualizar_medidor(angle)

            # JOYSTICK
            x_val = int(16384 + (angle / 45.0) * 16384)
            x_val = max(1, min(x_val, 32767))

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

            # CAMARAS
            j.set_button(17, 1 if cameraOne else 0) 
            j.set_button(18, 1 if cameraTwo else 0) 
            j.set_button(19, 1 if cameraThree else 0)

            # ASESOR DE RUTAS
            j.set_button(20, 1 if routeAdvisorNavigation else 0) 
            j.set_button(21, 1 if routeAdvisorCurrentDelivery else 0) 
            j.set_button(22, 1 if routeAdvisorAssistance else 0) 
            j.set_button(23, 1 if routeAdvisorInformation else 0) 
            j.set_button(24, 1 if routeAdvisorChat else 0)
        except json.JSONDecodeError:
            pass

# ---------------------------
# MONITOR CONEXIÓN
# ---------------------------

def monitor_conexion():
    global last_data_time, running

    while running:

        if time.time() - last_data_time > 3:

            activity_label.config(text="Actividad: Sin datos")
            status_label.config(text="Estado: Esperando conexión", foreground="red")
            client_label.config(text="Cliente: Ninguno")

            set_led("red")

        time.sleep(1)

# ---------------------------
# HILOS
# ---------------------------

threading.Thread(target=servidor, daemon=True).start()
threading.Thread(target=monitor_conexion, daemon=True).start()

root.mainloop()