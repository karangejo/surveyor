# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Surveyor.Repo.insert!(%Surveyor.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
Surveyor.Surveys.create_survey_no_user(%{
  name: "Favorite Food",
  question: "What is your favorite food?",
  options: %{"pizza" => 13, "pasta" => 10, "chicken" => 5, "vegetables" => 8}})

Surveyor.Surveys.create_survey_no_user(%{
  name: "Favorite Sport",
  question: "What sport do you like?",
  options: %{"Surfing" => 20, "Skateboarding" => 10, "Soccer" => 23, "Basketball" => 4}})
