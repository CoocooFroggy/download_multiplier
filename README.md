# Download multiplier

Splits a URL download into x files using the `range` header, and concatenates them when finished. Useful for servers that have a download speed limit

> Note: Servers may have blocks against simultaneous downloads. You would need to use some sort of proxy for this to work.

## Environment Variables

- `URL_X`: URL of the file you want to download — replace X with 1, 2, etc for each chunk (currently a hardcoded number in `bin/download_multiplier.dart`) 