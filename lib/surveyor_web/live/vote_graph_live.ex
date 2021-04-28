defmodule SurveyorWeb.VoteGraphLive do
  use SurveyorWeb, :live_view

  alias Surveyor.Surveys

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign(socket, :session, session)}
  end

  @impl true
  def handle_params(%{"survey_name" => survey_name}, _, socket) do
    case show_chart?(socket.assigns.session, survey_name) do
      true ->
        survey = Surveys.get_survey_by_name!(survey_name)
        {:noreply,
           socket
           |> push_event("chart-data", %{label: survey.name ,data: survey.options})
           |> assign(:survey, survey)}
      false ->
        {:noreply, redirect(socket, to: Routes.home_page_path(socket, :index))}
    end
  end

  def show_chart?(session, survey_name) do
    case has_voting_session?(session) do
      false ->
        false
      true ->
        voted_on_survey?(session, survey_name)
    end
  end

  def has_voting_session?(session) do
    Map.has_key?(session, "voting_session")
  end

  def voted_on_survey?(%{"voting_session" => voting_session}, survey_name) do
    Map.has_key?(voting_session, survey_name)
  end

end
