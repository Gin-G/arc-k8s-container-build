#!/usr/bin/env bash

set -e

#docker system prune --all --force

# override default make variables
export version="nwsc4"

export DOCKER_BUILD_ARCH="--platform linux/amd64"
unset DOCKER_BUILD_ARGS



build_image ()
{
    export label
    export DOCKER_BUILD_ARGS
    make echo
    #docker system prune --force
    docker system df
    rm -f .buildstamp && make -n image && make image && make -n run
    mkdir -p launch/
    make -n run > launch/${label}.sh
    chmod +x launch/${label}.sh
}



#--------------------------------------------------------------------------------
for base_os in almalinux9; do # almalinux{8,9} leap noble; do

    #--------------------------------------------------------------------------------
    DOCKER_BUILD_ARGS="--build-arg BASE_OS=${base_os} --build-arg FINAL_TARGET=${base_os}"
    export label="${base_os}"
    build_image

    #--------------------------------------------------------------------------------
    DOCKER_BUILD_ARGS="--build-arg BASE_OS=${base_os} --build-arg FINAL_TARGET=miniconda"
    export label="${base_os}-conda"
    build_image

    #--------------------------------------------------------------------------------
    for compiler_family in oneapi gcc; do

        #--------------------------------------------------------------------------------
        DOCKER_BUILD_ARGS="--build-arg BASE_OS=${base_os} --build-arg COMPILER_FAMILY=${compiler_family} --build-arg FINAL_TARGET=compilers"
        export label="${base_os}-${compiler_family}"
        build_image

        #--------------------------------------------------------------------------------
        DOCKER_BUILD_ARGS="--build-arg BASE_OS=${base_os} --build-arg COMPILER_FAMILY=${compiler_family} --build-arg FINAL_TARGET=cuda"
        export label="${base_os}-${compiler_family}-cuda"
        build_image

        #--------------------------------------------------------------------------------
        DOCKER_BUILD_ARGS="--build-arg BASE_OS=${base_os} --build-arg COMPILER_FAMILY=${compiler_family} --build-arg FINAL_TARGET=rocm"
        export label="${base_os}-${compiler_family}-rocm"
        build_image

        for mpi_family in openmpi mpich; do

            #continue

            #--------------------------------------------------------------------------------
            export label="${base_os}-${compiler_family}-${mpi_family}"
            DOCKER_BUILD_ARGS="--build-arg BASE_OS=${base_os} --build-arg COMPILER_FAMILY=${compiler_family} --build-arg MPI_FAMILY=${mpi_family} --build-arg FINAL_TARGET=mpi"
            build_image

            #--------------------------------------------------------------------------------
            export label="${base_os}-${compiler_family}-${mpi_family}-cuda"
            DOCKER_BUILD_ARGS="--build-arg BASE_OS=${base_os} --build-arg COMPILER_FAMILY=${compiler_family} --build-arg MPI_FAMILY=${mpi_family} --build-arg FINAL_TARGET=mpi --build-arg MPI_PREREQ=cuda"
            build_image

            #--------------------------------------------------------------------------------
            export label="${base_os}-${compiler_family}-${mpi_family}-rocm"
            DOCKER_BUILD_ARGS="--build-arg BASE_OS=${base_os} --build-arg COMPILER_FAMILY=${compiler_family} --build-arg MPI_FAMILY=${mpi_family} --build-arg FINAL_TARGET=mpi --build-arg MPI_PREREQ=rocm"
            build_image
        done
    done
done
