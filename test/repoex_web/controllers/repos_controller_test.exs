defmodule RepoexWeb.ReposControllerTest do
  use RepoexWeb.ConnCase, async: true
  import Mox

  alias Repoex.{Error, GetReposMock, Repository}

  describe "index/1" do
    test "when the user exists, return their repositories", %{conn: conn} do
      user = "RomuloHe4rt"

      body = [
        %Repository{
          id: 386_716_157,
          name: "25sites25days",
          html_url: "https://github.com/RomuloHe4rt/25sites25days",
          description: "Desenvolvendo um site por dia durante 25 dias",
          stargazers_count: 3
        },
        %Repository{
          id: 455_920_643,
          name: "exmeal",
          html_url: "https://github.com/RomuloHe4rt/exmeal",
          description: nil,
          stargazers_count: 0
        }
      ]

      expect(GetReposMock, :call, fn _repos -> {:ok, body} end)

      response =
        conn
        |> get(Routes.repos_path(conn, :index, user))
        |> json_response(:ok)

      expected_response = [
        %{
          "description" => "Desenvolvendo um site por dia durante 25 dias",
          "html_url" => "https://github.com/RomuloHe4rt/25sites25days",
          "id" => 386_716_157,
          "name" => "25sites25days",
          "stargazers_count" => 3
        },
        %{
          "description" => nil,
          "html_url" => "https://github.com/RomuloHe4rt/exmeal",
          "id" => 455_920_643,
          "name" => "exmeal",
          "stargazers_count" => 0
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
