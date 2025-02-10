# defmodule AuthyWeb.API.AuthController do
#   use AuthyWeb, :controller
#   alias Authy.Accounts

#   def login(conn, %{"email" => email, "password" => password}) do
#     with {:ok, _user, token} <- Accounts.authenticate_api_user(email, password) do
#       json(conn, %{token: token})
#     else
#       _-> json(conn, %{error: "Invalid credentials", status: 401})
#     end
#   end


#   def me(conn, _params) do
#     case Authy.Auth.Token.verify(get_auth_token(conn)) do
#       {:ok, user_id} ->
#         case Accounts.get_user!(user_id) do
#           %User{} = user -> json(conn, %{email: user.email, id: user.id})
#           _-> json(conn, %{error: "unauthorized"}, 401)
#         end
#     _-> json(conn, %{error: "Unauthorized"}, 401)
#   end
# end

# def get_auth_token(conn) do
#   case get_req_header(conn, "authorization ") do
#     ["Bearer " <> token] -> token
#     _-> nil
#       end
#   end
# end
