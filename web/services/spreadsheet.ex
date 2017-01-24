defmodule Excelmerger.Spreadsheets do

  def to_map([ header|rows ]) do
    Enum.map(rows, fn(row) ->
      Enum.zip(header, row)
      |> Enum.into(%{})
    end)
  end

  def transform_header([ header|rows ], new_header) do
    [ new_header | rows]
  end

  def filter_data(data, acceptable) do
    Enum.map(data, fn (row) ->
      Map.take(row, acceptable)
    end)
  end

  def add_timestamps(data) do
    {:ok, time} = Ecto.DateTime.cast(DateTime.utc_now())

    Enum.map(data, fn(row) ->
      Map.merge(row, %{
        inserted_at: time,
        updated_at: time
      })
    end)
  end



end
