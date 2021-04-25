defmodule SurveyorWeb.SurveyLive.Index do
  use SurveyorWeb, :live_view

  alias Surveyor.Surveys
  alias Surveyor.Surveys.Survey
  alias Surveyor.Accounts

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)
    {:ok,
      socket
      |> assign(:user_id, user.id)
      |> assign(:surveys, list_surveys(user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Survey")
    |> assign(:survey, Surveys.get_survey!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Survey")
    |> assign(:survey, %Survey{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Surveys")
    |> assign(:survey, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    survey = Surveys.get_survey!(id)
    {:ok, _} = Surveys.delete_survey(survey)

    {:noreply, assign(socket, :surveys, list_surveys(socket.assigns.user_id))}
  end

  defp list_surveys(user_id) do
    Surveys.list_surveys_by_user_id(user_id)
  end
end
