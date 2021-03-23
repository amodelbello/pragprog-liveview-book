defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view
  alias Pento.Accounts

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, _, _) do
    socket
  end

  @impl true
  def mount(_params, session, socket) do
    number_of_choices = 11
    correct_number = to_string(:rand.uniform(number_of_choices))

    {
      :ok,
      assign(
        socket,
        number_of_choices: number_of_choices,
        correct_number: correct_number,
        score: 0,
        game_over: false,
        message: "Guess a number.",
        time: time(),
        user: Accounts.get_user_by_session_token(session["user_token"]),
        session_id: session["live_socket_id"]
      )
    }
  end

  @impl true
  def handle_event(
        "guess",
        %{"number" => guess} = data,
        socket
      ) do
    IO.inspect(data)
    IO.inspect(socket.assigns.correct_number)
    time = time()
    correct_number = socket.assigns.correct_number

    case guess do
      ^correct_number ->
        message = "Your guess: #{guess}. Correct! Game over. "
        score = socket.assigns.score + 10
        game_over = true

        {
          :noreply,
          assign(
            socket,
            message: message,
            game_over: game_over,
            score: score,
            time: time
          )
        }

      _ ->
        message = "Your guess: #{guess}. Wrong. Guess again. "
        score = socket.assigns.score - 1

        {
          :noreply,
          assign(
            socket,
            message: message,
            score: score,
            time: time
          )
        }
    end
  end

  def time() do
    DateTime.utc_now() |> to_string
  end

  @impl true
  def render(assigns) do
    ~L"""
    <h1>Your score: <%= @score %><h1>
    <h2>
      <%= @message %>
      <br />
      It's <%= @time %>
    </h2>
    <h2>
      <%= if @game_over != true do %>
        <%= for n <- 1..@number_of_choices do %>
          <a href="#" phx-click="guess" phx-value-number="<%= n %>">
            <%= n %>
          </a>
        <% end %>
      <% else %>
        <!-- <button>Play again</button> -->
          <%= # live_patch "Edit", to: Routes.product_index_path(@socket, :index) %>
          <%= # live_patch "Play Again", to: Routes.live_path(@socket, WrongLive, :guess) %>
      <% end %>
    </h2>
    <pre>
      <%= @user.email %>
      <%= @session_id %>
    </pre>
    """
  end
end
