defmodule Pleroma.Web.ActivityPub.Actor do
  alias Pleroma.Keys

  def build(base) do
    {:ok, pem} = Keys.generate_rsa_pem()
    {:ok, privkey, pubkey} = Keys.pems_from_pem(pem)

    {:ok,
     %{
       "id" => base,
       "inbox" => "#{base}/inbox",
       "outbox" => "#{base}/outbox",
       "following" => "#{base}/following",
       "followers" => "#{base}/followers",
       "privateKey" => %{
         "privateKeyPem" => privkey
       },
       "publicKey" => %{
         "publicKeyPem" => pubkey
       }
     }}
  end
end
