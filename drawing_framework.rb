#!/usr/bin/env ruby

require 'RMagick'

name = "example_1.png"

pic_size = 350

P = [[0, 0], [30, 0], [30, 30], [0, 30]]
H = [[8, 10], [22, 10], [22, 14], [8, 14]]

gc = Magick::Draw.new
canvas = Magick::Image.new(pic_size, pic_size)

gc.affine(1, 0, 0, -1, 0, pic_size)
gc.translate(25, 25)
gc.scale(10, 10)

P.each_index do |i|
  gc.line(P[i-1][0], P[i-1][1], P[i][0], P[i][1])
end

H.each_index do |i|
  gc.line(H[i-1][0], H[i-1][1], H[i][0], H[i][1])
end

gc.rectangle(10, 0, 20, -5)

gc.draw(canvas)
canvas.write(name)