defmodule Pleroma.Keys do
  # Native generation of RSA keys is only available since OTP 20+ and in default build conditions
  # We try at compile time to generate natively an RSA key otherwise we fallback on the old way.
  try do
    _ = :public_key.generate_key({:rsa, 2048, 65537})

    def generate_rsa_pem do
      key = :public_key.generate_key({:rsa, 2048, 65537})
      entry = :public_key.pem_entry_encode(:RSAPrivateKey, key)
      pem = :public_key.pem_encode([entry]) |> String.trim_trailing()
      {:ok, pem}
    end
  rescue
    _ ->
      def generate_rsa_pem do
        port = Port.open({:spawn, "openssl genrsa"}, [:binary])

        {:ok, pem} =
          receive do
            {^port, {:data, pem}} -> {:ok, pem}
          end

        Port.close(port)

        if Regex.match?(~r/RSA PRIVATE KEY/, pem) do
          {:ok, pem}
        else
          :error
        end
      end
  end

  def keys_from_pem(pem) do
    [private_key_code] = :public_key.pem_decode(pem)
    private_key = :public_key.pem_entry_decode(private_key_code)
    {:RSAPrivateKey, _, modulus, exponent, _, _, _, _, _, _, _} = private_key
    public_key = {:RSAPublicKey, modulus, exponent}
    {:ok, private_key, public_key}
  end

  def pems_from_pem(pem) do
    {:ok, _, public_key} = keys_from_pem(pem)
    public_key = :public_key.pem_entry_encode(:RSAPublicKey, public_key)
    pubkey_pem = :public_key.pem_encode([public_key])

    {:ok, pem, pubkey_pem}
  end
end
