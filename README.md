

- I'm assuming that I have to develop a "manual" way of doing a blue-green deployment, instead of using Kubernetes or ECS, for example.
- This way, we can see how B/G deployment works at low level
- Other ways of doing it could be AWS/ECS, Kuberntes ( Istio or standard method ), EC2 AMI in different auto-scaling groups and target-groups, etc.

## Build

### Router

Router image is being built from directory `docker/router`, where I placed the `Dockerfile` and default `nginx` configuration. Configuration will be later overriden with the one in `config` directory.

### Application


## Run

To run the default configuration, we have to issue the `docker-compose` command
```
docker-compose up -d
```

## Deploying new application version

- The application is a very simple REST API that returns our location and IP address
- When the application code in directory `docker/app` is changed, the `reconfig.sh` script has to be launched to switch to new version
  - Check the current version
  - Reconfigure `router` to point to new version
  - Force new version container to be re-built with new code
  - Apply new `router` configuration
  - Make a simple call to see if the returned HTTP code is correct
  - Rollback or keep the new version, based on previous check
- In a real environment the CI/CD pipeline is in charge of launching the reconfig script every time the code is modified
- For example, AWS/ECS has an implementation of B/G deployment to be automated at `service` level, switching between configured `task-definition`. We can achieve this behavior through `aws-cli` too, by checking previous task version and creating a new one with the new application version ( docker container tag, in this case )

### Execute switching script

We can change the code manually, as could be done in a production environment through repository PR creation/merging, modifying it in the `docker/app/code` directory. Then, we can launch the `reconfig.sh` script to see how the new application is deployed and switched.
```
./reconfig.sh
```
