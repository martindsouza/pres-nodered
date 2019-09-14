
## Gitpitch

http://localhost:9090/gitpitch/desktop/manager

```bash

docker pull gitpitch/desktop:pro

docker run -it \
	-v ~/Documents/GitHub/martindsouza/pres-nodered:/repo \
  -e PORT=9090 \
  -e SWEEP=false \
	-p 9090:9090 \
	gitpitch/desktop:pro


```