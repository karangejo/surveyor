defmodule SurveyorWeb.VoteController do
  use SurveyorWeb, :controller

  alias Surveyor.Surveys

  def index(conn, %{"survey_name" => survey_name}) do
    conn
    |> assign(:survey, Surveys.get_survey_by_name!(survey_name))
    |> render( "index.html")
  end

  def cast_vote(conn, %{"choose_option" => %{"options" => choosen_option},"survey_name" => survey_name}) do
    survey = Surveys.get_survey_by_name!(survey_name)
    Surveys.cast_vote(survey, choosen_option)
    conn
    |> assign(:survey, survey)
    |> render( "index.html")
  end
end
