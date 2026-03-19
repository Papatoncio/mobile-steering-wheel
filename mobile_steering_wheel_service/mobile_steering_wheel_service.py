"""
Mobile Steering Wheel Service — Versión Mejorada
-------------------------------------------------
Recibe datos de un móvil por UDP y los traduce a un joystick virtual (vJoy).

Mejoras aplicadas:
  - Thread safety completo en Tkinter (root.after)
  - Acelerador y freno como ejes analógicos (float 0.0–1.0)
  - Suavizado del volante (exponential moving average)
  - Dead zone configurable para el centro
  - Validación de rangos en todos los valores recibidos
  - Logging a archivo joystick_server.log
  - Argumentos de línea de comandos (--port, --max-angle, --smoothing, --dead-zone)
  - Código QR automático con la IP/puerto (requiere: pip install qrcode pillow)
"""

import argparse
import json
import logging
import socket
import threading
import time
import tkinter as tk
from tkinter import ttk

import pyvjoy

# ─────────────────────────────────────────────
# ARGUMENTOS DE LÍNEA DE COMANDOS
# ─────────────────────────────────────────────

parser = argparse.ArgumentParser(description="Servidor Joystick UDP para volante móvil")
parser.add_argument("--port",      type=int,   default=5005,  help="Puerto UDP (default: 5005)")
parser.add_argument("--max-angle", type=float, default=45.0,  help="Ángulo máximo en grados (default: 45)")
parser.add_argument("--smoothing", type=float, default=0.15,  help="Factor de suavizado 0.05–1.0 (default: 0.15)")
parser.add_argument("--dead-zone", type=float, default=2.5,   help="Dead zone central en grados (default: 2.5)")
args = parser.parse_args()

UDP_IP    = "0.0.0.0"
UDP_PORT  = args.port
MAX_ANGLE = args.max_angle
SMOOTHING = max(0.01, min(1.0, args.smoothing))
DEAD_ZONE = max(0.0, args.dead_zone)

# ─────────────────────────────────────────────
# LOGGING
# ─────────────────────────────────────────────

logging.basicConfig(
    filename="joystick_server.log",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)
logging.info(f"Servidor iniciado — Puerto: {UDP_PORT} | Max angle: {MAX_ANGLE}° | "
             f"Smoothing: {SMOOTHING} | Dead zone: {DEAD_ZONE}°")

# ─────────────────────────────────────────────
# VJOY
# ─────────────────────────────────────────────

try:
    j = pyvjoy.VJoyDevice(1)
    logging.info("Dispositivo vJoy inicializado correctamente.")
except Exception as e:
    logging.critical(f"No se pudo inicializar vJoy: {e}")
    raise SystemExit(f"ERROR: No se pudo inicializar vJoy.\n{e}")

# ─────────────────────────────────────────────
# SOCKET
# ─────────────────────────────────────────────

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((UDP_IP, UDP_PORT))

# ─────────────────────────────────────────────
# ESTADO GLOBAL
# ─────────────────────────────────────────────

last_data_time = 0.0
running        = True
smoothed_angle = 0.0

# ─────────────────────────────────────────────
# UTILIDADES
# ─────────────────────────────────────────────

def obtener_ip_local() -> str:
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("8.8.8.8", 80))
        return s.getsockname()[0]
    except Exception:
        return "127.0.0.1"
    finally:
        s.close()

def clamp(value: float, lo: float, hi: float) -> float:
    return max(lo, min(hi, value))

def aplicar_dead_zone(angle: float, dead_zone: float) -> float:
    """
    Aplica dead zone con transición suave.
 
    Dentro de la zona muerta  → retorna 0.
    Fuera de la zona muerta   → resta la dead zone a la magnitud para que
                                 la salida arranque desde 0 sin salto brusco,
                                 y reescala para preservar el rango completo
                                 hasta MAX_ANGLE.
 
    Ejemplo con dead_zone=2.5° y MAX_ANGLE=45°:
      angle=0.0° → 0.0°
      angle=2.4° → 0.0°   (dentro de la zona)
      angle=2.5° → 0.0°   (justo en el borde, sin salto)
      angle=2.6° → 0.03°  (transición suave)
      angle=45°  → 45.0°  (rango máximo preservado)
    """
    if abs(angle) < dead_zone:
        return 0.0
 
    sign      = 1.0 if angle > 0 else -1.0
    magnitude = abs(angle) - dead_zone                  # empieza en 0 al salir de la zona
    scale     = MAX_ANGLE / (MAX_ANGLE - dead_zone)     # reescalar para llegar a MAX_ANGLE
    return sign * clamp(magnitude * scale, 0.0, MAX_ANGLE)

def angulo_a_vjoy(angle: float) -> int:
    """Convierte ángulo (−MAX_ANGLE…+MAX_ANGLE) al rango vJoy (1…32767)."""
    return int(clamp(16384 + (angle / MAX_ANGLE) * 16384, 1, 32767))

def eje_a_vjoy(value: float) -> int:
    """Convierte un valor normalizado (0.0…1.0) al rango vJoy (1…32767)."""
    return int(clamp(1 + value * 32766, 1, 32767))

# ─────────────────────────────────────────────
# INTERFAZ TKINTER
# ─────────────────────────────────────────────

ip_local = obtener_ip_local()

root = tk.Tk()
root.title("Servidor Joystick UDP")
root.geometry("480x650")
root.resizable(False, False)

# ── Encabezado ──────────────────────────────
frame_info = ttk.LabelFrame(root, text="Conexión", padding=8)
frame_info.pack(fill="x", padx=10, pady=6)

ttk.Label(frame_info, text=f"IP:     {ip_local}").grid(row=0, column=0, sticky="w")
ttk.Label(frame_info, text=f"Puerto: {UDP_PORT}").grid(row=1, column=0, sticky="w")

client_label = ttk.Label(frame_info, text="Cliente: Ninguno")
client_label.grid(row=2, column=0, sticky="w")

# ── Estado + LED ────────────────────────────
frame_status = ttk.LabelFrame(root, text="Estado", padding=8)
frame_status.pack(fill="x", padx=10, pady=4)

status_label = ttk.Label(frame_status, text="Esperando conexión…", foreground="red")
status_label.pack(side="left")

led_canvas = tk.Canvas(frame_status, width=24, height=24, highlightthickness=0)
led_canvas.pack(side="right", padx=6)
led = led_canvas.create_oval(4, 4, 20, 20, fill="red")

# ── Medidor del volante ──────────────────────
frame_meter = ttk.LabelFrame(root, text="Volante", padding=8)
frame_meter.pack(fill="x", padx=10, pady=4)

meter_canvas = tk.Canvas(frame_meter, width=420, height=50, highlightthickness=0)
meter_canvas.pack()

meter_canvas.create_rectangle(10, 20, 410, 38, fill="#ddd", outline="#aaa")   # fondo
meter_canvas.create_line(210, 12, 210, 46, fill="#888", dash=(3, 3))          # centro
meter_bar  = meter_canvas.create_rectangle(210, 20, 210, 38, fill="#2196F3")
angle_text = meter_canvas.create_text(210, 8, text="0.0°", font=("Helvetica", 9))

# ── Ejes analógicos ──────────────────────────
frame_axes = ttk.LabelFrame(root, text="Ejes analógicos", padding=8)
frame_axes.pack(fill="x", padx=10, pady=4)

ttk.Label(frame_axes, text="Acelerador").grid(row=0, column=0, sticky="w", padx=4)
throttle_bar = ttk.Progressbar(frame_axes, length=300, maximum=100)
throttle_bar.grid(row=0, column=1, padx=6, pady=2)

ttk.Label(frame_axes, text="Freno      ").grid(row=1, column=0, sticky="w", padx=4)
brake_bar = ttk.Progressbar(frame_axes, length=300, maximum=100, style="red.Horizontal.TProgressbar")
brake_bar.grid(row=1, column=1, padx=6, pady=2)

# ── Datos raw ────────────────────────────────
frame_data = ttk.LabelFrame(root, text="Datos recibidos", padding=8)
frame_data.pack(fill="x", padx=10, pady=4)

data_label     = ttk.Label(frame_data, text="---")
data_label.pack(anchor="w")
activity_label = ttk.Label(frame_data, text="Sin datos", foreground="gray")
activity_label.pack(anchor="w")

# ── Código QR ────────────────────────────────
frame_qr = ttk.LabelFrame(root, text="Escanear para conectar", padding=6)
frame_qr.pack(padx=10, pady=4)

qr_label = ttk.Label(frame_qr, text="Generando QR…")
qr_label.pack()

def generar_qr():
    try:
        import qrcode
        from PIL import ImageTk
        qr_data = f"{ip_local}:{UDP_PORT}"
        img = qrcode.make(qr_data).resize((110, 110))
        photo = ImageTk.PhotoImage(img)
        qr_label.config(image=photo, text="")
        qr_label.image = photo  # evitar garbage collection
    except ImportError:
        qr_label.config(text=f"(pip install qrcode pillow)\n{ip_local}:{UDP_PORT}")

root.after(300, generar_qr)

# ── Botón cerrar ─────────────────────────────
def cerrar_aplicacion():
    global running
    running = False
    logging.info("Servidor cerrado por el usuario.")
    try:
        sock.close()
    except Exception:
        pass
    root.destroy()

ttk.Button(root, text="Cerrar servidor", command=cerrar_aplicacion).pack(pady=10)
root.protocol("WM_DELETE_WINDOW", cerrar_aplicacion)

# ─────────────────────────────────────────────
# ACTUALIZAR UI (siempre desde el hilo principal)
# ─────────────────────────────────────────────

def ui_conectado(addr_ip: str, angle: float, throttle: float, brake: float):
    """Actualizar todos los widgets al recibir datos válidos."""
    status_label.config(text="Conectado", foreground="green")
    client_label.config(text=f"Cliente: {addr_ip}")
    led_canvas.itemconfig(led, fill="#4CAF50")
    activity_label.config(text="Recibiendo datos…", foreground="green")
    data_label.config(text=f"Ángulo: {angle:+.1f}°  |  Acelerador: {throttle*100:.0f}%  |  Freno: {brake*100:.0f}%")

    # Barra del volante
    pos = 210 + (angle / MAX_ANGLE) * 200
    pos = clamp(pos, 10, 410)
    if angle >= 0:
        meter_canvas.coords(meter_bar, 210, 20, pos, 38)
    else:
        meter_canvas.coords(meter_bar, pos, 20, 210, 38)
    meter_canvas.itemconfig(angle_text, text=f"{angle:+.1f}°")

    # Barras de acelerador / freno
    throttle_bar["value"] = throttle * 100
    brake_bar["value"]    = brake * 100

def ui_desconectado():
    """Actualizar widgets cuando se pierde la conexión."""
    status_label.config(text="Esperando conexión…", foreground="red")
    client_label.config(text="Cliente: Ninguno")
    led_canvas.itemconfig(led, fill="red")
    activity_label.config(text="Sin datos", foreground="gray")

# ─────────────────────────────────────────────
# SERVIDOR UDP
# ─────────────────────────────────────────────

def servidor():
    global last_data_time, running, smoothed_angle

    while running:
        try:
            data, addr = sock.recvfrom(1024)
        except Exception:
            break

        last_data_time = time.time()

        try:
            msg = json.loads(data.decode())
        except json.JSONDecodeError as e:
            logging.warning(f"JSON inválido de {addr}: {e}")
            continue
        except Exception as e:
            logging.error(f"Error al decodificar paquete: {e}")
            continue

        try:
            # ── Validar y parsear valores ─────────────
            raw_angle = clamp(float(msg.get("angle", 0.0)),    -180.0, 180.0)
            throttle  = clamp(float(msg.get("throttle", 0.0)),    0.0,   1.0)
            brake     = clamp(float(msg.get("brake",    0.0)),    0.0,   1.0)

            # ── Suavizado + dead zone ─────────────────
            smoothed_angle = smoothed_angle + SMOOTHING * (raw_angle - smoothed_angle)
            angle = aplicar_dead_zone(smoothed_angle, DEAD_ZONE)

            # ── Botones ───────────────────────────────
            gearUp               = bool(msg.get("gearUp",               False))
            gearDown             = bool(msg.get("gearDown",             False))
            cruiseControl        = bool(msg.get("cruiseControl",        False))
            turnOnOfEngine       = bool(msg.get("turnOnOfEngine",       False))
            interact             = bool(msg.get("interact",             False))
            pickDropTrailer      = bool(msg.get("pickDropTrailer",      False))
            leftSignal           = bool(msg.get("leftSignal",           False))
            blinker              = bool(msg.get("blinker",              False))
            rightSignal          = bool(msg.get("rightSignal",          False))
            windshieldWiper      = bool(msg.get("windshieldWiper",      False))
            handBrake            = bool(msg.get("handBrake",            False))
            headlights           = bool(msg.get("headlights",           False))
            highBeams            = bool(msg.get("highBeams",            False))
            horn                 = bool(msg.get("horn",                 False))

            # ── Cámaras ───────────────────────────────
            cameraOne   = bool(msg.get("cameraOne",   False))
            cameraTwo   = bool(msg.get("cameraTwo",   False))
            cameraThree = bool(msg.get("cameraThree", False))

            # ── Asesor de rutas ───────────────────────
            routeAdvisorNavigation       = bool(msg.get("routeAdvisorNavigation",       False))
            routeAdvisorCurrentDelivery  = bool(msg.get("routeAdvisorCurrentDelivery",  False))
            routeAdvisorAssistance       = bool(msg.get("routeAdvisorAssistance",       False))
            routeAdvisorInformation      = bool(msg.get("routeAdvisorInformation",      False))
            routeAdvisorChat             = bool(msg.get("routeAdvisorChat",             False))

            # ── Enviar a vJoy ─────────────────────────
            j.set_axis(pyvjoy.HID_USAGE_X,  angulo_a_vjoy(angle))
            j.set_axis(pyvjoy.HID_USAGE_Y,  eje_a_vjoy(throttle))   # acelerador analógico
            j.set_axis(pyvjoy.HID_USAGE_RZ, eje_a_vjoy(brake))      # freno analógico

            j.set_button(3,  int(gearUp))
            j.set_button(4,  int(gearDown))
            j.set_button(5,  int(cruiseControl))
            j.set_button(6,  int(turnOnOfEngine))
            j.set_button(7,  int(interact))
            j.set_button(8,  int(pickDropTrailer))
            j.set_button(9,  int(leftSignal))
            j.set_button(10,  int(blinker))
            j.set_button(11,  int(rightSignal))
            j.set_button(12, int(windshieldWiper))
            j.set_button(13, int(handBrake))
            j.set_button(14, int(headlights))
            j.set_button(15, int(highBeams))
            j.set_button(16, int(horn))
            j.set_button(17, int(cameraOne))
            j.set_button(18, int(cameraTwo))
            j.set_button(19, int(cameraThree))
            j.set_button(20, int(routeAdvisorNavigation))
            j.set_button(21, int(routeAdvisorCurrentDelivery))
            j.set_button(22, int(routeAdvisorAssistance))
            j.set_button(23, int(routeAdvisorInformation))
            j.set_button(24, int(routeAdvisorChat))

            # ── Actualizar UI (thread-safe) ───────────
            root.after(0, lambda a=angle, t=throttle, b=brake, ip=addr[0]:
                        ui_conectado(ip, a, t, b))

        except Exception as e:
            logging.error(f"Error procesando mensaje de {addr}: {e}")

# ─────────────────────────────────────────────
# MONITOR DE CONEXIÓN
# ─────────────────────────────────────────────

def monitor_conexion():
    global last_data_time, running

    while running:
        if time.time() - last_data_time > 3:
            root.after(0, ui_desconectado)
        time.sleep(1)

# ─────────────────────────────────────────────
# ARRANQUE
# ─────────────────────────────────────────────

threading.Thread(target=servidor,         daemon=True).start()
threading.Thread(target=monitor_conexion, daemon=True).start()

logging.info(f"Escuchando en {ip_local}:{UDP_PORT}")
root.mainloop()