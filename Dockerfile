# 1. jupyter/base-notebook 이미지를 기반으로 사용합니다.
FROM jupyter/base-notebook

ENV LISF_PATH=/usr/local/LISF
ENV LISF_SETUP=$LISF_PATH/spack/share/spack/setup-env.sh

USER root

# 2. 필요한 패키지나 라이브러리 설치
# RUN pip install pandas numpy

RUN apt update && \
    apt install -y vim libopenmpi-dev openmpi-bin build-essential ca-certificates coreutils curl environment-modules gfortran git gpg lsb-release python3 python3-distutils python3-venv unzip zip zlib1g-dev

#USER jovyan

# 3. Spack 다운로드 및 경로 설정
#RUN mkdir /home/jovyan/LISF && \
#    cd /home/jovyan/LISF && \
#    git clone -b v0.21.0 -c feature.manyFiles=true https://github.com/spack/spack.git

RUN mkdir $LISF_PATH && \
    cd $LISF_PATH && \
    git clone -b v0.21.0 -c feature.manyFiles=true https://github.com/spack/spack.git
	
# 4. Spack 설정 스크립트 경로를 .bashrc에 추가
RUN echo "source $LISF_SETUP" >> ~/.bashrc

CMD source $LISF_SETUP && jupyter lab --ip=0.0.0.0 --no-browser --NotebookApp.base_url=${NB_PREFIX} --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --allow-root