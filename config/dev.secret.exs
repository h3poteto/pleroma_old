use Mix.Config

config :pleroma, Pleroma.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "pleroma",
  password: "pleroma",
  database: "pleroma_dev",
  hostname: "db",
  pool_size: 10

config :pleroma, Pleroma.Web.Endpoint,
  pubsub: [name: Pleroma.PubSub, adapter: Phoenix.PubSub.Redis, host: "redis", node_name: "redis"]

config :pleroma, :instance,
  name: "Pleroma.io",
  email: "h3.poteto@gmail.com",
  limit: 5000,
  registrations_open: true,
  dedupe_media: false

config :pleroma, :chat,
  enabled: false

config :pleroma, :fe,
  scope_options_enabled: true

config :web_push_encryption, :vapid_details,
  subject: "mailto:h3.poteto@gmail.com",
  public_key: "BErcKUl_hNiqq3HhLbLzgjFzeuiLXqFPz2Q8EPAI1YEp9qCOjswXPDEHzIp--RRdhX1FdNrX3fATuEjYAALtpxQ",
  private_key: "-_4ZKfgc0Ztx9KBMbrOaOTqp8tYsbIDA2okjBH6gza4"
