defmodule ElixirPaswordGenerator do
  @moduledoc """
  Generates random password depending on parameters, Module main function is "generate(opts)"
  generate/1 takes a option map.

  Options Example:
      options = %{
        "length" => "5",
        "numbers" => "false",
        "uppercase" => "false",
        "symbols" => "false"
      }

  There are only 4 options "length", "numbers", "uppercase", "symbols"
  """


  @alowed_options [ :length, :numbers, :uppercase, :symbols]

  @doc """
  Generates password for given options:

  ##Example:
        options = %{
         "length" => "5",
        "numbers" => "false",
        "symbols" => "false",
        "uppercase" => "false"
        }

        iex> ElixirPaswordGenerator.generate(options)
        "asd1g"
  """
  # @spec generate(options :: map()) ::{:ok, bitstring()} | {:error, bitstring()}
  def generate(options) do
    length = Map.has_key?(options, "length")
    validate_length(length, options)
  end









  defp validate_length(false, _opts), do: {:error, "Please provide a length of the password"}
  defp validate_length(true, options) do
    numbers = Enum.map(0..9, & Integer.to_string(&1))
    length = options["length"]
    length = String.contains?(length, numbers)
    validate_length_is_integer(length, options)
  end

  defp validate_length_is_integer(false, _opts), do: {:error, "The lenth of the password has to be an integer"}
  defp validate_length_is_integer(true, options) do
    length = options["length"] |> String.trim() |> String.to_integer()

    options_without_length = Map.delete(options, "length")
    opts_values = Map.values(options_without_length)
    value =
      opts_values
      |> Enum.all?(fn val -> String.to_atom(val)|> is_boolean() end)
    validate_options_values_are_bools(value, length, options_without_length)
  end

  defp validate_options_values_are_bools(false, _length, _bool_opts), do: {:error, "Only boolean values alowed"}
  defp validate_options_values_are_bools(true, length, options) do
    options = included_options(options)
    # invalid_options? = Enum.any?(options not in @alowed_options)
    invalid_options? = options |> Enum.any?(&(&1 not in @alowed_options))
    validate_options(invalid_options?, length, options)
  end

  defp validate_options(true, _length, _opts), do: {:error, "Only optins alowed are numbers, uppercase and symbols"}
  defp validate_options(false, length, bool_opts) do
    generate_strings(length, bool_opts)
  end

  defp generate_strings(length, options) do
    options = [:lowecase_letter | options]
    included = include(options)
    length = length - length(included)
    random_strings = gen_random_strings(length, options)
    strings = included ++ random_strings
    get_result(strings)
  end

  defp get_result(str) do
    string = Enum.shuffle(str) |> to_string()
    {:ok, string}
  end

  defp include(options) do
    options
    |> Enum.map(&get(&1))
  end

  defp get(:lowecase_letter) do
    <<Enum.random(?a..?z)>>
  end

  defp get(:uppercase) do
    <<Enum.random(?A..?Z)>>
  end

  defp get(:numbers) do
    Enum.random(1..9) |> Integer.to_string()
  end

  defp gen_random_strings(length, bool_opts) do
    Enum.map(1..length, fn _ ->Enum.random(bool_opts) |> get() end)
  end

  defp included_options(bool_opts) do
    Enum.filter(bool_opts, fn {_key, value} ->
      String.trim(value) |> String.to_existing_atom()
    end)
    |> Enum.map(fn {key, _value} -> String.to_atom(key) end)
  end



end
