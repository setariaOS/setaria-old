import os
import struct
import sys

file_path = "./entrypoint.bin"

if os.path.isfile(file_path) == False:
	print("Fatal: The entrypoint.bin file does not exist.")
	sys.exit(0)

file = open(file_path, "ab")
file_size = os.path.getsize(file_path)
need_bytes = 4096 - file_size

for i in range(need_bytes):
	data = struct.pack("b", 0)
	file.write(data)