FROM node:6.14.4

COPY ./pacman_source_code /opt/pacman_source_code
WORKDIR /opt/pacman_source_code
RUN npm install
ENTRYPOINT [ "npm", "start" ]
