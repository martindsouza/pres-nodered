---?color=black

[@img[span-60](assets/img/logo-nodered.png)](https://nodered.org/)

Note:

- Node Red is a **flow based programming** tool, primarily built for IoT Integration

- Developed by IBM now open source (but you still see a lot of Watson integration)


---

@snap[north span-100]
## Node-RED: Install
@snapend


@snap[midpoint]


@ul[no-list-style](false)
- @fa[desktop] Local
- @css[text-brand-nodered](@fab[docker] **Docker**)
- @fab[raspberry-pi] RaspberryPi
@ulend

@snapend

@snap[south text-italic]
[Install Options](https://nodered.org/docs/getting-started/)
@snapend

Note:

- Will focus on Docker install


---

@snap[north span-100]
## Node-RED: Docker
@snapend


@snap[midpoint]
```bash
docker run -it -d \
  -p 1880:1880 \
  -v ~/docker/node-red:/data \
  --name nodered \
  --network=oracle_network \
  martindsouza/node-red-oracle
```
@snapend

@snap[south span-100]
@[1-2,zoom-15](Start container and port to use: `laptop:server`)
@[3,zoom-15](`~/docker/node-red` folder on laptop to save Node-RED data)
@[4,zoom-15](Optional: Name to be used again)
@[5,zoom-15](Optional: Reference Docker network)
@[6,zoom-15](Custom Docker image: includes Oracle drivers)

@css[text-italic text-04]([Custom Docker image](https://github.com/martindsouza/docker-node-red-oracle))
@snapend


---?color=black


@snap[midpoint]
# Demo
@snapend
