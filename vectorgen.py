import sys
import argparse

parser = argparse.ArgumentParser(
  description="Generates a vectors.bin file with the needed vector addresses")
parser.add_argument("-b", "--bypass", help="Whether the license bypass trick is in use", type=int)

args = parser.parse_args()
bypass = args.bypass > 0

sections = {
  "nmi": None,
  "irq": None,
  "reset": None,
  "bypass": None
}

for line in sys.stdin:
  data = line.rstrip().split(" ")
  if data[2] == "nmi":
    sections["nmi"] = bytearray.fromhex(data[0][4:])
    sections["nmi"].reverse()
  if data[2] == "bypass" and bypass:
    sections["bypass"] = bytearray.fromhex(data[0][4:])
    sections["bypass"].reverse()
  if data[2] == "irq":
    sections["irq"] = bytearray.fromhex(data[0][4:])
    sections["irq"].reverse()
  if data[2] == "_start":
    sections["reset"] = bytearray.fromhex(data[0][4:])
    sections["reset"].reverse()

out = open("vectors.bin", "wb")
out.write(sections["nmi"])
out.write(sections["nmi"])
out.write(sections["bypass"] if bypass else sections["nmi"])
out.write(sections["reset"])
out.write(sections["irq"])
out.close()
