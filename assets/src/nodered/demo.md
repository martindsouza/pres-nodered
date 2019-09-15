*** REMIND PEOPLE ***

THINK DIFFERENT!

*** Initial ***

Problem: Introduction to NodeRed

Solution: 

```bash
ssh opc@ocidockerdev.talkapex.com

docker run -it -d \
  -p 1880:1880 \
  -v node-red:/data \
  --name nodered \
  --network=oracle_network \
  martindsouza/node-red-oracle
```

# Talk about port forwarding with Tunnel
http://localhost:9980



- Show Nodes on left
- Show basic Timer > Debug > Output
  - Good for testing



Problem:



TODO: - Show Problem / Solution

- Install Oracle to get some interesting info

- Get Data
  - Get CSV Data
  - Get CSV data via a given parameter

- Connect to real world REST service to parse some info
  - Parse data (make all lower case and only filter out what we want or manipulate it)
  - Custom functio?

- Email


- Unzip file

