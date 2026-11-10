#!/usr/bin/env python3
"""Archive a clean, reviewed commit; release-check.sh must pass before promotion."""
import hashlib
import fnmatch
import tomllib
from pathlib import Path
import subprocess
import sys

root = Path(__file__).resolve().parents[1]
def git(*args):
    return subprocess.check_output(['git', '-C', str(root), *args])
if git('status', '--porcelain').strip():
    raise SystemExit('Commit reviewed changes before packaging a release.')
version = (root / 'VERSION').read_text().strip()
revision = git('rev-parse', 'HEAD').decode().strip()
out = Path(sys.argv[1] if len(sys.argv) > 1 else '/tmp/pudding-release').resolve()
if out == root or root in out.parents:
    raise SystemExit('Choose an output directory outside the checkout.')
out.mkdir(parents=True, exist_ok=True)
archive = out / f'pudding-{version}.tar.gz'
patterns = tomllib.loads((root / 'Cargo.toml').read_text())['package']['include']
patterns = [pattern.lstrip('/') for pattern in patterns]
tracked = git('ls-files').decode().splitlines()
public = [name for name in tracked if any(fnmatch.fnmatchcase(name, pattern) for pattern in patterns)]
public = sorted(set(public))
subprocess.run(['git', '-C', str(root), 'archive', '--format=tar.gz',
                f'--prefix=pudding-{version}/', '-o', str(archive), revision, '--', *public], check=True)
checksum = hashlib.sha256(archive.read_bytes()).hexdigest()
(out / 'SHA256SUMS').write_text(f'{checksum}  {archive.name}\n')
(out / 'REVISION').write_text(revision + '\n')
print(archive)
