# term
echo 'export TERM=xterm-256color' >> /root/.bashrc
echo 'export PATH=/usr/share/bcc/tools/:$PATH' >> /root/.bashrc
echo 'export PATH=/root/local/FlameGraph/:$PATH' >> /root/.bashrc

# dir
mkdir -p /root/local

# patched perf tool
apt-get update
apt-get install -y flex bison glibc-source libelf-dev libdw-dev libunwind-dev libnewt-dev libgtk2.0-dev binutils-dev libnuma-dev libbabeltrace-ctf-dev libperl-dev python2-dev libiberty-dev zlib1g-dev libzstd-dev libbabeltrace-dev

cd /root/local
wget -c 'https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.15.tar.gz'
tar -xzf linux-5.15.tar.gz
cd /root/local/linux-5.15/tools/perf
wget -c 'https://eighty-twenty.org/files/0001-tools-perf-Use-long-running-addr2line-per-dso.patch'
patch -u -b util/srcline.c -i ./0001-tools-perf-Use-long-running-addr2line-per-dso.patch

make -j
make install
cp /root/local/linux-5.15/tools/perf/perf /usr/bin/perf

# bcc
cd /root/local
git clone https://github.com/iovisor/bcc.git --recursive
apt install -y zip bison build-essential cmake flex git libedit-dev \
    libllvm14 llvm-14-dev libclang-14-dev python3 zlib1g-dev libelf-dev libfl-dev python3-setuptools \
    liblzma-dev libdebuginfod-dev arping netperf iperf python-is-python3
mkdir /root/local/bcc/build; cd /root/local/bcc/build
cmake ..
make -j
make install
cmake -DPYTHON_CMD=python3 .. # build python3 binding
pushd src/python/
make -j
make install
popd

# Flamegraph
cd /root/local
git clone https://github.com/brendangregg/FlameGraph.git

# other tools
apt-get install -y kmod linux-headers-5.15.0-91-generic sysstat lsb-release wget software-properties-common gnupg google-perftools libgoogle-perftools-dev strace

# debug info
echo "deb http://ddebs.ubuntu.com $(lsb_release -cs) main restricted universe multiverse" >> /etc/apt/sources.list.d/ddebs.list
echo "deb http://ddebs.ubuntu.com $(lsb_release -cs)-updates main restricted universe multiverse" >> /etc/apt/sources.list.d/ddebs.list
echo "deb http://ddebs.ubuntu.com $(lsb_release -cs)-proposed main restricted universe multiverse" >> /etc/apt/sources.list.d/ddebs.list
apt install -y ubuntu-dbgsym-keyring
apt update
apt-get install -y libatomic1-dbgsym libboost-atomic1.74.0-dbgsym \
        libboost-chrono1.74.0-dbgsym libboost-context1.74.0-dbgsym \
        libboost-date-time1.74.0-dbgsym libboost-filesystem1.74.0-dbgsym \
        libboost-program-options1.74.0-dbgsym libboost-python1.74.0-dbgsym \
        libboost-regex1.74.0-dbgsym libboost-system1.74.0-dbgsym \
        libboost-thread1.74.0-dbgsym libbz2-1.0-dbgsym libc6-dbg
apt-get install -y libdouble-conversion3-dbgsym libdwarf1-dbgsym libelf1-dbgsym \
        libevent-2.1-7-dbgsym libevent-core-2.1-7-dbgsym \
        libevent-openssl-2.1-7-dbgsym libgcc-s1-dbgsym libgflags2.2-dbgsym
apt-get install -y libgmp10-dbgsym libgoogle-glog0v5-dbgsym libgsasl7-dbgsym \
        libidn12-dbgsym libkeyutils1-dbgsym libkrb5-dbg liblz4-1-dbgsym \
        liblzma5-dbgsym libntlm0-dbgsym librdkafka++1-dbgsym librdkafka1-dbgsym \
        libsnappy1v5-dbgsym libsodium23-dbgsym libssl3-dbgsym \
        libstatgrab10-dbgsym libstdc++6-dbgsym libtinfo6-dbgsym \
        libunwind8-dbgsym libzookeeper-mt2-dbgsym libzstd1-dbgsym
