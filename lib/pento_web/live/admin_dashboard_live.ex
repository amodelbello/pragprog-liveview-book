defmodule PentoWeb.AdminDashboardLive do
  use PentoWeb, :live_view
  alias PentoWeb.SurveyResultsLive

  # TODO: PubSub stuff
  alias PentoWeb.Endpoint
  @survey_results_topic "survey_results"

  def mount(_params, _session, socket) do
    # TODO: PubSub stuff
    if connected?(socket) do
      Endpoint.subscribe(@survey_results_topic)
    end

    {:ok,
     socket
     |> assign(:survey_results_component_id, "survey-results")}
  end

  # TODO: PubSub stuff
  def handle_info(%{event: "rating_created"}, socket) do
    send_update(
      SurveyResultsLive,
      id: socket.assigns.survey_results_component_id
    )

    {:noreply, socket}
  end
end
