# Amazon SageMaker Edge Manager on Torizon #

This project is a porting for Torizon of the original demo [dlr-demo](https://github.com/NXPmicro/meta-aws/tree/aws-cloud-demo/recipes-devtools/amazon-sagemaker-neo/dlr-demo) from NXP that demonstrates features of [Amazon SageMaker Edge Manager](https://docs.aws.amazon.com/sagemaker/latest/dg/edge.html) and [AWS IoT Greengrass V2](https://docs.aws.amazon.com/greengrass/v2/developerguide/greengrass-v2-whats-new.html).

# Installing Pre-Requisites #

## On your Linux PC ##

**On your Linux PC**

[Download and install the AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) . Don't forget to follow the [Pre-requisites](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-prereqs.html) and to [configure the CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)

[Install Docker](https://docs.docker.com/get-docker/). Don't forget to login the engine on your dockerhub account using the [docker login](https://docs.docker.com/engine/reference/commandline/login/) command.

Install the following pre-requisites:
```
$ apt install sshpass
```

## On Maivin ##

Connect Maivin to a router with internet connection using the Ethernet Cable. Connect it to the power supply. A blue light will turn on.

Scan your local network to find the board IP and MAC address. You can [use the command line](https://developer-archives.toradex.com/knowledge-base/scan-your-local-network-to-find-the-board-ip-and-mac-address) or some [GUI-based software](https://angryip.org/download/#linux).

Connect to Maivin's terminal using `ssh` with the default username `torizon`:

```
$ ssh torizon@<board-ip>
```

The default password is `torizon`. The system will ask you to change this password on firt boot. On some units, the default password may be already set to `1`.

**On your board's terminal** , stop the pre-provisioned containers by sending the command:

```
# sudo systemctl disable docker-compose
```

Reset the board.

```
# sudo reboot
```

Take a note of the IP and password.

# Setting Up #

Modify the `project_settings.sh` file.

Set your selected `AWS_REGION`.

Set `PROJECT_NAME` with a unique project name.

Set `DOCKERHUB_LOGIN` with your dockerhub username. This will be used to push and pull containers to Maivin.

Set your `BOARD_IP` as found on the previous steps. You can also use the hostname.

Set `BOARD_PWD` with the password for Maivin as described in the previous steps.

## Install the services in the Cloud ##

After setting up the `project_settings.sh` file, **on your PC**, use `setup_cloud_service.sh` script

```
$ cd aws-cloud-demo-torizon
$ ./setup_cloud_service.sh
```

It may take about 15 minutes to conclude.

## Install the credentials in the device ##

**on your PC**, use `setup_device.sh` script. This will install AWS IoT Greengrass on Maivin's filesystem, with its credentials and certificates.

```
$ ./setup_device.sh
```

After this, **on your PC terminal**, use `greengrass.sh` to start execution of AWS IoT Greengrass on maivin:

### UPDATE
Before running `greengrass.sh`, 

- Manually delete previous greengrass folder on device: `sudo rm -rf /home/torizon/greengrass`
- Manually delete previous kvs files and folder on device: `sudo rm -rf /home/torizon/kvs*`

```
$ ./greengrass.sh
```

This will start Greengrass Nucleus.


You can execute everything by sending:

```
$ ./setup_cloud_service.sh && ./setup_device.sh && ./greengrass.sh
```

### UPDATE
After running `greengrass.sh`, assign `root:root` user and group to the `aws.greengrass.SageMakerEdgeManager` component.

## Observing AWS IoT Greengrass logs ##

With AWS IoT Greengrass container running, **On your PC, create a new terminal window**. Connect to your board using `ssh`:

```
$ ssh torizon@<board-ip>
```

On the board's terminal, connect to the shell of the running container:

```
# docker exec -it aws-cloud-demo-torizon /bin/bash
```

It will start the bash terminal of the container. The logs are on the `/greengrass/v2/logs` directory:

```
## cd /greengrass/v2/logs/
## ls
aws.greengrass.LegacySubscriptionRouter.log
aws.greengrass.Nucleus.log
aws.greengrass.SageMakerEdgeManager.log
04_edgeManagerClientCameraIntegration.log
dlr-demo-torizon-mobilenet-ssd-v2-coco-quant.log
greengrass.log
main.log
```

## Observing the results ##

Use VLC player to view the video output:

![](vlc-stream-1.png)

![](vlc-stream-2.png)

# Cleaning up everything #

**CAUTION: THIS WILL DELETE ALL THE THINGS ON YOUR AWS ACCOUNT.**

To wipe all things and deployments created on your account, use the python `cleanup.py` script.

```
$ python3 cleanup.py
```

**CAUTION: THIS WILL DELETE ALL THE THINGS ON YOUR AWS ACCOUNT.**
