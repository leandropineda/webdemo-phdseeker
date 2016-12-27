FROM ubuntu:14.04
MAINTAINER Leandro Pineda <leandropineda.lp@gmail.com>

# Web Demo Builder - Base Docker image for Python 2.x

ENV python_env="/python_env"
#ENV http_proxy="http://192.168.0.120:3128"

# Install base packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      pkg-config \
      gfortran \
      libatlas-base-dev \
      libatlas3gf-base \
      fonts-lyx \
      libfreetype6-dev \
      libpng-dev \
      python2.7 \
      python-dev \
      python-pip \
      python-tk \
      tk-dev \
      libyaml-dev \
      imagemagick && \
    rm -rf /var/lib/apt/lists/*


# python packages
RUN pip install -U virtualenv==12.0.7
RUN virtualenv ${python_env}

COPY install_python_module /usr/local/bin/
RUN install_python_module pip==6.0.8
RUN install_python_module numpy==1.9.2
RUN install_python_module scipy==0.15.1
RUN install_python_module scikit-learn==0.15.2
RUN install_python_module matplotlib==1.4.3
RUN install_python_module pandas==0.15.2
RUN install_python_module seaborn==0.5.1
RUN install_python_module sympy==0.7.6
RUN install_python_module biopython==1.65
RUN install_python_module pyrapidjson==0.4.1
RUN install_python_module networkx==1.11
RUN install_python_module cvxopt==1.1.8
RUN install_python_module pyyaml==3.12

RUN ln -s ${python_env}/bin/python /usr/local/bin/python

# Create a new user "developer".
# It will get access to the X11 session in the host computer

ENV uid=1000
ENV gid=${uid}

COPY init.sh /
COPY create_user.sh /
COPY matplotlibrc_tkagg /
COPY matplotlibrc_agg /

ENTRYPOINT ["/init.sh"]
CMD ["/create_user.sh"]
