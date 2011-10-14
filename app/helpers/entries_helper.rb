module EntriesHelper
	def winners(l)
		s = ''
		nl = l.sort_by {|e| -e.score}
		return {:winners => nl[0..2], :runnersup => nl[3..nl.size]}
	end
end
