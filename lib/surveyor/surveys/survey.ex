defmodule Surveyor.Surveys.Survey do
  use Ecto.Schema
  import Ecto.Changeset

  alias Surveyor.Accounts.User

  schema "surveys" do
    field :name, :string
    field :options, {:map, :integer}
    field :question, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(survey, attrs) do
    survey
    |> cast(attrs, [:name, :question, :options])
    |> validate_required([:name, :question, :options])
  end
end
