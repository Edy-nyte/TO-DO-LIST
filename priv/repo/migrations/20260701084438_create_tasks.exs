defmodule TodoList.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string, null: false
      add :description, :text
      add :status, :string, default: "active"

      timestamps(type: :utc_datetime)
    end
  end
end