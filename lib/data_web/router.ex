defmodule DataWeb.Router do
  use DataWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DataWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/notes", NoteController
    resources "/game_stats", GameStatController
  end

  # Other scopes may use custom stacks.
  # scope "/api", DataWeb do
  #   pipe_through :api
  # end
end
