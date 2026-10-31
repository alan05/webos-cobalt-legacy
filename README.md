# Legacy Cobalt / Starboard support for LG webOS

Experimental compatibility engineering for legacy LG webOS,
initially focused on webOS 4.

## Scope

- Cobalt: 23.lts.6
- Legacy Starboard interfaces
- LG ACB video presentation
- Starfish hardware playback integration
- ARMv7 LG webOS 4 compatibility

## Verified device

- LG 75UK6500PLA
- Firmware 05.50.70
- webOS 4.4.3-22

An earlier equivalent implementation demonstrated 2160p
YouTube playback. The extracted patch has not yet been
independently rebuilt and regression-tested in this repository.

## Upstream provenance

The legacy patch derives from RF1705's
youtube-webos-cobalt-adfree project.

See docs/rf1705-base-commit.txt for the upstream baseline
and docs/webos4-patch-commit.txt for the extracted patch commit.

The patch is stored in patches/rf1705-cobalt23/.

## Contribution strategy

Legacy Cobalt 23 compatibility is maintained separately
from proposed contributions to current Google Cobalt.

Current Cobalt/Starboard interfaces require an independent
port, relevant tests and upstream review.

This is an unofficial community engineering project,
not an official Google, LG or YouTube port.

## Status

Experimental. No redistributable binaries or supported
platform release are provided.

Component licensing, binary redistribution requirements
and upstream contribution readiness require further review.
