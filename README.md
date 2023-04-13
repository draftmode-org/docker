## FAQ (Docker Desktop + WSL2)
### restart WSL
1. Open Command Prompt [Win + R]
2. ```wsl --shutdown```<br>

will automatically shut down + restart WSL

### docker endpoint for "default" not found

**How to reproduce**
```
docker compose up
# => docker endpoint for "default" not found
```
**How to solve**
1. Stop Docker Desktop and all containers
2. Go to path ~/.docker/contexts/meta
```
~/.docker/contexts/meta/(some sha256)/meta.json
```
3. Delete file/folder
```
rm {fe9c6bd7a66301f49ca9b6a70b217107cd1284598bfc254700c989b916da791e} -R
```
4. Restart Docker Desktop
