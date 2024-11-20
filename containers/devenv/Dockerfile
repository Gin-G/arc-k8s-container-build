ARG BASE_OS="almalinux9"

ARG COMPILER_FAMILY="os-gcc"
ARG MPI_FAMILY="openmpi"

#ARG FINAL_TARGET="compilers"
ARG FINAL_TARGET="mpi"
#ARG FINAL_TARGET="iolibs"

ARG COMPILERS_PREREQ="${BASE_OS}"
ARG CUDA_PREREQ="compilers"
ARG ROCM_PREREQ="compilers"
ARG MINICONDA_PREREQ="${BASE_OS}"

ARG MPI_PREREQ="compilers"

ARG IOLIBS_PREREQ="mpi"

ARG TOGGLE_ENABLE_PARALLEL="--disable-parallel"
ARG TOGGLE_WITH_CUDA="--without-cuda"
ARG TOGGLE_WITH_ROCM="--without-rocm --without-hip"

################################################################################
# Part 1: various Base Operating Systems
################################################################################

#-------------------------------------------------------------------------------
# AlmaLinux v8 base stage: OS + os packages
FROM docker.io/almalinux:8 AS almalinux8
#-------------------------------------------------------------------------------
RUN cat <<EOF > /usr/bin/docker-clean
#!/bin/bash
echo "[\${0}]: cleaning temporary files from container image to reduce layer size"
[ -x "\$(command -v yum)" ] && yum clean all
[ -x "\$(command -v apt)" ] && apt clean
[ -x "\$(command -v conda)" ] && conda clean --all
[ -x "\$(command -v zypper)" ] && zypper clean -a
for dir in /tmp/* /var/tmp/* /home/jupyter/{.ccache,.cache/pip,conda-bld,.conda} /root/* /root/.[^.]* /var/lib/apt/lists /var/log/* ; do
	[ -e $dir ] && rm -rf $dir 2>/dev/null || true
done
rm -rf /tmp/*
EOF

RUN echo "yum: initial update" \
    && set -x \
    && yum -y update \
    && yum -y install dnf dnf-plugins-core \
    && dnf group list \
    && echo "GCC & build tools" \
    && dnf -y install \
           gcc gcc-c++ gcc-gfortran \
           make autoconf automake libtool \
           git wget which tar gzip bzip2 xz \
           python3 \
    && mkdir -p /container \
    && echo "# Common Configs" > /container/config_env.sh \
    && echo "export PATH=${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && ln -s /container/config_env.sh /etc/profile.d/z00-build-env.sh \
    && chmod a+rx /usr/bin/docker-clean \
    && cat /etc/*-release \
    && docker-clean
ENV PKG_INSTALL_CMD="dnf -y install"
SHELL ["/bin/bash", "--login", "-c"]


#-------------------------------------------------------------------------------
# AlmaLinux v9 base stage: OS + os packages
FROM docker.io/almalinux:9 AS almalinux9
#-------------------------------------------------------------------------------
RUN cat <<EOF > /usr/bin/docker-clean
#!/bin/bash
echo "[\${0}]: cleaning temporary files from container image to reduce layer size"
[ -x "\$(command -v yum)" ] && yum clean all
[ -x "\$(command -v apt)" ] && apt clean
[ -x "\$(command -v conda)" ] && conda clean --all
[ -x "\$(command -v zypper)" ] && zypper clean -a
for dir in /tmp/* /var/tmp/* /home/jupyter/{.ccache,.cache/pip,conda-bld,.conda} /root/* /root/.[^.]* /var/lib/apt/lists /var/log/* ; do
	[ -e $dir ] && rm -rf $dir 2>/dev/null || true
done
rm -rf /tmp/*
EOF

RUN echo "yum: initial update" \
    && set -x \
    && yum -y update \
    && yum -y install dnf dnf-plugins-core \
    && dnf group list \
    && echo "GCC & build tools" \
    && dnf -y install \
           gcc gcc-c++ gcc-gfortran \
           make autoconf automake libtool \
           git wget which tar gzip bzip2 xz \
           python3 \
    && mkdir -p /container \
    && echo "# Common Configs" > /container/config_env.sh \
    && echo "export PATH=${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && ln -s /container/config_env.sh /etc/profile.d/z00-build-env.sh \
    && chmod a+rx /usr/bin/docker-clean \
    && cat /etc/*-release \
    && docker-clean
ENV PKG_INSTALL_CMD="dnf -y install"
SHELL ["/bin/bash", "--login", "-c"]



#-------------------------------------------------------------------------------
# OpenSUSE 15 base stage: OS + os packages
FROM docker.io/opensuse/leap AS leap
#-------------------------------------------------------------------------------
RUN cat <<EOF > /usr/bin/docker-clean
#!/bin/bash
echo "[\${0}]: cleaning temporary files from container image to reduce layer size"
[ -x "\$(command -v yum)" ] && yum clean all
[ -x "\$(command -v apt)" ] && apt clean
[ -x "\$(command -v conda)" ] && conda clean --all
[ -x "\$(command -v zypper)" ] && zypper clean -a
for dir in /tmp/* /var/tmp/* /home/jupyter/{.ccache,.cache/pip,conda-bld,.conda} /root/* /root/.[^.]* /var/lib/apt/lists /var/log/* ; do
	[ -e $dir ] && rm -rf $dir 2>/dev/null || true
done
rm -rf /tmp/*
EOF

RUN echo "basic zypper setup" \
    && set -x \
    && zypper --non-interactive refresh \
    && zypper --non-interactive update \
    && echo "GCC & build tools" \
    && zypper --non-interactive install \
              gcc gcc-c++ gcc-fortran \
              gmake autoconf automake libtool \
              git wget which tar gzip bzip2 xz \
              python3 \
              awk diffutils \
    && mkdir -p /container \
    && echo "# Common Configs" > /container/config_env.sh \
    && echo "#export PATH=${PATH}" >> /container/config_env.sh \
    && echo "#export CPATH=${CPATH}" >> /container/config_env.sh \
    && echo "#export LIBRARY_PATH=${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "#export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && ln -s /container/config_env.sh /etc/profile.d/z00-build-env.sh \
    && chmod a+rx /usr/bin/docker-clean \
    && cat /etc/*-release \
    && docker-clean
ENV PKG_INSTALL_CMD="zypper --gpg-auto-import-keys --non-interactive install"
SHELL ["/bin/bash", "--login", "-c"]



#-------------------------------------------------------------------------------
# OpenSUSE Tumbleweed base stage: OS + os packages
FROM docker.io/opensuse/tumbleweed AS tumbleweed
#-------------------------------------------------------------------------------
RUN cat <<EOF > /usr/bin/docker-clean
#!/bin/bash
echo "[\${0}]: cleaning temporary files from container image to reduce layer size"
[ -x "\$(command -v yum)" ] && yum clean all
[ -x "\$(command -v apt)" ] && apt clean
[ -x "\$(command -v conda)" ] && conda clean --all
[ -x "\$(command -v zypper)" ] && zypper clean -a
for dir in /tmp/* /var/tmp/* /home/jupyter/{.ccache,.cache/pip,conda-bld,.conda} /root/* /root/.[^.]* /var/lib/apt/lists /var/log/* ; do
	[ -e $dir ] && rm -rf $dir 2>/dev/null || true
done
rm -rf /tmp/*
EOF

RUN echo "basic zypper setup" \
    && set -x \
    && zypper --non-interactive refresh \
    && zypper --non-interactive update \
    && echo "GCC & build tools" \
    && zypper --non-interactive install \
              gcc gcc-c++ gcc-fortran \
              gmake autoconf automake libtool \
              git wget which tar gzip bzip2 xz \
              python3 \
              awk diffutils \
    && mkdir -p /container \
    && echo "# Common Configs" > /container/config_env.sh \
    && echo "#export PATH=${PATH}" >> /container/config_env.sh \
    && echo "#export CPATH=${CPATH}" >> /container/config_env.sh \
    && echo "#export LIBRARY_PATH=${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "#export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && ln -s /container/config_env.sh /etc/profile.d/z00-build-env.sh \
    && chmod a+rx /usr/bin/docker-clean \
    && cat /etc/*-release \
    && docker-clean
ENV PKG_INSTALL_CMD="zypper --gpg-auto-import-keys --non-interactive install"
SHELL ["/bin/bash", "--login", "-c"]



#-------------------------------------------------------------------------------
# Ubuntu 24.04 LTS (Noble Numbat) base stage: OS + os packages
FROM  ubuntu:noble AS noble
#-------------------------------------------------------------------------------
ARG DEBIAN_FRONTEND=noninteractive
RUN cat <<EOF > /usr/bin/docker-clean
#!/bin/bash
echo "[\${0}]: cleaning temporary files from container image to reduce layer size"
[ -x "\$(command -v yum)" ] && yum clean all
[ -x "\$(command -v apt-get)" ] && apt-get clean -y && apt-get autoremove -y
[ -x "\$(command -v conda)" ] && conda clean --all
[ -x "\$(command -v zypper)" ] && zypper clean -a
for dir in /tmp/* /var/tmp/* /home/jupyter/{.ccache,.cache/pip,conda-bld,.conda} /root/* /root/.[^.]* /var/lib/apt/lists /var/log/* ; do
	[ -e $dir ] && rm -rf $dir 2>/dev/null || true
done
rm -rf /tmp/*
EOF

RUN echo "basic apt setup" \
    && set -x \
    && apt-get update \
    && apt-get autoclean \
    && apt-get install -y \
               gcc g++ gfortran \
               make autoconf automake libtool \
               git curl wget which tar gzip bzip2 xz-utils \
               python3 \
               libxml2 \
    && mkdir -p /container \
    && echo "# Common Configs" > /container/config_env.sh \
    && echo "export PATH=${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && ln -s /container/config_env.sh /etc/profile.d/z00-build-env.sh \
    && chmod a+rx /usr/bin/docker-clean \
    && cat /etc/*-release \
    && docker-clean
ENV PKG_INSTALL_CMD="apt-get install -y"
SHELL ["/bin/bash", "--login", "-c"]



################################################################################
# Part 2: Compilers and other toolkits
################################################################################

#-------------------------------------------------------------------------------
# GCC compilers stage (from base OS)
FROM ${BASE_OS} AS os-gcc
RUN echo "Selecting base OS gcc compilers" \
    && echo -e "\n# GCC compilers libraries (base OS)" >> /container/config_env.sh \
    && echo "gcc_CC=$(which gcc) && CC=\${gcc_CC}" >> /container/config_env.sh \
    && echo "gcc_CXX=$(which g++) && CXX=\${gcc_CXX}" >> /container/config_env.sh \
    && echo "gcc_F77=$(which gfortran) && F77=\${gcc_F77}" >> /container/config_env.sh \
    && echo "gcc_FC=$(which gfortran) && FC=\${gcc_FC}" >> /container/config_env.sh \
    && docker-clean



#-------------------------------------------------------------------------------
# GCC compilers stage
# Note, if installing CUDA, use a supported GCC!:
#   https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#host-compiler-support-policy
FROM ${COMPILERS_PREREQ} AS gcc
#-------------------------------------------------------------------------------
ARG GCC_VERSION="13.2.0"
RUN echo "Building gcc-${GCC_VERSION}" \
    && env \
    && GCC_INSTALL_PATH="/container/gcc/${GCC_VERSION}" \
    && cd /tmp && curl -sSL https://ftpmirror.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.xz | tar Jx \
    && cd ./gcc-${GCC_VERSION} \
    && mkdir -p /container/logs/ \
    && ./configure --help \
    && ./contrib/download_prerequisites \
    && mkdir /tmp/gcc-build && cd /tmp/gcc-build \
    && (/tmp/gcc-${GCC_VERSION}/configure \
                 --prefix=${GCC_INSTALL_PATH} \
                 --disable-static --enable-shared \
                 --enable-languages=c,c++,fortran \
                 --disable-multilib \
                 --disable-bootstrap | tee /container/logs/gcc-configure.log \
            || cat config.log) \
    && make --no-print-directory --jobs 6 V=0 | tee /container/logs/gcc-build.log \
    && make --no-print-directory install-strip | tee /container/logs/gcc-install.log \
    && echo -e "\n# GCC compilers" >> /container/config_env.sh \
    && echo "export GCC_VERSION=${GCC_VERSION}" >> /container/config_env.sh \
    && echo "export PATH=/container/gcc/${GCC_VERSION}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export LD_LIBRARY_PATH=/container/gcc/${GCC_VERSION}/lib64:\${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "${GCC_INSTALL_PATH}/lib" >> /etc/ld.so.conf.d/gcc-${GCC_VERSION}.conf \
    && echo "${GCC_INSTALL_PATH}/lib64" >> /etc/ld.so.conf.d/gcc-${GCC_VERSION}.conf \
    && ldconfig --verbose \
    && source /container/config_env.sh \
    && echo "gcc_CC=$(which gcc) && CC=\${gcc_CC}" >> /container/config_env.sh \
    && echo "gcc_CXX=$(which g++) && CXX=\${gcc_CXX}" >> /container/config_env.sh \
    && echo "gcc_F77=$(which gfortran) && F77=\${gcc_F77}" >> /container/config_env.sh \
    && echo "gcc_FC=$(which gfortran) && FC=\${gcc_FC}" >> /container/config_env.sh \
    && docker-clean



#-------------------------------------------------------------------------------
# Intel OneAPI stage
FROM ${COMPILERS_PREREQ} AS oneapi
#-------------------------------------------------------------------------------
# https://github.com/spack/spack/blob/develop/var/spack/repos/builtin/packages/intel-oneapi-compilers/package.py
# Intel compilers do not -rpath their own libraries, relying instead on LD_LIBRARY_PATH
# We'd rather not need that, so add to the system search path
#ARG ONEAPI_VERSION="2023.2.4"
#ARG ONEAPI_CC_URL="https://registrationcenter-download.intel.com/akdlm/IRC_NAS/b00a4b0e-bd21-41fa-ab34-19e8e2a77c5a/l_dpcpp-cpp-compiler_p_2023.2.4.24_offline.sh"
#ARG ONEAPI_FC_URL="https://registrationcenter-download.intel.com/akdlm/IRC_NAS/5bfaa204-689d-4bf1-9656-e37e35ea3fc2/l_fortran-compiler_p_2023.2.4.31_offline.sh"
ARG ONEAPI_VERSION="2024.2.1"
ARG ONEAPI_CC_URL="https://registrationcenter-download.intel.com/akdlm/IRC_NAS/74587994-3c83-48fd-b963-b707521a63f4/l_dpcpp-cpp-compiler_p_2024.2.1.79_offline.sh"
ARG ONEAPI_FC_URL="https://registrationcenter-download.intel.com/akdlm/IRC_NAS/5e7b0f1c-6f25-4cc8-94d7-3a527e596739/l_fortran-compiler_p_2024.2.1.80_offline.sh"
RUN echo "Installing Intel-OneAPI" \
    && ONEAPI_INSTALL_PATH="/container/intel-oneapi" \
    && mkdir -p /tmp/intel_installers && cd /tmp/intel_installers \
    && curl -O ${ONEAPI_CC_URL} \
    && curl -O ${ONEAPI_FC_URL} \
    && chmod +x l_*compiler*.sh \
    && ./l_dpcpp-*.sh -a -s --eula accept --install-dir ${ONEAPI_INSTALL_PATH} --ignore-errors \
    && ./l_fortran-*.sh -a -s --eula accept --install-dir ${ONEAPI_INSTALL_PATH} --ignore-errors \
    && cd ${ONEAPI_INSTALL_PATH} \
    && rm_paths="mpi debugger tbb conda_channel compiler/*/linux/lib/oclfpga /opt/intel" \
    && echo "Removing extra bloat: ${rm_paths}" > README.whered_stuff_go && cat README.whered_stuff_go \
    && rm -rf ${rm_paths} /tmp/intel_installers /var/intel \
    && echo -e "\n# Intel OneAPI compilers" >> /container/config_env.sh \
    && echo "source ${ONEAPI_INSTALL_PATH}/setvars.sh >/dev/null 2>&1" >> /container/config_env.sh \
    && source /container/config_env.sh \
    && echo "oneapi_CC=$(which icx) && CC=\${oneapi_CC}" >> /container/config_env.sh \
    && echo "oneapi_CXX=$(which icpx) && CXX=\${oneapi_CXX}" >> /container/config_env.sh \
    && echo "oneapi_F77=$(which ifx) && F77=\${oneapi_F77}" >> /container/config_env.sh \
    && echo "oneapi_FC=$(which ifx) && FC=\${oneapi_FC}" >> /container/config_env.sh \
    && echo ${LD_LIBRARY_PATH} | tr ':' '\n' | grep ${ONEAPI_INSTALL_PATH} >> /etc/ld.so.conf.d/intel-oneapi.conf \
    && ldconfig --verbose \
    && docker-clean


#-------------------------------------------------------------------------------
# NVHPC stage
FROM ${COMPILERS_PREREQ} AS nvhpc
#-------------------------------------------------------------------------------
#ARG NVHPC_VERSION="24.5"
#ARG NVHPC_URL="https://developer.download.nvidia.com/hpc-sdk/24.5/nvhpc_2024_245_Linux_x86_64_cuda_12.4.tar.gz"
ARG NVHPC_VERSION="24.9"
ARG NVHPC_URL="https://developer.download.nvidia.com/hpc-sdk/24.9/nvhpc_2024_249_Linux_x86_64_cuda_12.6.tar.gz"
RUN echo "Installing NVida HPC Toolkit ${NVHPC_VERSION}" \
    && cd /tmp \
    && curl -sSL ${NVHPC_URL} | tar zx \
    && export NVHPC_SILENT="true" \
    && export NVHPC_INSTALL_DIR="/container/nvhpc" \
    && export NVHPC_INSTALL_TYPE="single" \
    && ./nvhpc_*/install \
    && echo -e "\n# NVHPC version ${NVHPC_VERSION}" >> /container/config_env.sh \
    && echo "export NVARCH=$(uname -s)_$(uname -m)" >> /container/config_env.sh \
    && echo "export NVCOMPILERS=${NVHPC_INSTALL_DIR}" >> /container/config_env.sh \
    && echo "export MANPATH=\${MANPATH}:\${NVCOMPILERS}/\${NVARCH}/${NVHPC_VERSION}/compilers/man" >> /container/config_env.sh \
    && echo "export PATH=\${NVCOMPILERS}/\${NVARCH}/${NVHPC_VERSION}/compilers/bin:\$PATH" >> /container/config_env.sh \
    && cd ${NVHPC_INSTALL_DIR}/$(uname -s)_$(uname -m)/${NVHPC_VERSION} \
    && rm_paths="profilers" \
    && echo "Removing extra bloat: ${rm_paths}" > README.whered_stuff_go && cat README.whered_stuff_go \
    && rm -rf ${rm_paths} \
    && echo "${NVHPC_INSTALL_DIR}/$(uname -s)_$(uname -m)/${NVHPC_VERSION}/compilers/lib" >> /etc/ld.so.conf.d/nvhpc.conf \
    && ldconfig --verbose \
    && source /container/config_env.sh \
    && echo "nvhpc_CC=$(which nvc) && CC=\${nvhpc_CC}" >> /container/config_env.sh \
    && echo "nvhpc_CXX=$(which nvc++) && CXX=\${nvhpc_CXX}" >> /container/config_env.sh \
    && echo "nvhpc_F77=$(which nvfortran) && F77=\${nvhpc_F77}" >> /container/config_env.sh \
    && echo "nvhpc_FC=$(which nvfortran) && FC=\${nvhpc_FC}" >> /container/config_env.sh \
    && docker-clean
# rm_paths="comm_libs cuda math_libs profilers" \


#-------------------------------------------------------------------------------
FROM ${COMPILER_FAMILY} AS compilers
RUN echo "Settiing ${COMPILER_FAMILY} compiler layer"
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
# Cuda stages
FROM ${CUDA_PREREQ} AS cuda
#-------------------------------------------------------------------------------
ARG CUDA_VERSION="12.6"
ARG CUDA_INSTALLER_URL="https://developer.download.nvidia.com/compute/cuda/12.6.2/local_installers/cuda_12.6.2_560.35.03_linux.run"
ARG CUDA_HOME="/container/cuda/${CUDA_VERSION}"
ENV CUDA_HOME="${CUDA_HOME}"
RUN echo "Cuda - runfile installer" \
    && cd /tmp \
    && env \
    && mkdir -p ${CUDA_HOME} \
    && curl -O ${CUDA_INSTALLER_URL} \
    && bash ./cuda_*_linux.run \
            --silent \
            --toolkit \
            --toolkitpath=${CUDA_HOME} \
            --no-man-page \
    && cd ${CUDA_HOME} \
    && rm_paths="nsight-*/ extras/ bin/nsys* bin/nsight* libnvvp/" \
    && echo "Removing extra bloat: ${rm_paths}" > README.whered_stuff_go && cat README.whered_stuff_go \
    && rm -rf ${rm_paths} \
    && find -name "*_static.a" | xargs rm -f \
    && echo -e "\n# CUDA ${CUDA_VERSION}" >> /container/config_env.sh \
    && echo "export CUDA_HOME=${CUDA_HOME}" >> /container/config_env.sh \
    && echo "export PATH=${CUDA_HOME}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${CUDA_HOME}/include:\${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${CUDA_HOME}/lib64:${CUDA_HOME}/targets/$(uname -m)-linux/lib/stubs:\${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "#export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${CUDA_HOME}/targets/$(uname -m)-linux/lib/stubs:\${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "$(find /container/cuda -type d -name stubs)" >> /etc/ld.so.conf.d/cuda*.conf \
    && ldconfig --verbose \
    && docker-clean
ARG TOGGLE_WITH_CUDA="--with-cuda=${CUDA_HOME}"



#-------------------------------------------------------------------------------
# ROCm stages
FROM ${ROCM_PREREQ} AS rocm
#-------------------------------------------------------------------------------
ARG ROCM_VERSION="6.2.3"
ARG ROCM_HOME="/opt/rocm-${ROCM_VERSION}"
ENV ROCM_HOME="${ROCM_HOME}"
RUN echo "Rocm - amdgpu-install installer (https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/amdgpu-install.html)" \
    && source /etc/os-release \
    && cd /tmp \
    && env \
    && mkdir -p ${ROCM_HOME:-/container/rocm} \
    && case "|${PLATFORM_ID}|${VERSION_CODENAME}|${ID}|" in \
        *"platform:el8"*) \
            ${PKG_INSTALL_CMD} https://repo.radeon.com/amdgpu/6.2.3/el/8.10/main/x86_64/amdgpu-install-6.2.60203-2044426.el8.noarch.rpm \
            ;; \
        *"platform:el9"*) \
            ${PKG_INSTALL_CMD} https://repo.radeon.com/amdgpu/6.2.3/el/9.4/main/x86_64/amdgpu-install-6.2.60203-2044426.el9.noarch.rpm \
            ;; \
        *"leap"*) \
            echo -e "gpgcheck = off\nrepo_gpgcheck = off\npkg_gpgcheck = off" >> /etc/zypp/zypp.conf \
            && zypper --gpg-auto-import-keys --no-gpg-checks --non-interactive install https://repo.radeon.com/amdgpu/6.2.3/sle/15.6/main/x86_64/amdgpu-install-6.2.60203-2044426.noarch.rpm \
            && zypper --gpg-auto-import-keys --no-gpg-checks --non-interactive update \
            ;; \
        *"noble"*) \
            curl -O https://repo.radeon.com/amdgpu-install/6.2.3/ubuntu/noble/amdgpu-install_6.2.60203-1_all.deb \
            && ${PKG_INSTALL_CMD} ./amdgpu-install*.deb \
            ;; \
        *) \
            exit 1 \
            ;; \
       esac \
    && amdgpu-install --help \
    && amdgpu-install --list-usecase \
    && amdgpu-install -y --usecase=rocmdevtools,hiplibsdk --no-dkms --accept-eula --dryrun \
    && amdgpu-install -y --usecase=rocmdevtools,hiplibsdk --no-dkms --accept-eula \
    && echo -e "\n# ROCM ${ROCM_VERSION}" >> /container/config_env.sh \
    && echo "export ROCM_VERSION=${ROCM_VERSION}" >> /container/config_env.sh \
    && echo "export PATH=${ROCM_HOME}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${ROCM_HOME}/include:\${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${ROCM_HOME}/lib:\${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "#export LD_LIBRARY_PATH=${ROCM_HOME}/lib:\${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "${ROCM_HOME}/lib" >> /etc/ld.so.conf.d/rocm-${ROCM_VERSION}.conf \
    && ldconfig --verbose \
    && docker-clean
ARG TOGGLE_WITH_ROCM="--with-rocm=${ROCM_HOME} --with-hip=${ROCM_HOME}"


#-------------------------------------------------------------------------------
# miniconda stage
FROM ${MINICONDA_PREREQ} AS miniconda
#-------------------------------------------------------------------------------
RUN mkdir -p /container/miniconda3 \
    && env \
    && miniconda_ARCH="$(uname -m)" \
    && cd /tmp && curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${miniconda_ARCH}.sh \
    && bash ./Miniconda3-latest-Linux-${miniconda_ARCH}.sh -b -u -p /container/miniconda3 \
    && ln -sf /container/miniconda3/etc/profile.d/conda.sh /container/init-conda.sh \
    && echo -e "\n# Miniconda" >> /container/config_env.sh \
    && echo "source /container/miniconda3/etc/profile.d/conda.sh" >> /container/config_env.sh \
    && source /container/init-conda.sh \
    && conda --version \
    && docker-clean



################################################################################
# Part 3: MPIs
################################################################################

#-------------------------------------------------------------------------------
# MPICH variants
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# MPICH
FROM ${MPI_PREREQ} AS mpich
#-------------------------------------------------------------------------------
ARG MPICH_VERSION="4.2.3"
#ARG MPICH_DEVICE="ch4:ofi,ucx"
ARG MPICH_DEVICE="ch4:ucx"
RUN echo "building MPICH-${MPICH_VERSION}" \
    && env \
    && echo "Installing additional dependencies" \
    && (${PKG_INSTALL_CMD} glibc-devel file pkgconf \
            || ${PKG_INSTALL_CMD} libc-dev linux-libc-dev libc6-dev file pkg-config \
            || false) \
    && MPICH_INSTALL_PATH="/container/mpich/${MPICH_VERSION}" \
    && cd /tmp && curl -sSL https://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz | tar xz \
    && cd ./mpich-${MPICH_VERSION} \
    && mkdir -p /container/logs/ \
    && ./configure --help \
    && (./configure \
           --prefix=${MPICH_INSTALL_PATH} \
           --enable-threads=multiple \
           --with-device=${MPICH_DEVICE} \
           --enable-silent-rules \
           --disable-static --enable-shared \
           --disable-cxx \
           ${TOGGLE_WITH_CUDA} \
           ${TOGGLE_WITH_ROCM} \
           --disable-dependency-tracking | tee /container/logs/mpich-configure.log \
            || cat config.log) \
    && make --no-print-directory --jobs 6 V=0 | tee /container/logs/mpich-build.log \
    && make --no-print-directory install-strip | tee /container/logs/mpich-install.log \
    && echo -e "\n# MPICH ${MPICH_VERSION}" >> /container/config_env.sh \
    && echo "export MPICH_VERSION=${MPICH_VERSION}" >> /container/config_env.sh \
    && echo "export PATH=${MPICH_INSTALL_PATH}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "#export LD_LIBRARY_PATH=${MPICH_INSTALL_PATH}/lib:\${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "${MPICH_INSTALL_PATH}/lib" >> /etc/ld.so.conf.d/mpich-${MPICH_VERSION}.conf \
    && ldconfig --verbose \
    && docker-clean



#-------------------------------------------------------------------------------
# OpenMPI variants
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# OpenMPI
FROM ${MPI_PREREQ} AS openmpi
#-------------------------------------------------------------------------------
ARG OPENMPI_VERSION="5.0.6"
ENV OPENMPI_VERSION="${OPENMPI_VERSION}"
RUN echo "building OpenMPI-${OPENMPI_VERSION}" \
    && echo "Installing additional compression libraries for OpenMPI" \
    && (${PKG_INSTALL_CMD} zlib-devel libzstd-devel xz-devel bzip2-devel lz4-devel \
            || ${PKG_INSTALL_CMD} zlib-devel libzstd-devel xz-devel libbz2-devel liblz4-devel \
            || ${PKG_INSTALL_CMD} zlib1g-dev libzstd-dev liblzma-dev libbz2-dev liblz4-dev \
            || false) \
    && env \
    && OPENMPI_INSTALL_PATH="/container/openmpi/${OPENMPI_VERSION}" \
    && cd /tmp && curl -sSL https://download.open-mpi.org/release/open-mpi/v$(echo ${OPENMPI_VERSION} | cut -d . -f -2)/openmpi-${OPENMPI_VERSION}.tar.bz2 | tar xj \
    && cd ./openmpi-${OPENMPI_VERSION} \
    && mkdir -p /container/logs/ \
    && ./configure --help \
    && (./configure \
           --prefix=${OPENMPI_INSTALL_PATH} \
           ${TOGGLE_WITH_CUDA} \
           ${TOGGLE_WITH_ROCM} \
           --disable-static --enable-shared \
           --disable-dependency-tracking | tee /container/logs/openmpi-configure.log \
            || cat config.log) \
    && make --no-print-directory --jobs 6 V=0 | tee /container/logs/openmpi-build.log \
    && make --no-print-directory install-strip | tee /container/logs/openmpi-install.log \
    && cd ${OPENMPI_INSTALL_PATH} \
    && rm_paths="share/doc/ share/man/" \
    && echo "Removing extra bloat: ${rm_paths}" > README.whered_stuff_go && cat README.whered_stuff_go \
    && rm -rf ${rm_paths} \
    && echo -e "\n# OPENMPI ${OPENMPI_VERSION}" >> /container/config_env.sh \
    && echo "export OPENMPI_VERSION=${OPENMPI_VERSION}" >> /container/config_env.sh \
    && echo "export PATH=${OPENMPI_INSTALL_PATH}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "#export LD_LIBRARY_PATH=${OPENMPI_INSTALL_PATH}/lib:\${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "${OPENMPI_INSTALL_PATH}/lib" >> /etc/ld.so.conf.d/openmpi-${OPENMPI_VERSION}.conf \
    && ldconfig --verbose \
    && source /container/config_env.sh \
    && ompi_info --all --parseable \
    && ompi_info --parsable --all | grep mpi_built_with_cuda_support:value \
    && docker-clean



#-------------------------------------------------------------------------------
FROM ${MPI_FAMILY} AS mpi
RUN echo "Settiing ${MPI_FAMILY} MPI layer"
ARG TOGGLE_ENABLE_PARALLEL="--enable-parallel"
ENV CC="mpicc"
ENV CXX="mpicxx"
ENV F77="mpif77"
ENV FC="mpifort"
#-------------------------------------------------------------------------------



################################################################################
# Part 4: Libraries (that may or may not require MPI).
################################################################################

#-------------------------------------------------------------------------------
# HDF5 & NetCDF
FROM ${IOLIBS_PREREQ} AS iolibs
#-------------------------------------------------------------------------------
ARG SZIP_VERSION="2.1.1"
ARG BLOSC_VERSION="1.21.5"
ARG HDF5_VERSION="1.14.5"
ARG NETCDF_C_VERSION="4.9.2"
ARG NETCDF_FORTRAN_VERSION="4.6.1"
RUN echo "building IO libraries" \
    && echo "Installing additional compression libraries" \
    && (${PKG_INSTALL_CMD} zlib-devel libzstd-devel xz-devel bzip2-devel lz4-devel cmake \
            || ${PKG_INSTALL_CMD} zlib-devel libzstd-devel xz-devel libbz2-devel liblz4-devel cmake \
            || ${PKG_INSTALL_CMD} zlib1g-dev libzstd-dev liblzma-dev libbz2-dev liblz4-dev cmake \
            || false) \
    && echo "building libszip=${SZIP_VERSION}" \
    && env \
    && SZIP_INSTALL_PATH="/container/szip/${SZIP_VERSION}" \
    && cd /tmp && curl -sSL https://support.hdfgroup.org/ftp/lib-external/szip/${SZIP_VERSION}/src/szip-${SZIP_VERSION}.tar.gz | tar zx \
    && cd ./szip-${SZIP_VERSION} \
    && ./configure --help \
    && (./configure \
            --prefix=${SZIP_INSTALL_PATH} \
            --disable-static --enable-shared \
            --disable-dependency-tracking \
            || cat config.log) \
    && make --no-print-directory --jobs 6 V=0 \
    && make --no-print-directory install-strip \
    && echo "#include <stddef.h>" >> ${SZIP_INSTALL_PATH}/include/ricehdf.h \
    && echo -e "\n# SZIP ${SZIP_VERSION}" >> /container/config_env.sh \
    && echo "export SZIP_VERSION=${SZIP_VERSION}" >> /container/config_env.sh \
    && echo "export PATH=${SZIP_INSTALL_PATH}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${SZIP_INSTALL_PATH}/include:\${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${SZIP_INSTALL_PATH}/lib:\${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "#export LD_LIBRARY_PATH=${SZIP_INSTALL_PATH}/lib:\${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "${SZIP_INSTALL_PATH}/lib" >> /etc/ld.so.conf.d/szip.conf \
    && ldconfig --verbose \
    && source /container/config_env.sh \
    && echo "building libblosc=${BLOSC_VERSION}" \
    && env \
    && BLOSC_INSTALL_PATH="/container/c-blosc/${BLOSC_VERSION}" \
    && cd /tmp && curl -sSL https://github.com/Blosc/c-blosc/archive/v${BLOSC_VERSION}.tar.gz | tar zx \
    && cd ./c-blosc-${BLOSC_VERSION} \
    && cmake \
           -DCMAKE_INSTALL_PREFIX=${BLOSC_INSTALL_PATH} \
           -DCMAKE_INSTALL_DO_STRIP=1 \
           -DPREFER_EXTERNAL_ZLIB=ON \
           -DPREFER_EXTERNAL_ZSTD=ON \
           -DPREFER_EXTERNAL_LZ4=ON \
    && make --no-print-directory --jobs 6 V=0 \
    && make --no-print-directory install \
    && echo -e "\n# BLOSC ${BLOSC_VERSION}" >> /container/config_env.sh \
    && echo "export BLOSC_VERSION=${BLOSC_VERSION}" >> /container/config_env.sh \
    && echo "export PATH=${BLOSC_INSTALL_PATH}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${BLOSC_INSTALL_PATH}/include:\${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${BLOSC_INSTALL_PATH}/lib64:\${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "#export LD_LIBRARY_PATH=${BLOSC_INSTALL_PATH}/lib64:\${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "${BLOSC_INSTALL_PATH}/lib64" >> /etc/ld.so.conf.d/blosc.conf \
    && ldconfig --verbose \
    && source /container/config_env.sh \
    && echo "building HDF5-${HDF5_VERSION}" \
    && env \
    && HDF5_INSTALL_PATH="/container/hdf5/${HDF5_VERSION}" \
    && cd /tmp && curl -sSL https://github.com/HDFGroup/hdf5/releases/download/hdf5_${HDF5_VERSION}/hdf5-${HDF5_VERSION}.tar.gz | tar zx \
    && cd ./hdf5-${HDF5_VERSION} \
    && ./configure --help \
    && (./configure \
            --prefix=${HDF5_INSTALL_PATH} \
            --disable-static --enable-shared \
            --with-default-plugindir \
            --enable-fortran \
            --disable-cxx \
            --enable-hl \
            ${TOGGLE_ENABLE_PARALLEL} \
            --disable-dependency-tracking \
            || cat config.log) \
    && make --no-print-directory --jobs 6 V=0 \
    && make --no-print-directory install-strip \
    && make --silent --no-print-directory installcheck \
    && echo -e "\n# HDF5 ${HDF5_VERSION}" >> /container/config_env.sh \
    && echo "export HDF5_VERSION=${HDF5_VERSION}" >> /container/config_env.sh \
    && echo "export PATH=${HDF5_INSTALL_PATH}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${HDF5_INSTALL_PATH}/include:\${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${HDF5_INSTALL_PATH}/lib:\${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "#export LD_LIBRARY_PATH=${HDF5_INSTALL_PATH}/lib:\${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "${HDF5_INSTALL_PATH}/lib" >> /etc/ld.so.conf.d/hdf5.conf \
    && ldconfig --verbose \
    && source /container/config_env.sh \
    && echo "Installing additional NetCDF dependencies" \
    && (${PKG_INSTALL_CMD} libxml2-devel curl-devel \
            || ${PKG_INSTALL_CMD} libxml2-dev libcurl4-openssl-dev \
            || false) \
    && echo "building NETCDF-${NETCDF_C_VERSION}" \
    && NETCDF_INSTALL_PATH="/container/netcdf" \
    && HDF5_PLUGIN_PATH="${NETCDF_INSTALL_PATH}/lib/plugins" \
    && cd /tmp \
    && curl -sSL https://github.com/Unidata/netcdf-c/archive/v${NETCDF_C_VERSION}.tar.gz | tar zx \
    && curl -sSL https://github.com/Unidata/netcdf-fortran/archive/v${NETCDF_FORTRAN_VERSION}.tar.gz | tar zx \
    && cd /tmp/netcdf-c-${NETCDF_C_VERSION} \
    && ./configure --help \
    && (./configure \
            --prefix=${NETCDF_INSTALL_PATH} \
            --disable-static --enable-shared \
            --enable-plugins \
            --with-plugin-dir=${HDF5_PLUGIN_PATH} \
            --disable-dependency-tracking \
            || cat config.log) \
    && make --no-print-directory --jobs 6 V=0 \
    && make --no-print-directory install-strip \
    && make --silent --no-print-directory installcheck \
    && echo -e "\n# NETCDF libraries" >> /container/config_env.sh \
    && echo "export NETCDF_C_VERSION=${NETCDF_C_VERSION}" >> /container/config_env.sh \
    && echo "export NETCDF_FORTRAN_VERSION=${NETCDF_FORTRAN_VERSION}" >> /container/config_env.sh \
    && echo "export PATH=${NETCDF_INSTALL_PATH}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${NETCDF_INSTALL_PATH}/include:\${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${NETCDF_INSTALL_PATH}/lib:${HDF5_PLUGIN_PATH}\${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "export HDF5_PLUGIN_PATH=${HDF5_PLUGIN_PATH}" >> /container/config_env.sh \
    && echo "#export LD_LIBRARY_PATH=${NETCDF_INSTALL_PATH}/lib:\${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "${NETCDF_INSTALL_PATH}/lib" >> /etc/ld.so.conf.d/netcdf.conf \
    && echo "${HDF5_PLUGIN_PATH}" >> /etc/ld.so.conf.d/netcdf.conf \
    && ldconfig --verbose \
    && source /container/config_env.sh \
    && cd /tmp/netcdf-fortran-${NETCDF_FORTRAN_VERSION} \
    && ./configure --help \
    && (./configure \
            --prefix=${NETCDF_INSTALL_PATH} \
            --disable-static --enable-shared \
            --enable-zstandard-plugin \
            --disable-dependency-tracking \
            || cat config.log) \
    && make --no-print-directory --jobs 6 V=0 \
    && make --no-print-directory install-strip \
    && make --silent --no-print-directory --jobs 6 V=0 check \
    && make --silent --no-print-directory installcheck \
    && ldconfig --verbose \
    && (h5pcc -showconfig || h5cc -showconfig) \
    && (nc-config --all && nf-config --all) \
    && docker-clean



################################################################################
# Final Image
################################################################################
FROM ${FINAL_TARGET} AS final
# archive this Dockerfile in the image
ADD extras/Dockerfile.* /container/
RUN echo "Final configuration:" \
    && export FINAL_TARGET=${FINAL_TARGET} \
    && echo -e "\n# (build target ${FINAL_TARGET} completed at $(date))" >> /container/config_env.sh \
    && 2>/dev/null du -hs /container/*/ /*/ | grep -v "K" | sort \
    && cat /container/config_env.sh

# Local Variables:
# mode: sh
# End:
