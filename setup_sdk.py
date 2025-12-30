#!/usr/bin/env python
import shutil
import os
import sys

src_steam = r'd:\Github\SteamworksPy\sdk\public\steam'
dst_steam = r'd:\Github\SteamworksPy\library\sdk\steam'
src_redist = r'd:\Github\SteamworksPy\sdk\redistributable_bin\win64'
dst_redist = r'd:\Github\SteamworksPy\library\sdk\redist'

try:
    os.makedirs(os.path.dirname(dst_steam), exist_ok=True)
    os.makedirs(os.path.dirname(dst_redist), exist_ok=True)
    
    print(f"Copying {src_steam} to {dst_steam}")
    if os.path.exists(dst_steam):
        shutil.rmtree(dst_steam)
    shutil.copytree(src_steam, dst_steam)
    print("[OK] Steam headers copied")
    
    print(f"Copying {src_redist} to {dst_redist}")
    if os.path.exists(dst_redist):
        shutil.rmtree(dst_redist)
    shutil.copytree(src_redist, dst_redist)
    print("[OK] Redist binaries copied")
    
    print(f"\nVerification:")
    print(f"Steam headers exist: {os.path.exists(dst_steam)}")
    print(f"Redist binaries exist: {os.path.exists(dst_redist)}")
    
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
