FROM node:16-buster
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --only=prod
COPY . .
EXPOSE 3000
ENV PORT=3000
CMD ["npm", "start"]
