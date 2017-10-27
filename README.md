# Background

This is an example script to reproduce [phpredis issue #1210](https://github.com/phpredis/phpredis/issues/1210). We noticed [segmentation faults after upgrading to version 3.1.3 of phpredis](https://github.com/remicollet/remirepo/issues/75), through the [php-pecl-redis](https://rpms.remirepo.net/enterprise/6/php54/x86_64/repoview/php-pecl-redis.html) package for CentOS 6 from Remi Collet's repository. Version 3.1.4 did not fix this bug.

The segmentation fault seems to be triggered by the presence of a property,
visiblity does not matter, AND the use of either the var_dump() or print_r()
functions.

# Results

Here are the results for various combinations of PHP and phpredis versions.

| PHP Version | phpredis 3.1.2 |   phpredis 3.1.4   |
| :---------: | :------------: | :----------------: |
|   5.4.45    |       Ok       | Segmentation fault |
|   5.6.32    |       Ok       | Segmentation fault |
|   7.0.25    |       Ok       |         Ok         |
|   7.1.11    |       Ok       |         Ok         |

# How to run example script?

The example script can be easily ran against combinations of PHP and phpredis
versions:

```shell
make run PHP=5.4 PHPREDIS=3.1.2
make run PHP=5.4 PHPREDIS=3.1.4
make run PHP=7.1 PHPREDIS=3.1.2
```

When there are no segmentation faults, the output looks like this, note the PHP object dump at the end:

```shell
$ make run PHP=5.6 PHPREDIS=3.1.2
Building Docker image

Sending build context to Docker daemon  67.58kB
Step 1/6 : FROM centos:6.9
 ---> bf590786153a
Step 2/6 : RUN rpm --install http://mirror.nodesdirect.com/epel/6/x86_64/epel-release-6-8.noarch.rpm
 ---> Using cache
 ---> df42d43aa75f
Step 3/6 : RUN rpm --install https://rpms.remirepo.net/enterprise/remi-release-6.rpm
 ---> Using cache
 ---> 98f973397a4b
Step 4/6 : ARG php_version
 ---> Using cache
 ---> 119b3aefb624
Step 5/6 : ARG phpredis_version
 ---> Using cache
 ---> 49a7bdf44b0f
Step 6/6 : RUN yum install --assumeyes --enablerepo remi-php${php_version} php-cli php-pecl-redis-${phpredis_version}
 ---> Using cache
 ---> a54e7f1fb0d2
Successfully built a54e7f1fb0d2
Successfully tagged php-pecl-redis-segfault:56-3.1.2

Running example script

PHP: 5.6.32
phpredis: 3.1.2

object(MyRedis)#1 (1) {
  ["dummy"]=>
  NULL
}
```

Here is the output when PHP segfaults, note the missing PHP object dump and the Make error at the end:

```shell
$ make run PHP=5.6 PHPREDIS=3.1.4
Building Docker image

Sending build context to Docker daemon  67.58kB
Step 1/6 : FROM centos:6.9
 ---> bf590786153a
Step 2/6 : RUN rpm --install http://mirror.nodesdirect.com/epel/6/x86_64/epel-release-6-8.noarch.rpm
 ---> Using cache
 ---> df42d43aa75f
Step 3/6 : RUN rpm --install https://rpms.remirepo.net/enterprise/remi-release-6.rpm
 ---> Using cache
 ---> 98f973397a4b
Step 4/6 : ARG php_version
 ---> Using cache
 ---> 119b3aefb624
Step 5/6 : ARG phpredis_version
 ---> Using cache
 ---> 49a7bdf44b0f
Step 6/6 : RUN yum install --assumeyes --enablerepo remi-php${php_version} php-cli php-pecl-redis-${phpredis_version}
 ---> Using cache
 ---> dc578fc33e0d
Successfully built dc578fc33e0d
Successfully tagged php-pecl-redis-segfault:56-3.1.4

Running example script

PHP: 5.6.32
phpredis: 3.1.4

make: *** [run] Error 139
```
# How to clean up the Docker images?

Run the following command to list the Docker images created by this project:

```shell
docker images php-pecl-redis-segfault
```

If you do not see any Docker images that you want to keep in this list, then delete them:

```shell
docker images php-pecl-redis-segfault -q | xargs docker rmi --force
```

