defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
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
        time: time()
      )
    }
  end

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
        <%=  # live_patch "Play Again", to: Routes.live_path(@socket, WrongLive) %>
      <% end %>
    </h2>
    """
  end
end
