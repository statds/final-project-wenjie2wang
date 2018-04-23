## Getting startted

Let's first pull the docker image from docker hub. The size of compressed
files is about 1 GB and the extracted image will take about 3 GB.

```bash
docker pull wenjie2wang/statds-spring2018
```

Then, we may run the docker image as a container by

```bash
docker run -it -p 6006:6006 --rm wenjie2wang/statds-spring2018:latest
```

where the flag `-it` enables interactive pseudo terminal and flag `--rm` tells
docker to automatically remove the container when it exits.  We also added `-p
6006:6006` to the `docker run` command for access to the tensorboard at
`localhost:6006`.
