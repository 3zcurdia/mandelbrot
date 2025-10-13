defmodule Mandelbrot do
  @moduledoc """
  Mandelbrot set generator
  """
  import Bitwise

  def row(y, row_size) do
    ci = 2.0 * y / row_size - 1.0

    build_row(0, ci, 0, 0, [], row_size)
    |> Enum.reverse()
    |> IO.iodata_to_binary()
  end

  defp build_row(x, _ci, _byte_acc, _bit_num, acc, row_size) when x == row_size, do: acc

  defp build_row(x, ci, byte_acc, bit_num, acc, row_size) do
    cr = 2.0 * x / row_size - 1.5
    escape = mandelbrot_escape(cr, ci, 0.0, 0.0, 0.0, 0.0, 0)

    byte_acc = byte_acc <<< 1 ||| escape
    bit_num = bit_num + 1

    cond do
      bit_num == 8 ->
        build_row(x + 1, ci, 0, 0, [<<byte_acc>> | acc], row_size)

      x == row_size - 1 ->
        byte_acc = byte_acc <<< (8 - bit_num)
        build_row(x + 1, ci, 0, 0, [<<byte_acc>> | acc], row_size)

      true ->
        build_row(x + 1, ci, byte_acc, bit_num, acc, row_size)
    end
  end

  defp mandelbrot_escape(_cr, _ci, _zr, _zi, _zrzr, _zizi, 50), do: 1

  defp mandelbrot_escape(cr, ci, zr, zi, zrzr, zizi, iter) do
    if zrzr + zizi > 4.0 do
      0
    else
      tr = zrzr - zizi + cr
      ti = 2.0 * zr * zi + ci
      zr = tr
      zi = ti
      zrzr = zr * zr
      zizi = zi * zi
      mandelbrot_escape(cr, ci, zr, zi, zrzr, zizi, iter + 1)
    end
  end
end
