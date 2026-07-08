defmodule TodoListWeb.TaskLive.Index do
  use TodoListWeb, :live_view

  alias TodoList.Todo

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:tasks, Todo.list_tasks())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="container">
        <h1>My To-Do List</h1>

        <form phx-submit="add_task" class="todo-input">
          <input
            type="text"
            name="task"
            placeholder="Enter a new task..."
            autocomplete="off"
          />

          <button type="submit">
            Add
          </button>
        </form>

        <%= if Enum.empty?(@tasks) do %>
          <p>No tasks yet. Add your first task!</p>
        <% else %>
          <%= for task <- @tasks do %>
            <div class="task">
              <span><%= task.title %></span>

              <button
                phx-click="delete_task"
                phx-value-id={task.id}
              >
                🗑 Delete
              </button>
            </div>
          <% end %>
        <% end %>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def handle_event("add_task", %{"task" => title}, socket) do
    title = String.trim(title)

    if title != "" do
      Todo.create_task(%{
        title: title,
        description: "",
        status: "active"
      })
    end

    {:noreply,
     assign(socket, :tasks, Todo.list_tasks())}
  end

  @impl true
  def handle_event("delete_task", %{"id" => id}, socket) do
    task = Todo.get_task!(id)

    {:ok, _task} = Todo.delete_task(task)

    {:noreply,
     assign(socket, :tasks, Todo.list_tasks())}
  end
end