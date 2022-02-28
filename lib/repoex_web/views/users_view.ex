defmodule RepoexWeb.UsersView do
  use RepoexWeb, :view

  alias Repoex.User

  def render("user.json", %{user: %User{} = user}), do: user
end
