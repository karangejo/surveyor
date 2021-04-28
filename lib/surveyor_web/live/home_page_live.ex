defmodule SurveyorWeb.HomePageLive do
  use SurveyorWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :surveys, list_surveys())}
  end

  defp list_surveys do
    Surveyor.Surveys.list_surveys()
  end
end
