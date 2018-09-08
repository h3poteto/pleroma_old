defmodule Pleroma.KeysTest do
  use Pleroma.DataCase
  alias Pleroma.Keys

  test "it generates private keys" do
    {:ok, pem} = Keys.generate_rsa_pem()

    assert pem =~ "RSA PRIVATE KEY"
  end

  test "it gives private and public key pems for a private key pem" do
    {:ok, pem} = Keys.generate_rsa_pem()
    {:ok, private, public} = Keys.pems_from_pem(pem)

    assert private =~ "RSA PRIVATE KEY"
    assert public =~ "RSA PUBLIC KEY"
  end

  test "returns a public and private key from a pem" do
    pem = File.read!("test/fixtures/private_key.pem")
    {:ok, private, public} = Keys.keys_from_pem(pem)

    assert elem(private, 0) == :RSAPrivateKey
    assert elem(public, 0) == :RSAPublicKey
  end
end
