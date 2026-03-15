# n8n Custom Image (PUID/PGID Support)

This image is a modified version of the official n8n distribution. It addresses the limitation of the default image being hardcoded to UID/GID `1000:1000`, which often causes permission conflicts on specific cloud environments or Linux distributions where the primary user utilizes different identifiers.


## Key Feature

**Dynamic Permissions:** Includes a startup script that adjusts the internal n8n user to match the `PUID` and `PGID` defined in your environment variables. This ensures that all persistent data and volumes are owned by your host user rather than a hardcoded default.

## Usage

### Docker Compose

```yaml
services:
  n8n:
    image: solodolobolo/n8n:latest
    container_name: n8n
    restart: unless-stopped
    environment:
      - PUID=1001
      - PGID=1001
      # other environment variables
    volumes:
      - /path/to/volume:/home/node/.n8n
    ports:
      - 5678:5678
```

## Environment Variables

| Variable | Function |
| :--- | :--- |
| PUID | Sets the User ID for the n8n process (e.g., 1001) |
| PGID | Sets the Group ID for the n8n process (e.g., 1001) |

Refer to the official n8n documentation for more configuration options:
https://docs.n8n.io/

## Implementation Details

Upon container start, the system checks the provided PUID and PGID. If they differ from the default, the image reassigns the node user's identity and performs a recursive chown on the /home/node directory before launching the n8n application. This prevents "Permission Denied" errors when mounting volumes on hosts with non-standard user IDs.