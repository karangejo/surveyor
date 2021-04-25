defmodule Surveyor.Repo.Migrations.CreateSurveys do
  use Ecto.Migration

  def change do
    create table(:surveys) do
      add :name, :string
      add :question, :string
      add :options, {:map, :integer}
      add :user_id, references(:users)

      timestamps()
    end

  end
end
