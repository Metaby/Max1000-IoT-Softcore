from intelhex import IntelHex
import csv
import string

def twos_comp(val, bits):
    """compute the 2's complement of int value val"""
    if (val & (1 << (bits - 1))) != 0: # if sign bit is set e.g., 8bit: 128-255
        val = val - (1 << bits)        # compute negative value
    return val  

hex_codes = []
with open('microprogram.hex') as csvfile:
		reader = csv.reader(csvfile, delimiter = ' ')
		for row in reader:
				for c in row:
					if len(c) > 0 and c not in ["v2.0", "raw"]:
						hex_codes.append(c)
ih = IntelHex(size = 2)
for i in range(len(hex_codes)):
	ih[i] = int(hex_codes[i], 16)
ih.tofile("microprogram_ihx.hex", format="hex")