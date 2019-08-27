FROM node:12.8-buster

# Set up the correct time zone and char encodings
ENV TZ=Europe/Oslo
ENV LANG C.UTF-8
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install dumb-init (Very handy for easier signal handling of SIGINT/SIGTERM/SIGKILL etc.)
RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb \
 && dpkg -i dumb-init_*.deb
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Install Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update && apt-get install -y google-chrome-stable jq && rm -rf /var/lib/apt/lists/*

# Set up home dir, workspace and environment for GCB
RUN mkdir /workspace && mkdir -p /builder/home
WORKDIR /workspace

# Install CLIs and required utilities
RUN npm install -g npm@6.10 @angular/cli@8.2 ionic cloc@latest firebase-tools smartcrop-cli pgb-cli playup

ENV HOME=/builder/home

EXPOSE 4200 9876 9222 8888 9005
CMD [ "npm", "run" ]

