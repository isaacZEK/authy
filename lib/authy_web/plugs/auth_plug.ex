# defmodule AuthyWeb.Plugs.AuthyPlug do
#     import Plug.Conn
#     alias Authy.Auth.Token
#     alias Authy.Accounts
#     alias Authy.Accounts.User

#     use AuthyWeb, :controller

#     def init(opts), do: opts

#     def call(conn, _opts) do
#       case get_auth_token(conn) |> Token.verify() do
#         {:ok, user_id} ->
#           case Accounts.get_user!(user_id) do
#             %User{} = user -> assign(conn, :current_user, user)
#             _-> unauthorized_response(conn)
#           end

#         _-> unauthorized_response(conn)
#       end
#     end

#   def get_auth_token(conn) do
#     case get_req_header(conn, "authorization") do
#       ["Bearer " <> token] -> token
#       _-> nil
#     end
#   end

#     def unauthorized_response(conn) do
#       conn
#       |> put_status(401)
#       |> json(%{error: "Unauthorized"})
#       |> halt()
#     end
# end
