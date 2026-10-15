#!/usr/bin/env python3
"""Packs the mission folder into one uncompressed .pbo per terrain.

Usage: python3 tools/pack_pbo.py [--out DIR] [--islands enoch,Altis,...]
Writes DIR/static_platoon_ops.<island>.pbo (default DIR: ./out). Skips the same dev files as build.ps1.
mission.sqm is copied as is; positions in it are Livonia's, other terrains rely on the runtime objective.
"""
import argparse, hashlib, os, struct, time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
NAME = "static_platoon_ops"
ISLANDS = ["enoch", "Tanoa", "Malden", "Takistan", "tem_anizay", "fallujah", "fapovo", "lythium", "Altis",
           "tem_kujari", "cup_chernarus_A3", "gm_weferlingen_summer", "gm_weferlingen_winter", "tem_chamw",
           "tem_cham", "oski_ire"]
EXCLUDE = {".git", ".github", ".hemtt", "tools", "addons", "out", "CLAUDE.md", "build.ps1", ".gitignore"}


def mission_files():
    files = []
    for dirpath, dirnames, filenames in os.walk(ROOT):
        rel_dir = os.path.relpath(dirpath, ROOT)
        top = rel_dir.split(os.sep)[0]
        if top in EXCLUDE:
            dirnames[:] = []
            continue
        dirnames[:] = sorted(d for d in dirnames if not (rel_dir == "." and d in EXCLUDE))
        for name in sorted(filenames):
            if rel_dir == "." and name in EXCLUDE:
                continue
            path = os.path.join(dirpath, name)
            files.append((os.path.relpath(path, ROOT).replace(os.sep, "\\"), path))
    return files


def pack(files, out_path):
    header = bytearray()
    # product entry ("Vers") with an empty header extension list
    header += b"\0" + struct.pack("<5I", 0x56657273, 0, 0, 0, 0) + b"\0"
    blobs = []
    for rel, path in files:
        with open(path, "rb") as f:
            data = f.read()
        stamp = int(os.path.getmtime(path))
        header += rel.encode("ascii") + b"\0" + struct.pack("<5I", 0, len(data), 0, stamp, len(data))
        blobs.append(data)
    header += b"\0" + struct.pack("<5I", 0, 0, 0, 0, 0)
    body = bytes(header) + b"".join(blobs)
    with open(out_path, "wb") as f:
        f.write(body + b"\0" + hashlib.sha1(body).digest())


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--out", default=os.path.join(ROOT, "out"))
    parser.add_argument("--islands", default=",".join(ISLANDS))
    args = parser.parse_args()
    os.makedirs(args.out, exist_ok=True)
    files = mission_files()
    for island in [i for i in args.islands.split(",") if i]:
        out_path = os.path.join(args.out, f"{NAME}.{island}.pbo")
        pack(files, out_path)
        print(f"Packed {out_path} ({len(files)} files)")


if __name__ == "__main__":
    main()
