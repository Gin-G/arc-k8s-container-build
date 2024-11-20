# docker build --progress=plain --tag benjaminkirk/opensuse15-base:0.0.1 .
# docker run --user root --rm --volume $(pwd)/data:/sw -it benjaminkirk/opensuse15-base:0.0.1 /bin/bash -l

FROM docker.io/opensuse/leap
# (deprecated): MAINTAINER Ben Kirk <benkirk@ucar.edu>

########################################
# Add docker-clean
########################################
RUN cat <<EOF > /usr/bin/docker-clean
#!/bin/bash
echo "[\${0}]: cleaning temporary files from container image to reduce layer size"
[ -x "\$(command -v yum)" ] && yum clean all
[ -x "\$(command -v apt)" ] && apt clean
[ -x "\$(command -v conda)" ] && conda clean --all
[ -x "\$(command -v zypper)" ] && zypper clean -a
for dir in /tmp/* /var/tmp/* /home/jupyter/{.ccache,.cache/pip,conda-bld,.conda} /root/* /root/.[^.]* /var/lib/apt/lists/* /var/log/*; do
	[ -e $dir ] && rm -rf $dir 2>/dev/null || true
done
EOF

# Basic development environment setup
RUN echo "basic zypper setup" \
    && set -x \
    && zypper --non-interactive refresh \
    && zypper --non-interactive update \
    && mkdir -p /container \
    && chmod a+rx /usr/bin/docker-clean \
    && cat /etc/os-release \
    && docker-clean

# archive this Dockerfile in the image
# ADD extras/Dockerfile.* /container/

# Local Variables:
# mode: sh
# End:
