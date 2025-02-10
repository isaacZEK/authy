# defmodule Authy.Auth.Token do
#   use Joken.Config

#   @secret_key "super_secret_key"

#   def generate(user) do
#     claims = %{
#       "sub" => user.id,
#       "exp" => DateTime.utc_now()
#               |> DateTime.add(24 * 3600, :second)
#               |> DateTime.to_unix()
#     }
#     Joken.generate_and_sign(claims, @secret_key)
#   end


#   def verify(token) do
#     case Joken.verify_and_validate(token, @secret_key) do
#       {:ok, claims} -> {:ok, claims["sub"]}
#       {:error, reason} -> {:error, "Invalid token: #{reason}"}
#        _ -> {:error, "Unexpected token format"}
#     end
#   end
# end
