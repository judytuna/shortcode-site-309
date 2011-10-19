require 'digest'

module EntriesHelper
	# takes the list of entries, and returns a structure with two lists,
	# :winners and :runnersup
	def winners(l)
		s = ''
		# break ties with the length of the shrotcode,
		# break ties after that with the code itself but hashed for an extra element
		# of pseudo-randomness.
		nl = l.sort_by {|e| [-e.score, e.shortcode.size, e.shortcode_full_hash]}
		# put the runners up in alphabetical order.
		return {:winners => nl[0..2], :runnersup => nl[3..nl.size].sort_by {|e| e.title.downcase}}
	end
	
	# searches for substrings of s with no space or tab of length at least l
	# and artificially inserts newlines to break them up.
	def wrap(s)
	  r = ""
	  i = 0
	  n = s.length
	  sofar = 0
	  while i < n
		r << String(s[i])
		
		if /\s/ =~ s[i]
		  sofar = 0
		else
		  sofar += 1
		end
		
		if sofar >= 100
		  r << "\n"
		  sofar = 0
		end
		i+=1
	  end
	  return r
	end
	
end

