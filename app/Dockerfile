# Author: Per
# Description: Customized Kali Linux image with pre-installed tools for reconnaissance and web application security testing.

FROM kalilinux/kali-rolling:latest


########## Setup environment ##########

# Set working directory
WORKDIR /root

# Use bash as default shell for all RUN commands and for image users
SHELL ["/bin/bash", "-lc"]

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    GOPATH=/root/go \
    GOBIN=/usr/local/bin \
    GO111MODULE=on \
    PATH=/root/go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Create directory for shared data
RUN mkdir -p /root/recon

########## Install Base Packages ##########

# Update and upgrade the system
RUN apt update -y
RUN apt upgrade -y

# Install base packages and tools
RUN apt-get install -y --no-install-recommends \
    # General tools
    build-essential \
    curl \
    git \
    jq \
    nano \
    passwd \
    tmux \
    vim \
    wget \
    # Kali tools
    kali-linux-headless \
    massdns


########## OpenSSH Server ##########

# Install OpenSSH server
RUN apt-get install -y openssh-server

# Create SSH directory and set permissions
RUN mkdir -p /var/run/sshd
RUN chmod 0755 /var/run/sshd

# Allow root login and set root password (change 'toor' to a strong password)
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo "root:kaliguard" | chpasswd

# Expose SSH port and change it to a non-standard port
EXPOSE 22


########## Golang ##########

# Install Golang using packaged golang-go for easier maintenance and some helpers
RUN apt-get install -y --no-install-recommends golang-go
RUN mkdir -p /root/go
RUN mkdir -p /opt/tools
RUN chown -R root:root /opt/tools
RUN go env -w GO111MODULE=on
RUN go env -w GOPROXY=direct

# Install Golang-based tools
RUN go install -v github.com/tomnomnom/anew@latest
RUN go install -v github.com/tomnomnom/assetfinder@latest
RUN go install -v github.com/tomnomnom/httprobe@latest
RUN go install -v github.com/tomnomnom/waybackurls@latest

RUN go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
RUN go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
RUN go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

RUN go install -v github.com/ffuf/ffuf/v2@latest
RUN go install -v github.com/lc/gau/v2/cmd/gau@latest
RUN go install -v github.com/jaeles-project/gospider@latest
RUN go install -v github.com/d3mondev/puredns/v2@latest


########## Customizations ##########

# Silence the default Kali welcome message
RUN touch /root/.hushlogin

# Add banner file and display with welcome message on tmux shell startup
COPY ./configs/banner.txt /root/.motd.txt
RUN echo >> /root/.bashrc <<'RC_EOF'
GREEN=$'\e[1;32m'
RESET=$'\e[0m'

if [[ -n "$TMUX" && $- == *i* ]]; then
    # Display banner
    cat .motd.txt # NEEDS COPY

    # List network connections
    lsof -i -nP | grep -E 'LISTEN|ESTABLISHED'

    # Display connection info
    echo "[${GREEN} $(curl -s ipinfo.io/ip) ${RESET}] - $(curl -s ipinfo.io/org)"
    echo "$(curl -s ipinfo.io/city), $(curl -s ipinfo.io/region), $(curl -s ipinfo.io/country)"

    echo "Happy hacking!"
fi

# Fix tmux font rendering issues
export LANG=en_US.UTF-8

# Autostart or attach to a tmux session on shell startup, if not already in one
if [[ -z "$TMUX" ]] && [[ -n "$PS1" ]] && [[ "$(tty)" == "/dev/pts/"* ]]; then
    tmux attach || tmux
fi
RC_EOF

# Simplify the BASH prompt
RUN sed -i 's/PROMPT_ALTERNATIVE=twoline/PROMPT_ALTERNATIVE=backtrack/g' /root/.bashrc

# Customize tmux
COPY ./configs/tmux.conf /root/.tmux.conf


########## Image Optimizations ##########

# Clean up apt caches and temporary files to keep image smaller
RUN apt-get autoremove -y
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN history -c


########## Entrypoint ##########

CMD bash -c "echo 'root:$ROOT_PASSWORD' | chpasswd && /usr/sbin/sshd -D"