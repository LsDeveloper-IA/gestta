FROM node:22.11.0-alpine AS builder

WORKDIR /app

COPY package.json package-lock.json ./

RUN pnpm install

COPY . .

RUN pnpm run build

RUN pnpm prune --production

FROM node:22.11.0-alpine

WORKDIR /app

COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public

EXPOSE 3030

CMD ["pnpm", "start"]