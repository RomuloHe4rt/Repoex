defmodule RepoexWeb.ReposControllerTest do
  use RepoexWeb.ConnCase, async: true
  import Mox

  alias Repoex.{Error, GetReposMock, Repository}

  describe "index/1" do
    test "when the user exists, return their repositories", %{conn: conn} do
      user = "RomuloHe4rt"

      body = [
        %Repository{
          id: 277_408_587,
          name: "Readme",
          html_url: "https://github.com/RomuloHe4rt/RomuloHe4rt",
          description: nil,
          stargazers_count: 0
        },
        %Repository{
          id: 250_084_405,
          name: "Rockelivery",
          html_url: "https://github.com/RomuloHe4rt/rockelivery",
          description: "API for restaurant orders.",
          stargazers_count: 1
        }
      ]

      expect(GetReposMock, :call, fn _repos -> {:ok, body} end)

      response =
        conn
        |> get(Routes.repos_path(conn, :index, user))
        |> json_response(:ok)

      expected_response = [
        %{
          "description" => nil,
          "html_url" => "https://github.com/RomuloHe4rt/RomuloHe4rt",
          "id" => 277_408_587,
          "name" => "Readme",
          "stargazers_count" => 0
        },
        %{
          "description" => "API for restaurant orders.",
          "html_url" => "https://github.com/RomuloHe4rt/rockelivery",
          "id" => 250_084_405,
          "name" => "Rockelivery",
          "stargazers_count" => 1
        }
      ]

      assert response == expected_response
    end

    test "when the user does not exists, returns an error", %{conn: conn} do
      user = "no_existent_user_for_tests"

      body = %{
        message: "Not Found",
        documentation_url:
          "https://docs.github.com/rest/reference/repos#list-repositories-for-a-user"
      }

      expect(GetReposMock, :call, fn _repos -> {:error, Error.build(:not_found, body)} end)

      response =
        conn
        |> get(Routes.repos_path(conn, :index, user))
        |> json_response(:not_found)

      expected_response = %{
        "error" => %{
          "documentation_url" =>
            "https://docs.github.com/rest/reference/repos#list-repositories-for-a-user",
          "message" => "Not Found"
        }
      }

      assert response == expected_response
    end
  end
end
