getStackTrace = () ->
	callstack = []
	isCallstackPopulated
	try
		throw null
	catch e
		if e.stack #Firefox
			lines = e.stack.split '\n'
			for line in lines
				if line.match /^\s*[A-Za-z0-9\-_\$]+\(/
					callstack.push(lines[i])

			# Remove call to printStackTrace()
			callstack.shift()
			isCallstackPopulated = true
		else if window.opera && e.message # Opera
			lines = e.message.split '\n'
			i = 0
			for line in lines
				if line.match /^\s*[A-Za-z0-9\-_\$]+\(/
					# Append next line also since it has the file info
					if lines[i+1]
						line += ' at ' + lines[i+1];
						i++
					callstack.push(line);
				i++
			# Remove call to printStackTrace()
			callstack.shift()
			isCallstackPopulated = true

	if !isCallstackPopulated # IE and Safari
		currentFunction = arguments.callee.caller
		while currentFunction
			fn = currentFunction.toString()
			fname = fn.substring(fn.indexOf('function') + 8, fn.indexOf('')) || 'anonymous'
			callstack.push(fname)
			currentFunction = currentFunction.caller

	return callstack