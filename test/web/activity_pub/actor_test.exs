defmodule Pleroma.Web.ActivityPub.ActorTest do
  use Pleroma.DataCase
  alias Pleroma.Web.ActivityPub.Actor

  test "it builds and actor, including keys and inbox, outbox, followers" do
    {:ok, user} = Actor.build("http://example.org/users/lain")

    assert user["id"] == "http://example.org/users/lain"
    assert user["inbox"] == "http://example.org/users/lain/inbox"
    assert user["outbox"] == "http://example.org/users/lain/outbox"
    assert user["following"] == "http://example.org/users/lain/following"
    assert user["followers"] == "http://example.org/users/lain/followers"
    assert user["privateKey"]["privateKeyPem"] =~ "RSA PRIVATE KEY"
    assert user["publicKey"]["publicKeyPem"] =~ "RSA PUBLIC KEY"
  end
end
