import winreg
import textwrap
import platform
import getpass
import socket
from datetime import UTC, datetime
import sys

def export_certs(output_file="CAs.inf"):
    # Show big warnings before doing anything
    warnings = """
==============================================================
  WARNING:
  You might want to run this in a clean Windows 11 24H2 VM
  if you have custom root certificates installed that you
  don't want exported, or if your Windows version is older
  and ships with an outdated root store.

  ALSO:
  This script's output SHOULD NOT be submitted directly to
  the official ReactOS repository. Doing so may violate
  their rules on code provenance and licensing.
==============================================================
"""
    print(warnings, file=sys.stderr)

    # Gather system info
    win_release = platform.release()       # e.g. "10" or "11"
    build_info = platform.win32_ver()[1]   # build number (from win32_ver)
    username = getpass.getuser()
    pcname = socket.gethostname()
    timestamp = datetime.now(UTC).strftime("%Y-%m-%d %H:%M:%S")

    with open(output_file, "w", encoding="utf-8") as f:
        # Custom header comment
        f.write(f"; Automatically-generated list of Root CA certificates\n")
        f.write(f"; with the data coming from Windows {win_release} {build_info}\n")
        f.write(f"; --\n")
        f.write(f"; Created on {timestamp} UTC by {username} on {pcname}\n")
        f.write(f"; Made with tools/generate_caroots_inf.py by Pixel Prowler\n\n")

        # INF file header
        f.write("[Version]\n")
        f.write('Signature = "$Windows NT$"\n\n')
        f.write("[AddReg]\n")

        # Open the Certificates key
        root = winreg.OpenKey(
            winreg.HKEY_LOCAL_MACHINE,
            r"SOFTWARE\\Microsoft\\SystemCertificates\\AuthRoot\\Certificates"
        )

        index = 0
        while True:
            try:
                subkey_name = winreg.EnumKey(root, index)
            except OSError:
                break  # no more subkeys

            try:
                cert_key = winreg.OpenKey(root, subkey_name)
                blob, _ = winreg.QueryValueEx(cert_key, "Blob")
            except OSError:
                index += 1
                continue

            # Turn binary blob into hex formatted for INF
            hex_str = ",".join(f"0x{b:02X}" for b in blob)
            # Wrap for readability (16 bytes per line)
            wrapped = textwrap.wrap(hex_str, 16*5)
            hex_lines = ",\\\n    ".join(wrapped)

            # Comment: certificate hash + blob size
            comment = f'; Certificate {subkey_name} ({len(blob)} bytes)\n'

            f.write(comment)
            f.write(f'HKLM,"SOFTWARE\\Microsoft\\SystemCertificates\\AuthRoot\\Certificates\\{subkey_name}","Blob",0x00000001,\\\n')
            f.write("    " + hex_lines + "\n\n")

            index += 1

        winreg.CloseKey(root)

if __name__ == "__main__":
    export_certs("CAs.inf")
    print("Export complete: CAs.inf")
