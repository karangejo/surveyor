defmodule Surveyor.SurveysTest do
  use Surveyor.DataCase

  alias Surveyor.Surveys

  describe "surveys" do
    alias Surveyor.Surveys.Survey

    @valid_attrs %{name: "some name", options: [], question: "some question"}
    @update_attrs %{name: "some updated name", options: [], question: "some updated question"}
    @invalid_attrs %{name: nil, options: nil, question: nil}

    def survey_fixture(attrs \\ %{}) do
      {:ok, survey} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Surveys.create_survey()

      survey
    end

    test "list_surveys/0 returns all surveys" do
      survey = survey_fixture()
      assert Surveys.list_surveys() == [survey]
    end

    test "get_survey!/1 returns the survey with given id" do
      survey = survey_fixture()
      assert Surveys.get_survey!(survey.id) == survey
    end

    test "create_survey/1 with valid data creates a survey" do
      assert {:ok, %Survey{} = survey} = Surveys.create_survey(@valid_attrs)
      assert survey.name == "some name"
      assert survey.options == []
      assert survey.question == "some question"
    end

    test "create_survey/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Surveys.create_survey(@invalid_attrs)
    end

    test "update_survey/2 with valid data updates the survey" do
      survey = survey_fixture()
      assert {:ok, %Survey{} = survey} = Surveys.update_survey(survey, @update_attrs)
      assert survey.name == "some updated name"
      assert survey.options == []
      assert survey.question == "some updated question"
    end

    test "update_survey/2 with invalid data returns error changeset" do
      survey = survey_fixture()
      assert {:error, %Ecto.Changeset{}} = Surveys.update_survey(survey, @invalid_attrs)
      assert survey == Surveys.get_survey!(survey.id)
    end

    test "delete_survey/1 deletes the survey" do
      survey = survey_fixture()
      assert {:ok, %Survey{}} = Surveys.delete_survey(survey)
      assert_raise Ecto.NoResultsError, fn -> Surveys.get_survey!(survey.id) end
    end

    test "change_survey/1 returns a survey changeset" do
      survey = survey_fixture()
      assert %Ecto.Changeset{} = Surveys.change_survey(survey)
    end
  end
end
