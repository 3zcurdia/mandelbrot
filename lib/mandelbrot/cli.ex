defmodule Mandelbrot.CLI do
  @moduledoc """
  Command-line interface for the Mandelbrot set generator.
  Usage:
      mandelbrot <size> > mandel.pbm
  """

  def main([size]) do
    size
    |> String.to_integer()
    |> Mandelbrot.generate()
  end

  def main(_args) do
    IO.puts(:stderr, "Usage: mandelbrot <size>")
    System.halt(1)
  end
end
