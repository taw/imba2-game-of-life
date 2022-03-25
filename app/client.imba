def countNeighbours(cells, x, y)
	let count = 0
	for cell of cells
		if !cell.state
			continue
		let dx = Math.abs(cell.x - x)
		let dy = Math.abs(cell.y - y)
		if Math.max(dx, dy) == 1
			count += 1
	count

def runStep(cells)
	let nextCells = []
	for cell of cells
		let n = countNeighbours(cells, cell.x, cell.y)
		let nextState = (n == 3 || (cell.state && n == 2))
		nextCells.push({x: cell.x, y: cell.y, state: nextState})
	nextCells

tag cell
	prop data

	def onclick
		data.state = !data.state
		emit("pause")

	def render
		let visualStartX = 20 * data.x + 1
		let visualStartY = 20 * data.y + 1

		<self[left:{visualStartX}px top:{visualStartY}px] .alive=(data.state) .dead=(!data.state) @click.onclick>

	css
		position: absolute
		width: 18px
		height: 18px
		&.dead
			background-color: #864
		&.alive
			background-color: #3f3

tag app
	prop cells
	prop playing = true

	def setup
		let sizex = 30
		let sizey = 30
		cells = []
		for x in [0 ... sizex]
			for y in [0 ... sizey]
				cells.push({ x: x, y: y, state: Math.random() < 0.2 })

	def step
		cells = runStep(cells)

	def mount
		imba.setInterval(&,100) do
			if playing
				step()

	def play
		playing = true

	def pause
		playing = false

	def render
		<self>
			<header>
				"Game of Life"
			<div.board>
				for cell in cells
					<cell data=cell @pause.pause>
			<div.buttons>
				if playing
					<button @click.pause>
						"Pause"
				else
					<button @click.step>
						"Step"
					<button @click.play>
						"Play"

	css
		header
			font-size: 64px
			text-align: center
		.board
			position: relative
			height: 600px
			width: 600px
			background-color: #aaa
			margin: auto
		.buttons
			text-align: center
		button
			margin: 0.5em

imba.mount <app>
