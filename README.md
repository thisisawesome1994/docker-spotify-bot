## **docker-spotify**

A docker container for [Spotify](https://spotify.com) via noVNC.

### **Features:**

-   Based on [jlesage/docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui)
-   Contains the official Spotify package
-   Supports audio device pass-through.
-   Uses a volume for persistent config.

### **Build:**

```
docker build -t docker-spotify .
```

### **Deploy:**

```
docker run --rm -p 5900:5900  docker-spotify:latest
docker run --rm -p 5901:5900  docker-spotify:latest
docker run --rm -p 5902:5900  docker-spotify:latest
```

### **Ports:**

-   5800/tcp - Web server for noVNC
-   5900/tcp - WebSocket / VNC
