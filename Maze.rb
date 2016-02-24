class Maze

	def initialize(n, m)
		@n = n
		@m = m
		@maze = Array.new(2 * m + 1) { Array.new(2 * n + 1, '0') }
		@predecessor = Array.new(2 * m + 1) { Array.new(2 * n + 1) }
		@direction = [[1, 0], [-1, 0], [0, 1], [0, -1]]
		@validMaze = false
	end

	def load(seq)
		raise TypeError, "Invalid input type" if not seq.is_a?(String)
		raise "Invalid input" if seq.length != (2 * @n + 1) * (2 * @m + 1)
		for i in 0..(2 * @m)
			for j in 0..(2 * @n)
				raise "Invalid input" if seq[i * (2 * @n) + j] != '0' and seq[i * (2 * @n) + j] != '1'
				@maze[i][j] = seq[i * (2 * @n + 1) + j]
			end
		end
		for i in 0..(@m - 1)
			for j in 0..(@n - 1)				
				raise "Invalid input" if @maze[i * 2 + 1][j * 2 + 1] != '0'
				count = 0
				count += 1 if @maze[i * 2 + 2][j * 2 + 1] == '1'
				count += 1 if @maze[i * 2 + 1][j * 2 + 2] == '1'
				count += 1 if @maze[i * 2][j * 2 + 1] == '1'
				count += 1 if @maze[i * 2 + 1][j * 2] == '1'
				raise "Invalid input" if count == 0 or count == 4
			end
		end
		@validMaze = true
	end

	def display
		raise "No valid maze" if not @validMaze
		for i in 0..(2 * @m)
			for j in 0..(2 * @n)
				print '#' if @maze[i][j] == '1'
				print ' ' if @maze[i][j] == '0'
			end
			print "\n"
		end
		print "\n"
	end

	def dfs(direction, x, y, endX, endY)
		return false if @maze[y][x] == '1' or @visited[y][x] == true
		@visited[y][x] = true
		@predecessor[y][x] = direction
		return true if (x == endX * 2 + 1) and (y == endY * 2 + 1)
		dfs(1, x + 1, y, endX, endY) or dfs(2, x, y + 1, endX, endY) or dfs(-1, x - 1, y, endX, endY) or dfs(-2, x, y - 1, endX, endY)
	end

	def solve(begX, begY, endX, endY)
		raise "No valid maze" if not @validMaze
		return false if @maze[begY * 2 + 1][begX * 2 + 1] == '1' or @maze[endY * 2 + 1][endX * 2 + 1] == '1'
		@visited = Array.new(2 * @m + 1) { Array.new(2 * @n + 1, false) }
		dfs(0, begX * 2 + 1, begY * 2 + 1, endX, endY)
	end

	def trace(begX, begY, endX, endY)
		raise "No valid maze" if not @validMaze
		@visited = Array.new(2 * @m + 1) { Array.new(2 * @n + 1, false) }
		return false if dfs(0, begX * 2 + 1, begY * 2 + 1, endX, endY) == false
		x = 2 * endX + 1
		y = 2 * endY + 1
		list = Array.new
		while x != 2 * begX + 1 or y != 2 * begY + 1 do
			list.unshift [(x - 1) / 2, (y - 1) / 2] if x % 2 == 1 and y % 2 == 1
			if @predecessor[y][x] == 1
				x -= 1
			elsif @predecessor[y][x] == 2
				y -= 1
			elsif @predecessor[y][x] == -1
				x += 1
			elsif @predecessor[y][x] == -2
				y += 1
			end
		end
		list.unshift [(x - 1) / 2, (y - 1) / 2]
		list.each do |cx, cy|
			printf "At position: [%d, %d]\n", cx, cy
		end
		print "\n"
		return true
	end

	def redesign
		for i in 0..(2 * @m)
			for j in 0..(2 * @n)
				@maze[i][j] = '1' if not (i % 2 == 1 and j % 2 == 1)
			end
		end
		is_in_maze = {}
		is_in_waitinglist = {}
		start_cell = [rand(@m), rand(@n)]
		is_in_maze[start_cell] = true
		waiting_list = []
		for i in 0..3
			temp_cell = [start_cell[0] + @direction[i][0], start_cell[1] + @direction[i][1]]
			next if temp_cell[0] < 0 or temp_cell[0] >= @m or temp_cell[1] < 0 or temp_cell[1] >= @n or is_in_maze.has_key?(temp_cell)
			waiting_list << temp_cell
			is_in_waitinglist[temp_cell] = true
		end
		while waiting_list.length > 0 do
			index = rand(waiting_list.length)
			new_cell = waiting_list[index]
			waiting_list.delete_at(index)
			while true do
				temp_direction = rand(4)
				temp_cell = [new_cell[0] + @direction[temp_direction][0], new_cell[1] + @direction[temp_direction][1]]
				break if is_in_maze.has_key?(temp_cell)
			end
			is_in_maze[new_cell] = true
			wall = [new_cell[0] * 2 + 1 + @direction[temp_direction][0], new_cell[1] * 2 + 1 + @direction[temp_direction][1]]
			@maze[wall[0]][wall[1]] = '0'
			for i in 0..3
				temp_cell = [new_cell[0] + @direction[i][0], new_cell[1] + @direction[i][1]]
				next if temp_cell[0] < 0 or temp_cell[0] >= @m or temp_cell[1] < 0 or temp_cell[1] >= @n or is_in_maze.has_key?(temp_cell) or is_in_waitinglist.has_key?(temp_cell)
				waiting_list << temp_cell
				is_in_waitinglist[temp_cell] = true
			end
		end
		@validMaze = true
	end

	private :dfs

end

maze = Maze.new(4, 4)
maze.load("111111111100010001111010101100010101101110101100000101111011101100000101111111111")
maze.display
print maze.solve(0, 0, 3, 3), "\n\n"
maze.trace(0, 0, 3, 3)
maze.redesign
maze.display