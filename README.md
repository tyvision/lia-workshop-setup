# CI/CD + continuous inspection workshop
### LIA (Innopolis University SNE program course) - Large Installation Administration

## Description of the workshop

Here we will try C/C++ project in CI/CD workflow. CI runner environment is docker container. 

## Toolchain
- gitlab-ci + gitlab runner (docker in docker with prepared image)
- ansible
- sonaqube + plugins
- cppcheck (SAST C/C++) in CI
- valgrind (DAST C/C++) in CI
- afl (fuzzing) in CI

## Before you run

Check IP addresses (they are hardcoded in `docker-compose.yml` file) and replace them with yours. Also if you wish you can replace passwords, they are not so secret, as it is just a test env

## How to deploy

Just run `deploy_infrastructure.sh` script with **root** privileges. Script will install `git`, `docker`, `docker-compose` and then deploy `gitlab-ci`, `sonarqube` (with postgres as a dependency), and `gitlab-runner`. All you have to do is: 
1. to open gitlab-ci using `your IP:80`, 
2. change default password and login, 
3. create test project, 
4. go to Settings->CI/CD and see the IP + token for registering new runner
5. go to `/var/lib/docker/volumes/dockersonarqube_sonarqube_extensions/_data/plugins` and put plugin files from `plugins/` folder

## Test repo howto
### What is here?

This is the test repository with all needed features to perform full stack continious integration with code continious inspection.

### What to do?

Copy files from folder `test` to any folder you like outside this one (git does not like when in the repo code there is another `.git` folder)

### What files to configure

There are 2 main files that you should configure:
- sonar-project.properties -- sonar-scanner config file with project properties (do not forget where to send the reports)

```#----- Default SonarQube server
sonar.host.url=http://<your IP>:9000

#----- Default source code encoding
sonar.sourceEncoding=UTF-8```

- .gitlab-ci.yaml -- gitlab continious integration config file. If present, it launches the CI pipeline on the runner.

## TODOs List
1) add Ansible to the process of deployment
2) play with GKE (Google Kubernetes Engine) as an environment for test/staging/production
3) add documentation (+ useful links) on what to do next after deployment.
