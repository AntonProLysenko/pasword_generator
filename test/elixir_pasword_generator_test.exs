defmodule ElixirPaswordGeneratorTest do
  use ExUnit.Case
  doctest ElixirPaswordGenerator

  # test "greets the world" do
  #   assert ElixirPaswordGenerator.hello() == :world
  # end

  setup do
    options = %{
      "length" => "10",
      "numbers" => "false",
      "uppercase" => "false",
      "symbols" => "false"
    }

    options_type = %{
      lowercase: Enum.map(?a.. ?z, & <<&1>>),
      numbers: Enum.map(0..9, & Integer.to_string(&1)),
      uppercase: Enum.map(?A..?Z, & <<&1>>),
      symbols: String.split("!#$%&()*+,-./:;<>=@{}[]^_|~", "", trim: true)
    }
    {:ok, result} = ElixirPaswordGenerator.generate(options)


    %{
      options_type: options_type,
      result: result
    }
  end

  test "returns a string", %{result: result} do
    assert is_bitstring(result)
  end

  test "returns error when no length is given" do
    options = %{"invalid" => "false"}

    assert {:error, _error} = ElixirPaswordGenerator.generate(options)
  end

  test "return error when length is not integer" do
    options = %{"length" => "ab"}

    assert {:error, _error} = ElixirPaswordGenerator.generate(options)
  end

  test "length of returned str is the option provided" do
    length_option = %{"length" => "5"}
    {:ok, result} = ElixirPaswordGenerator.generate(length_option)

    assert  5 = String.length(result)
  end

  test "returns a lowercase str just with length", %{options_type: options} do
    length_opt = %{"length" => "5"}
    {:ok, result} = ElixirPaswordGenerator.generate(length_opt)

    assert String.contains?(result, options.lowercase)
    refunt String.contains?(result, options.numbers)
    refunt String.contains?(result, options.uppercase)
    refunt String.contains?(result, options.symbols)
  end

  test "return error when opts values are not booleans" do
    options = %{
      "length" => "10",
      "numbers" => "invalid",
      "uppercase" => "0",
      "symbols" => "false"
    }

    assert {:error, _error} = ElixirPaswordGenerator.generate(options)
  end

  test "error when opts are not alowed" do
    options = %{"length" => "5", "invalid" => "true"}

    assert {:error, _error} = ElixirPaswordGenerator.generate(options)
  end

  test "error when one opt not alowed" do
    options = %{"length" => "5","numbers" => "true", "invalid" => "true"}

    assert {:error, _error} = ElixirPaswordGenerator.generate(options)
  end
end
