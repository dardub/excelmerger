defmodule Excelmerger.Utilities do
  def string_bool_to_int("true"), do: 1
  def string_bool_to_int("false"), do: 0

  def cast_string(nil), do: nil
  def cast_string(arg) when is_integer(arg), do: Integer.to_string(arg)
  def cast_string(arg), do: arg

  def cast_int(nil), do: nil
  def cast_int(arg) when is_integer(arg), do: arg
  def cast_int(arg) when is_float(arg), do: round(arg)
  def cast_int(arg) do
    {int, _} = Integer.parse arg
    int
   end
end
