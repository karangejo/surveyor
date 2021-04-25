defmodule SurveyorWeb.SurveyLive.FormComponent do
  use SurveyorWeb, :live_component

  alias Surveyor.Surveys

  @impl true
  def update(%{survey: survey} = assigns, socket) do
    changeset = Surveys.change_survey(survey)
    options = case assigns.action do
      :edit ->
        assigns.survey.options
        |> Map.keys()
      :new ->
        []
    end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:current_option, "")
     |> assign(:options, options)}
  end

  @impl true
  def handle_event("delete-option", %{"index" => index}, socket) do
    options = List.delete_at(socket.assigns.options, String.to_integer(index))
    {:noreply,
      socket
      |> assign(:options, options)}
  end

  @impl true
  def handle_event("add-current-option", _params, socket) do
    options =
      case socket.assigns.current_option do
        "" ->
         socket.assigns.options
       current_option ->
         [current_option | socket.assigns.options]
      end

    {:noreply,
      socket
      |> assign(:current_option, "")
      |> assign(:options, options)}
  end


  @impl true
  def handle_event("validate", %{"survey" => survey_params = %{"option" => current_option}}, socket) do
    changeset =
      socket.assigns.survey
      |> Surveys.change_survey(survey_params)
      |> Map.put(:action, :validate)

    {:noreply,
      socket
      |> assign(:current_option, current_option)
      |> assign(:changeset, changeset)}
  end

  def handle_event("save", %{"survey" => survey_params}, socket) do
    survey_params =
      survey_params
      |> Map.put("options",
        socket.assigns.options
        |> Enum.map(fn x -> {x, 0} end)
        |> Enum.into(%{}))
      |> Map.put("user_id", socket.assigns.user_id)
    IO.inspect(survey_params)
    save_survey(socket, socket.assigns.action, survey_params)
  end

  defp save_survey(socket, :edit, survey_params) do
    survey_params = Map.put(survey_params, "options",
      socket.assigns.options
      |> Enum.map(fn x -> {x, 0} end)
      |> Enum.into(%{})
    )

    case Surveys.update_survey(socket.assigns.survey, survey_params) do
      {:ok, _survey} ->
        {:noreply,
         socket
         |> put_flash(:info, "Survey updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_survey(socket, :new, survey_params) do
    user = Surveyor.Accounts.get_user!(survey_params["user_id"])
    case Surveys.create_survey(user, survey_params) do
      {:ok, _survey} ->
        {:noreply,
         socket
         |> put_flash(:info, "Survey created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
