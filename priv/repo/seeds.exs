# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Authy.Repo.insert!(%Authy.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Authy.Repo
alias Authy.Accounts.User
alias Pbkdf2

Repo.insert!(%User{
  email: "admin@gmail.com",
  hashed_password: Pbkdf2.hash_pwd_salt("administrator"),
  user_type: "ADMIN"
})

