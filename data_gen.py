import random

# Parameters for the data generation
RAM_SIZE = 256  # Number of entries in the RAM
OUTPUT_DIR = "./Desktop"  # Directory where files will be saved

# Function to generate random data for the RAM
def generate_ram_data(ram_size):
    return [random.randint(0, 255) for _ in range(ram_size)]

# Save the data to a file in hexadecimal format
def save_data_to_file(data, filename):
    with open(filename, 'w') as file:
        for value in data:
            file.write(f"{value:02X}\n")  # Write in hex format (two digits)
    print(f"Data saved to {filename}")

# Generate data for activation and weight memories
activation_data = generate_ram_data(RAM_SIZE)
weight_data = generate_ram_data(RAM_SIZE)

# Save the data to files
save_data_to_file(activation_data, f"{OUTPUT_DIR}/activation_data.mem")
save_data_to_file(weight_data, f"{OUTPUT_DIR}/weight_data.mem")
