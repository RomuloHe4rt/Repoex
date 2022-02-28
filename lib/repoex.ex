defmodule Repoex do
  alias Repoex.GetRepos

  defdelegate get_repos(user), to: GetRepos, as: :call
end
