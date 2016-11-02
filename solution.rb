t = Time.now


#Creating the blueprint of a word node
WordNode = Struct.new(:word, :parent, :children, :children_length)


#Get words used- This is O(n) time complexity
SOCIAL_NETWORK = []
File.open("input.txt", "r").each_line do |line|
	#Get rid of the newline on each word
	line = line[0..-2]
	break if line == "END OF INPUT"
	SOCIAL_NETWORK.push(WordNode.new(line, nil, [], 0))
end

#Each word in the social network, compare it against the sample input.
#Running throug each word, followed by running through each word in the sample
#input, and THEN running through each letter of the social network word equates to
#a O(n^2) + O(n) time complexity, which boils down to O(n^2)

#Function that compares the words

#Keep track of total children to add to total at the end

$total = 0
def compare_words(node, sample_word)
	sorted_sample_word = sample_word.sort
	#Only one different in the word(removing/deleting)
	count = 1
	node.word.split("").sort.each_with_index do |letter, i|
		if letter != sorted_sample_word[i]
			count -= 1
		end
	end
	if count == 0
		node.children_length = node.children.length
		$total += node.children_length
		o = WordNode.new(sample_word.join(""), node, [], 0)
		node.children.push(o)
	end
end

#Function that determines if the word should be compared based on problem conditions
def delegate_word(node)
	File.open("input.txt", "r").each_line do |l|
		line = l.downcase[0..-2].split("")
		#For adding
		if(node.word.length + 1) == line.length
			compare_words(node, line)
		end
		#For removing
		if(node.word.length - 1) == line.length
			compare_words(node, line)
		end
		#For substiting
		#Checking to make sure they are the same length
		if node.word.length == line.length
			compare_words(node, line)
		end
	end
end

#Gets all the children of each child recursively
def get_children_recursion(node)
	if node.class == SOCIAL_NETWORK[0].class
		node.children.each do |child|
			get_children_recursion(delegate_word(child))
		end
	end
end

#New social network
NEW_SOCIAL_NETWORK = {}

SOCIAL_NETWORK.each do |word|
	delegate_word(word)
	get_children_recursion(word)
	NEW_SOCIAL_NETWORK[word.word] = $total
	#Reset total for next word
	$total = 0
end

p NEW_SOCIAL_NETWORK
p Time.now - t

# ANSWER OUTPUT BELOW
# {"horrid"=>172, "basement"=>199, "abbey"=>9706, "recursiveness"=>0, "elastic"=>9514, "macrographies"=>0}
# 75.802034656

