# jsk-mongo-docker-compose [![Build Status](https://travis-ci.org/furushchev/jsk-mongo-docker-compose.svg?branch=master)](https://travis-ci.org/furushchev/jsk-mongo-docker-compose)

### Install docker and compose

- Docker Engine
  - https://docs.docker.com/engine/installation/
- Compose
  - https://docs.docker.com/compose/install/

### Run docker machines

```bash
git clone https://github.com/furushchev/jsk-mongo-docker-compose.git
cd jsk-mongo-docker-compose
# database will be created at `data` directory
docker-compose up -d
```

### Shutdown docker machines

```bash
cd jsk-mongo-docker-compose
docker-compose down
```

### Show logs

```bash
docker ps -a  # find target machine
docker logs <machine name>
```

### Migrate data from another mongodb server

```bash
# on the same machine as `docker-compose up -d`
$ mongo
rs1:PRIMARY> use admin
switched to db admin
rs1:PRIMARY> db.runCommand({
 copydb: 1,
 fromhost: <source mongo server address>,
 fromdb: <source mongo database>,
 todb: <destination mongo database>
})
```


## Author

Yuki Furuta <<furushchev@jsk.imi.i.u-tokyo.ac.jp>>
