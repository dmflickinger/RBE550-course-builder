# RBE550-course-builder
Container project to build all course materials for RBE-550

## Container build

```sh
docker build https://github.com/dmflickinger/RBE550-course-builder.git#main
```


```sh
ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts
```

```sh
docker compose  --env-file rbe550.env up
```


