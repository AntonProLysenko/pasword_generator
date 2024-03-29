defmodule ElixirPaswordGeneratorTest do
  use ExUnit.Case
  # doctest ElixirPaswordGenerator if This line included test runs examples from module doc

  # test "greets the world" do
  #   assert ElixirPaswordGenerator.hello() == :world
  # end

  setup do
    options = %{
        "length" => "5",
        "numbers" => "false",
        "symbols" => "false",
        "uppercase" => "false"
      }

    options_type = %{
      lowercase: Enum.map(?a.. ?z, & <<&1>>),
      numbers: Enum.map(0..9, & Integer.to_string(&1)),
      uppercase: Enum.map(?A..?Z, & <<&1>>),
      symbols: String.split("!#$%&()*+,-./:;<=>?@[]^_{|}~", "", trim: true)
    }

    {:ok, return} = ElixirPaswordGenerator.generate(options)


    %{
      options_type: options_type,
      result: return
    }

  end

  test "returns a string", %{result: return} do
    assert is_bitstring(return)
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
    refute String.contains?(result, options.numbers)
    refute String.contains?(result, options.uppercase)
    refute String.contains?(result, options.symbols)
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


  test "returns str with uppercase", %{options_type: options} do
    opts_with_uppercase = %{
      "length" => "5",
      "numbers" => "false",
      "symbols" => "false",
      "uppercase" => "true"
    }

    {:ok, result} = ElixirPaswordGenerator.generate(opts_with_uppercase)

    assert String.contains?(result, options.uppercase)

    refute String.contains?(result, options.numbers)
    refute String.contains?(result, options.symbols)
  end



  test "returns str with numbers", %{options_type: options} do
    opts_with_numbers = %{
      "length" => "5",
      "numbers" => "true",
      "symbols" => "false",
      "uppercase" => "false"
    }

    {:ok, result} = ElixirPaswordGenerator.generate(opts_with_numbers)

    assert String.contains?(result, options.numbers)

    refute String.contains?(result, options.uppercase)
    refute String.contains?(result, options.symbols)
  end



  test "returns str with numbers and uppercase", %{options_type: options} do
    opts_with_numbers_uppercase = %{
      "length" => "5",
      "numbers" => "true",
      "symbols" => "false",
      "uppercase" => "true"
    }

    {:ok, result} = ElixirPaswordGenerator.generate(opts_with_numbers_uppercase)

    assert String.contains?(result, options.numbers)
    assert String.contains?(result, options.uppercase)

    refute String.contains?(result, options.symbols)
  end






  test "returns str with symbols", %{options_type: options} do
    opts_with_symbols = %{
      "length" => "5",
      "numbers" => "false",
      "symbols" => "true",
      "uppercase" => "false"
    }

    {:ok, result} = ElixirPaswordGenerator.generate(opts_with_symbols)

    assert String.contains?(result, options.symbols)

    refute String.contains?(result, options.uppercase)
    refute String.contains?(result, options.numbers)
  end


  test "returns str with all opts", %{options_type: options} do
    all_opts = %{
      "length" => "5",
      "numbers" => "true",
      "symbols" => "true",
      "uppercase" => "true"
    }

    {:ok, result} = ElixirPaswordGenerator.generate(all_opts)

    assert String.contains?(result, options.symbols)
    assert String.contains?(result, options.uppercase)
    assert String.contains?(result, options.numbers)
  end



  test "returns str with symbols and uppercase opts", %{options_type: options} do
    opts_with_symbols_uppercase = %{
      "length" => "5",
      "numbers" => "false",
      "symbols" => "true",
      "uppercase" => "true"
    }

    {:ok, result} = ElixirPaswordGenerator.generate(opts_with_symbols_uppercase)

    assert String.contains?(result, options.symbols)
    assert String.contains?(result, options.uppercase)
    refute String.contains?(result, options.numbers)
  end


  test "returns str with symbols and numbers opts", %{options_type: options} do
    opts_with_symbols_uppercase = %{
      "length" => "5",
      "numbers" => "true",
      "symbols" => "true",
      "uppercase" => "false"
    }

    {:ok, result} = ElixirPaswordGenerator.generate(opts_with_symbols_uppercase)

    assert String.contains?(result, options.symbols)
    refute String.contains?(result, options.uppercase)
    assert String.contains?(result, options.numbers)
  end


end
