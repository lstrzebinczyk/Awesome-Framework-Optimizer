#!/usr/bin/env ruby

module LolStiffMatrix
  def stiff_matrix_from(framework)
    stiff_matrix = Array.new(self.size){|i| []}

    framework.lines.each do |line|
      insert_line(stiff_matrix, line, framework.stiff)
    end

    apply_boundaries(stiff_matrix, framework.points)

    stiff_matrix
  end

  def apply_boundaries(matrix, points)
    bounds = []
    points.each do |point|
      bounds << point.id*2 if point.block_x
      bounds << point.id*2 +1 if point.block_y
    end

    bounds.each do |num|
      matrix[num] = [[num, 1]]
    end

    matrix.each_with_index do |row, i|
      unless bounds.include?(i)
        row.delete_if { |pair| bounds.include?(pair[0]) or pair[1].abs < 0.0001}
      end
    end

    #TODO Poprawić
    matrix.delete_if{|elem| elem == []}
  end

  def add_to_line(line, position, value)
    added = false

    line.each do |val|
      if val[0] == position
        val[1] += value
        added = true
        break
      elsif val[0] > position
        break
      end
    end

    if added == false
      line << [position, value]
      added = true
    end

    line.sort!
  end

  #lol- list of lists (matrix of FEM coeffs)
  def insert_line(lol, line, stiff)
    length = line.length
    k = stiff / length
    cos = (line.p1.x - line.p2.x)/length
    sin = (line.p1.y - line.p2.y)/length

    x1 = line.p1.id * 2
    x2 = line.p1.id * 2 + 1
    x3 = line.p2.id * 2
    x4 = line.p2.id * 2 + 1

    add_to_line(lol[x1], x1,  k * cos * cos)
    add_to_line(lol[x1], x2,  k * cos * sin)
    add_to_line(lol[x1], x3, -k * cos * cos)
    add_to_line(lol[x1], x4, -k * cos * sin)
    add_to_line(lol[x2], x1,  k * cos * sin)
    add_to_line(lol[x2], x2,  k * sin * sin)
    add_to_line(lol[x2], x3, -k * cos * sin)
    add_to_line(lol[x2], x4, -k * sin * sin)
    add_to_line(lol[x3], x1, -k * cos * cos)
    add_to_line(lol[x3], x2, -k * cos * sin)
    add_to_line(lol[x3], x3,  k * cos * cos)
    add_to_line(lol[x3], x4,  k * cos * sin)
    add_to_line(lol[x4], x1, -k * cos * sin)
    add_to_line(lol[x4], x2, -k * sin * sin)
    add_to_line(lol[x4], x3,  k * cos * sin)
    add_to_line(lol[x4], x4,  k * sin * sin)
  end

  def force_vector_from(framework)
    points = framework.points

    force_vector = []
    points.each do |pt|
      force_vector << pt.fx
      force_vector << pt.fy
    end

    force_vector
  end
end