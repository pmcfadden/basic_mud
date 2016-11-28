module ClasslessMud
  class Map
    def initialize(room)
      @room = room
    end

    def print_map(distance = 5)
      map = ["*"]
      add_exits(@room, map, 0, 0, distance, [])
      map.join("\n")
    end

    def add_exits(room, map, x, y, n, covered)
      return [0, 0] if n.zero?
      x_delta, y_delta = [0, 0]
      if y < 2
        map.map! do |row|
          "  #{row}"
        end
        y += 2
        y_delta = 2
      end
      if map.first.size - y < 2
        map.map! do |row|
          "#{row}  "
        end
      end
      if x < 2
        map.unshift(" " * map.first.size)
        map.unshift(" " * map.first.size)
        x += 2
        x_delta = 2
      end
      if map.size - x < 2
        map << " " * map.first.size
        map << " " * map.first.size
      end
      room.exits.each do |ex|
        next if covered.include? ex.target
        case ex.direction
        when 'west'
          map[x][y - 2] = '0'
          map[x][y - 1] = '-'
        when 'east'
          map[x][y + 1] = '-'
          map[x][y + 2] = '0'
        when 'north'
          map[x - 2][y] = '0'
          map[x - 1][y] = '|'
        when 'south'
          map[x + 1][y] = '|'
          map[x + 2][y] = '0'
        when 'up'
          map[x - 1][y + 1] = '^'
        when 'down'
          map[x + 1][y - 1] = 'v'
        end
      end
      room.exits.each do |ex|
        next if covered.include? ex.target
        x_delta_res, y_delta_res = [0, 0]
        case ex.direction
        when 'west'
          x_delta_res, y_delta_res = add_exits(ex.target, map, x, y - 2, n - 1, covered + [room])
        when 'east'
          x_delta_res, y_delta_res = add_exits(ex.target, map, x, y + 2, n - 1, covered + [room])
        when 'north'
          x_delta_res, y_delta_res = add_exits(ex.target, map, x - 2, y, n - 1, covered + [room])
        when 'south'
          x_delta_res, y_delta_res = add_exits(ex.target, map, x + 2, y, n - 1, covered + [room])
        end
        x += x_delta_res
        y += y_delta_res
      end
      [x_delta, y_delta]
    end
  end
end
