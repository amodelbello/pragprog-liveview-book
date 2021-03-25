defmodule PentoWeb.DemographicLive.FormComponent do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Demographic

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_demographic()
     |> assign_changeset()}
  end

  @impl true
  def handle_event("save", %{"demographic" => demographic_params}, socket) do
    IO.puts("Handling 'save' event and saving demographic record...")
    IO.inspect(demographic_params)

    {:noreply,
     socket
     |> save_demographic(demographic_params)}
  end

  defp save_demographic(socket, demographic_params) do
    case Survey.create_demographic(demographic_params) do
      {:ok, demographic} ->
        send(self(), {:created_demographic, demographic})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, changeset: changeset)
    end
  end

  defp assign_demographic(%{assigns: %{user: user}} = socket) do
    assign(socket, :demographic, %Demographic{user_id: user.id})
  end

  defp assign_changeset(%{assigns: %{demographic: demographic}} = socket) do
    assign(socket, :changeset, Survey.change_demographic(demographic))
  end
end
