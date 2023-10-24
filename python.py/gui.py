import tkinter as tk
from tkinter import ttk
import math
import matplotlib.pyplot as plt

def generate_lookup_table(wave_type, amplitude, num_entries=24):
    if wave_type == "Sine":
        waveform_func = lambda x: amplitude * math.sin(2 * math.pi * x / num_entries) + amplitude
    elif wave_type == "Cosine":
        waveform_func = lambda x: amplitude * math.cos(2 * math.pi * x / num_entries) + amplitude
    elif wave_type == "Square":
        waveform_func = lambda x: amplitude if x < num_entries / 2 else -amplitude + amplitude

    lookup_table = [waveform_func(x) for x in range(num_entries)]
    return lookup_table

def generate_waveform():
    frequency = float(frequency_entry.get())
    amplitude = float(amplitude_entry.get())
    wave_type = wave_type_var.get()

    lookup_table = generate_lookup_table(wave_type, amplitude)

    # Send the user-specified parameters to the FPGA via UART
    # Send lookup_table to FPGA or use it as needed
    print(f"Frequency: {frequency}, Amplitude: {amplitude}, Wave Type: {wave_type}")
    print("Generated Lookup Table:")
    for i, value in enumerate(lookup_table):
        print(f"Entry {i}: {value}")

    # Display a graph of the lookup table
    plt.plot(lookup_table)
    plt.title("Generated Lookup Table")
    plt.xlabel("Time")
    plt.ylabel("Value")
    plt.grid(True)
    plt.show()

# Create the main window
root = tk.Tk()
root.title("Waveform Generator")

# Frequency input
frequency_label = ttk.Label(root, text="Frequency (Hz):")
frequency_label.grid(row=0, column=0)
frequency_entry = ttk.Entry(root)
frequency_entry.grid(row=0, column=1)

# Amplitude input
amplitude_label = ttk.Label(root, text="Amplitude:")
amplitude_label.grid(row=1, column=0)
amplitude_entry = ttk.Entry(root)
amplitude_entry.grid(row=1, column=1)

# Wave type selection
wave_type_label = ttk.Label(root, text="Wave Type:")
wave_type_label.grid(row=2, column=0)
wave_type_var = tk.StringVar()
wave_type_var.set("Square")  # Default selection

# Radio buttons for different wave types
wave_type_square = ttk.Radiobutton(root, text="Square", variable=wave_type_var, value="Square")
wave_type_sine = ttk.Radiobutton(root, text="Sine", variable=wave_type_var, value="Sine")
wave_type_cosine = ttk.Radiobutton(root, text="Cosine", variable=wave_type_var, value="Cosine")

# Arrange radio buttons in a grid
wave_type_square.grid(row=2, column=1)
wave_type_sine.grid(row=2, column=2)
wave_type_cosine.grid(row=2, column=3)

# Generate button
generate_button = ttk.Button(root, text="Generate Waveform", command=generate_waveform)
generate_button.grid(row=3, column=0, columnspan=5)

# Start the GUI main loop
root.mainloop()
