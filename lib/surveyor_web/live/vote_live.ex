defmodule SurveyorWeb.VoteLive do
  use SurveyorWeb, :live_view

  alias Surveyor.Surveys

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"survey_name" => survey_name}, _, socket) do
    {:noreply,
     socket
     |> assign(:survey, Surveys.get_survey_by_name!(survey_name))}
  end

  @impl true
  def handle_event("vote", %{"choose_option" => %{"options" => choosen_option}}, socket) do
    # cast vote into database
    Surveys.cast_vote(socket.assigns.survey, choosen_option)
    # cast vote into session
    # live view cannot handle session
    # I will change this page to regular view and handle the graph with a liveview

    {:noreply,
      socket}
  end
end
