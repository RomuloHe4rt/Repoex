defmodule Repoex do
  defdelegate get_repos(user),
    to: Application.fetch_env!(:repoex, __MODULE__)[:get_repos_adapter],
    as: :call
end
