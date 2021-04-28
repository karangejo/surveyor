defmodule SurveyorWeb.VoteController do
  use SurveyorWeb, :controller

  alias Surveyor.Surveys

  def index(conn, %{"survey_name" => survey_name}) do
    {voted, conn} = voted_on_survey?(conn, survey_name)

    conn
    |> assign(:voted, voted)
    |> assign(:survey, Surveys.get_survey_by_name!(survey_name))
    |> render( "index.html")
  end

  def cast_vote(conn, %{"choose_option" => %{"options" => choosen_option},"survey_name" => survey_name}) do
    # vote for survey in Database
    survey = Surveys.get_survey_by_name!(survey_name)
    Surveys.cast_vote(survey, choosen_option)

    conn
    |> vote_for(survey_name, choosen_option)
    |> put_flash(:info, "Thanks for voting!")
    |> redirect(to: Routes.vote_graph_path(conn, :index, survey_name))
    |> halt()
  end

  def voted_on_survey?(conn, survey_name) do
    case has_voting_session(conn) do
      true ->
       case voted?(conn, survey_name) do
        true ->
          {true, conn
            |> put_flash(:error, "You already voted in this survey!")
            |> redirect(to: Routes.vote_graph_path(conn, :index, survey_name))
            |> halt()}
        false ->
          {false, conn}
       end
      false ->
        {false, conn}
    end
  end

  def vote_for(conn, survey_name, option) do
    case has_voting_session(conn) do
      true ->
        # get voting session object and add to it
        voting_session = get_session(conn, :voting_session)
        put_session(conn, :voting_session, Map.put(voting_session, survey_name, option))
      false ->
        # create a voting session object with current vote
        put_session(conn, :voting_session, %{survey_name => option})
    end
  end

  def has_voting_session(conn) do
    case get_session(conn, :voting_session) do
      nil ->
        false
      _ ->
        true
    end
  end

  def voted?(conn, survey_name) do
    case get_session(conn, :voting_session) do
      nil ->
        false
      voting_session ->
        case Map.has_key?(voting_session, survey_name) do
          true ->
            true
          false ->
            false
        end
    end
  end

end
