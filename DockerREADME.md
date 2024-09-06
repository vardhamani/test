# Docker Volume Management

This README provides a comprehensive guide to Docker volume management, including discovery, creation, usage, cleanup, backup, and restoration, as well as related concepts like bind mounts and S3 bucket mounting.

## Table of Contents

1. [Key Concepts](#key-concepts)
2. [Discover Anonymous Docker Volumes](#discover-anonymous-docker-volumes)
3. [Create a Docker Volume](#create-a-docker-volume)
4. [Use the Volume with Containers](#use-the-volume-with-containers)
5. [Using Bind Mounts](#using-bind-mounts)
6. [Mounting S3 Buckets](#mounting-s3-buckets)
7. [Clean Up Unused Volumes](#clean-up-unused-volumes)
8. [Back Up and Restore Docker Volumes](#back-up-and-restore-docker-volumes)
9. [Key Commands Summary](#key-commands-summary)

## Key Concepts

- **Anonymous volumes**: Automatically created by Docker, not explicitly named by users.
- **Named volumes**: Explicitly created and named by users, persist after container removal.
- **Volume persistence**: Volumes retain data independent of container lifecycle.
- **Volume sharing**: Multiple containers can mount the same volume.
- **Volume backup/restore**: Volumes can be backed up and restored for data preservation.
- **Volume cleanup**: Removing unused volumes to free up space.
- **Bind mounts**: Mount a specific path from the host into the container.
- **S3 bucket mounting**: Mount an Amazon S3 bucket as a local file system.

## Discover Anonymous Docker Volumes

1. Check Docker images:
   ```
   docker images
   ```

2. Run containers:
   ```
   docker run -d --name db1 postgres:12.1
   docker run -d --name db2 postgres:12.1
   ```

3. List and inspect volumes:
   ```
   docker volume ls
   docker inspect db1 -f '{{ json .Mounts }}' | python -m json.tool
   ```

4. Create a temporary container:
   ```
   docker run -d --rm --name dbTmp postgres:12.1
   ```

5. Stop containers:
   ```
   docker stop db2 dbTmp
   ```

## Create a Docker Volume

1. Create a named volume:
   ```
   docker volume create website
   ```

2. Verify creation:
   ```
   docker volume ls
   ```

3. Copy data to the volume:
   ```
   sudo cp -r /path/to/source/* /var/lib/docker/volumes/website/_data/
   ```

## Use the Volume with Containers

1. Run a container with the volume:
   ```
   docker run -d --name web1 -p 80:80 -v website:/usr/local/apache2/htdocs:ro httpd:2.4
   ```

2. Verify connectivity:
   ```
   curl http://<PUBLIC_IP_ADDRESS>
   ```

3. Run a temporary container with the same volume:
   ```
   docker run -d --name webTmp --rm -v website:/usr/local/apache2/htdocs:ro httpd:2.4
   ```

## Using Bind Mounts

Bind mounts allow you to mount a specific path from the host into the container. This is useful for development environments or when you need to access specific files on the host.

1. Run a container with a bind mount:
   ```
   docker run -d --name web1 -p 80:80 --mount type=bind,source=/mnt/widget-factory,target=/usr/local/apache2/htdocs,readonly httpd:2.4
   ```

   This command does the following:
   - `-d`: Runs the container in detached mode
   - `--name web1`: Names the container "web1"
   - `-p 80:80`: Maps port 80 on the host to port 80 in the container
   - `--mount`: Specifies a mount
     - `type=bind`: Indicates this is a bind mount
     - `source=/mnt/widget-factory`: The source directory on the host
     - `target=/usr/local/apache2/htdocs`: The target directory in the container
     - `readonly`: Makes the mount read-only in the container
   - `httpd:2.4`: The image to use (Apache HTTP Server version 2.4)

2. Verify the bind mount:
   ```
   docker inspect web1
   ```
   Look for the "Mounts" section in the output to confirm the bind mount details.

3. Access the website:
   ```
   curl http://<PUBLIC_IP_ADDRESS>
   ```

Note: Any changes made to the files in `/mnt/widget-factory` on the host will be immediately reflected in the container.

## Mounting S3 Buckets

S3FS allows you to mount an Amazon S3 bucket as a local file system. This can be particularly useful when you need to access large amounts of data stored in S3 from your Docker containers.

1. Install s3fs if not already installed:
   ```
   sudo apt-get install s3fs
   ```

2. Mount an S3 bucket:
   ```
   sudo s3fs $BUCKET /mnt/widget-factory -o allow_other -o use_cache=/tmp/s3fs
   ```

   This command does the following:
   - `s3fs`: The S3FS command
   - `$BUCKET`: An environment variable containing the name of your S3 bucket
   - `/mnt/widget-factory`: The local mount point where the S3 bucket will be accessible
   - `-o allow_other`: Allows other users to access the mount
   - `-o use_cache=/tmp/s3fs`: Enables local caching to improve performance

3. Verify the mount:
   ```
   df -h
   ```
   You should see your S3 bucket listed as a mounted file system.

4. Use with Docker:
   Once mounted, you can use this directory as a bind mount in Docker:
   ```
   docker run -d --name web1 -p 80:80 --mount type=bind,source=/mnt/widget-factory,target=/usr/local/apache2/htdocs,readonly httpd:2.4
   ```

Note: Ensure that your system has the necessary AWS credentials configured to access the S3 bucket. You may need to set up an AWS credentials file or use IAM roles if running on an EC2 instance.

## Clean Up Unused Volumes

1. Remove unused volumes:
   ```
   docker volume prune
   ```

2. Remove specific containers:
   ```
   docker rm db2
   ```

## Back Up and Restore Docker Volumes

1. Back up a volume:
   ```
   sudo tar czf /tmp/website_$(date +%Y-%m-%d-%H%M).tgz -C /var/lib/docker/volumes/website/_data .
   ```

2. Verify backup:
   ```
   ls -l /tmp/website_*.tgz
   tar tf /tmp/website_*.tgz
   ```

3. Restore a volume:
   ```
   sudo tar xf /tmp/<BACKUP_FILE_NAME>.tgz -C /var/lib/docker/volumes/website/_data
   ```

## Key Commands Summary

- List volumes: `docker volume ls`
- Inspect container mounts: `docker inspect <container> -f '{{ json .Mounts }}'`
- Create named volume: `docker volume create <name>`
- Run container with volume: `docker run -v <volume_name>:<container_path> <image>`
- Run container with bind mount: `docker run --mount type=bind,source=<host_path>,target=<container_path> <image>`
- Clean up unused volumes: `docker volume prune`
- Backup volume: `tar czf backup.tgz -C <volume_path> .`
- Restore volume: `tar xf backup.tgz -C <volume_path>`
- Mount S3 bucket: `sudo s3fs $BUCKET /mount/point -o allow_other -o use_cache=/tmp/s3fs`

Remember to regularly back up important data, clean up unused volumes, and properly unmount S3 buckets when no longer needed to maintain a healthy Docker environment.
