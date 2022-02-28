defmodule Repoex.GetReposTest do
  use ExUnit.Case, async: true

  alias Plug.Conn
  alias Repoex.{Error, GetRepos, Repository}

  describe "call/1" do
    setup do
      bypass = Bypass.open()

      {:ok, bypass: bypass}
    end

    test "when there is a valid user, return their repositories", %{bypass: bypass} do
      user = "RomuloHe4rt"

      base_url = endpoint_url(bypass.port)

      body = ~s([
        {
          "id": 277408587,
          "name": "Readme",
          "html_url": "https://github.com/RomuloHe4rt/RomuloHe4rt",
          "description": null,
          "stargazers_count": 0
        },
        {
          "id": 250084405,
          "name": "Rockelivery",
          "html_url": "https://github.com/RomuloHe4rt/rockelivery",
          "description": "API for restaurant orders.

          ",
          "stargazers_count": 1
        }
      ])

      Bypass.expect(bypass, "GET", "#{user}/repos", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(200, body)
      end)

      response = GetRepos.call(base_url, user)

      assert {:ok, [%Repository{} | _]} = response
    end

    test "when the given user is unexistent, return an error", %{bypass: bypass} do
      user = "non_existent_user_for_api_test"

      base_url = endpoint_url(bypass.port)

      body = ~s({
        "message": "Not Found",
        "documentation_url": "https://docs.github.com/rest/reference/repos#list-repositories-for-a-user"
      })

      Bypass.expect(bypass, "GET", "#{user}/repos", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(:not_found, body)
      end)

      response = GetRepos.call(base_url, user)

      assert {:error, %Error{result: "User not found", status: :not_found}} = response
    end

    defp endpoint_url(port), do: "http://localhost:#{port}/"
  end
end
