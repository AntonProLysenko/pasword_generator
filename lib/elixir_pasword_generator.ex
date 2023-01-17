defmodule ElixirPaswordGenerator do
  @moduledoc """
  Generates random password depending on parameters, Module main function is "generate(opts)"
  generate/1 takes a option map.

  Options Example:
      options = %{
        "length" => "5",
        "numbers" => "false",
        "uppercase" => "0",
        "symbols" => "false"
      }

  There are only 4 options "length", "numbers", "uppercase", "symbols"
  """


  @alowed_options [ :length, :numbers, :uppercase, :symbols]

end
