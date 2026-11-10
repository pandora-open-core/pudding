#!/bin/sh
# Read-only runtime audit of the corpus compiled at image build time.
set -eu
cd "$(dirname "$0")/../proofs"
python3 scripts/check_proofs.py
cd lean
for audit in Audit LangevinAudit AccelerationAudit FlowDataAudit EquilibriumAudit; do
    lake env lean "$audit.lean"
done
