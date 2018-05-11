# [EasyEngine](https://easyengine.io/)

## Quick Start

### Distro

- Ubuntu 12.04 & 14.04 & 16.04
- Debian 7 & 8

### Port Requirements:

| Name  | Port Number | Inbound | Outbound  |
|:-----:|:-----------:|:-------:|:---------:|
|SSH    |22           | ✓       |✓          |
|HTTP    |80           | ✓       |✓          |
|HTTPS/SSL    |443           | ✓       |✓          |
|EE Admin    |22222           | ✓       |          |
|GPG Key Server    |11371           |        |✓          |

### Cheatsheet - Site creation

```bash
sudo ee site create example.com --wp     # Install required packages & setup WordPress on example.com
```

|                    |  Single Site  | 	Multisite w/ Subdir  |	Multisite w/ Subdom     |
|--------------------|---------------|-----------------------|--------------------------|
| **NO Cache**       |  --wp         |	--wpsubdir           |	--wpsubdomain           |
| **WP Super Cache** |	--wpsc       |	--wpsubdir --wpsc    |  --wpsubdomain --wpsc    |
| **W3 Total Cache** |  --w3tc       |	--wpsubdir --w3tc    |  --wpsubdomain --w3tc    |
| **Nginx cache**    |  --wpfc       |  --wpsubdir --wpfc    |  --wpsubdomain --wpfc    |
| **Redis cache**    |  --wpredis    |  --wpsubdir --wpredis |  --wpsubdomain --wpredis |

#### Standard WordPress Sites

```bash
ee site create example.com --wp                  # install wordpress without any page caching
ee site create example.com --w3tc                # install wordpress with w3-total-cache plugin
ee site create example.com --wpsc                # install wordpress with wp-super-cache plugin
ee site create example.com --wpfc                # install wordpress + nginx fastcgi_cache
ee site create example.com --wpredis             # install wordpress + nginx redis_cache
```

#### Non-WordPress Sites

```bash
ee site create example.com --html     # create example.com for static/html sites
ee site create example.com --php      # create example.com with php support
ee site create example.com --mysql    # create example.com with php & mysql support
```

#### HHVM Enabled Sites

```bash
ee site create example.com --wp --hhvm           # create example.com WordPress site with HHVM support
ee site create example.com --php --hhvm          # create example.com php site with HHVM support
```

### Installation/Setup

#### Voraussetzung

* Non-root User
* Hostname 

##### Non-root User

```bash
adduser name
usermod -a -G sudo isp
```

##### Hostname

```bash
nano /etc/hostname
nano /etc/hosts
reboot
```

###### /etc/hostname

```bash
export HOSTNAMESHORT=server1
echo $HOSTNAMESHORT > /etc/hostname
/etc/init.d/hostname.sh start
```

###### /etc/hosts

#### Installation EasyEngine

```bash
wget -qO ee rt.cx/ee && sudo bash ee     # Install easyengine 3
```

#### Installation Monit

- https://easyengine.io/tutorials/monitoring/monit/

## Useful Links

- [Documentation](https://easyengine.io/docs/)
- [FAQ](https://easyengine.io/faq/)
- [Conventions used](https://easyengine.io/wordpress-nginx/tutorials/conventions/)
- https://kb.virtubox.net/

### Software

- https://www.vimbadmin.net
- https://virtubox.net/

### GitHub Repos

- https://github.com/EasyEngine
- https://github.com/EasyEngine/easyengine
- https://github.com/VirtuBox/ubuntu-nginx-web-server
- https://github.com/VirtuBox/nginx-ee
- https://github.com/VirtuBox/debian-ubuntu-mariadb-backup
- https://github.com/VirtuBox/easyengine-dashboard
- https://github.com/VirtuBox/netdata-dashboard
- https://github.com/VirtuBox/wp-optimize
- https://github.com/VirtuBox

### EasyEngine Wiki

**Installation**

- [Install](https://easyengine.io/docs/install/)

**Monitoring**

- [Monit](https://easyengine.io/tutorials/monitoring/monit/)

### Community Guides
- [Develop and Deploy with EasyEngine + VVV + Wordmove](https://github.com/joeguilmette/ee-vvv-wordmove)

## Entwicklung

[![Travis Build Status](https://travis-ci.org/EasyEngine/easyengine.svg)](https://travis-ci.org/EasyEngine/easyengine) [![Join EasyEngine Slack Channel](http://slack.easyengine.io/badge.svg)](http://slack.easyengine.io/)

**Update:** [We are working on next major release (v4) which will be in PHP and based on WP-CLI](https://easyengine.io/blog/easyengine-v4-development-begins/).
