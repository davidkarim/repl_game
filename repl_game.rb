require "io/console"
require "./enhance_io.rb"

# Modify class String with method to reverse colors
class String
  # Escape sequence reference: http://misc.flogisoft.com/bash/tip_colors_and_formatting
  def reverse_color
    "\e[7m#{self}\e[27m"
  end
end

# Show list of items; can display as a column or a list with commas, default is column
def show_items(items, type = "column", indent = false)
  i = 0
  if type == "list"
    puts items.join(", ")
  else
    while i <= items.count - 1
      if !indent
        print items[i]
      else
        print "- " + items[i]
      end
      print "\n" if i < items.count - 1
      i += 1
    end
  end
  puts
end

# Define the castle data structure
castle = {
  "great hall" => {
    room_description: "This is the main entry way of the castle. The room has high ceilings, a chandelier, and is typically a great place to just hang out.",
    visited: false,
    id: 0
  },
  "bed chamber" => {
    room_description: "This is the fancy bedroom for the king of the castle. The king is not here, but when he is, interesting things happen here.",
    visited: false,
    id: 1
  },
  "dining hall" => {
    room_description: "There is a large table in the middle with seating for 60 people (this is a castle). Normally the king eats here and is accompanied by his queen who sits at the opposing end. They generally just eat quietly.",
    visited: false,
    id: 2
  },
  "guardhouse" => {
    room_description: "The guardhouse isn't really used, that is why you got in so easily. ",
    visited: false,
    id: 3
  },
  "chapel" => {
    room_description: "This is where the king comes to have his kingly sins forgiven. He uses this room extensively.",
    visited: false,
    id: 4
  },
  "cellar" => {
    room_description: "This is where the king of the castle stores his many delicious wines.",
    visited: false,
    id: 5
  }
}

# Define the challenges
challenges = [
  {question:"This room is completely dark; what can we do to be able to see again?",
    options: ["flip the light switch","say a magic chant","light a candle","dance the macarena"],
    answer: "light a candle",
    success_follow_up: "Good. Candles work best in a castle.",
    fail_follow_up: "Sorry but there is really only one way to turn on lights in medieval times."
  },
  {question:"A talking donkey has a riddle for you. He says \"What loses its head in the morning and gets it back at night?\"",
    options: ["clock", "pillow", "tree", "house"],
    answer: "pillow",
    success_follow_up: "\"Good, you are a worthy opponent\", says the donkey.",
    fail_follow_up: "Donkey says, \"Sorry, you apparently are not good with riddles.\""
  },
  {question:"There is an elf in here with a riddle. He says \"What two things can you never eat for breakfast?\"",
    options: ["eggs and bacon", "lunch and dinner", "milk and yogurt", "rice and beans", "tortillas and cheese", "steak and eggs"],
    answer: "lunch and dinner",
    success_follow_up: "\"Excellent\", says the elf; you were not tricked by this one.",
    fail_follow_up: "Sorry, you apparently are not good with breakfast riddles."
  },
  {question:"There is a gnome in here with a riddle. He says \"What item is brown and sticky?\"",
    options: ["stick", "tree", "bush", "green ball"],
    answer: "stick",
    success_follow_up: "Excellent; \"You have superior analytical skills.\", says the gnome.",
    fail_follow_up: "Your IQ must not be very high."
  },
  {question:"Oh no!! You have encountered an ogre. He is green and has big red eyeballs. How do you plan on defeating him?",
    options: ["don't defeat, say hello and keep walking", "find a stick and poke him with it", "cast a magic spell on him"],
    answer: "don't defeat, say hello and keep walking",
    success_follow_up: "Excellent; you are not a figther and certainly no magician.",
    fail_follow_up: "Can't you tell this ogre is sick? You should have just kept walking. Now you have Ogre Disease."
  },
  {question:"Oh no!! You have encountered a witch and she is carrying a broom. This is an evil witch and you should definitely try to disarm her.",
    options: ["say hello and keep walking", "take away her broom", "cast a magic spell on her"],
    answer: "take away her broom",
    success_follow_up: "Excellent; you are no magician, but you have great broom-stealing abilities. This witch is now powerless.",
    fail_follow_up: "You should really pay attention to instructions; you should have taken away her broom. She will now cast a spell on you and turn you into a tiny mouse."
  },
  {question:"There is a fire-breathing dragon in this room! What would you like to do?",
    options: ["take out your marshmallows and start roasting them", "take out your sword and start fighting the dragon", "pucker up your lips and blow, in the hope you can breathe fire also"],
    answer: "take out your sword and start fighting the dragon",
    success_follow_up: "You are an excellent swords-person and have defeated this dragon",
    fail_follow_up: "You really need to go back home and rethink your dragon fighting strategies."
  }
]

rooms = ["great hall", "bed chamber", "dining hall", "guardhouse", "chapel", "cellar"]

score = 0
hero = "" # holds prince or princess
name = "" # holds the name of our hero
system "clear"
puts "*** Welcome to WynCode Castle*** \n\n"
puts "Press enter key to continue.\n\n"
gets.chomp
puts
until hero == "prince" || hero == "princess"
  puts "Are you a Prince or a Princess?"
  hero = EnhanceIO.input_auto(["prince","princess"])
end
puts
until !(name == "")
  puts "And your name?"
  name = gets.chomp
end

puts hero == "prince" ? "Hello Sir #{name}." : "Hello Madame #{name}"
puts

if hero == "prince"
  prisoner = "princess"
else
  prisoner = "prince"
end

puts "We are in medieval times and you are about to enter WynCode Castle."
puts  "Inside the castle, each room has a challenge. Complete five succesfully "
puts "and you will be able to free the #{prisoner} from the top of the tower."
puts "Fail TWO challenges, and the #{prisoner} will rot for eternity!"
puts

# Shuffle challenges, then every room will present the same challenge.
challenges.shuffle!
challenges_played = 0
wrong_answers = 0

# Repeat questions until you reach the score or visit all the rooms.
while score < 5 && wrong_answers < 2
  current_room = ""
  response = ""
  until rooms.include? current_room
    puts "YOUR SCORE IS: #{score} / 5. Please pick which room you would like to visit: "
    show_items(rooms, "list")
    current_room = EnhanceIO.input_auto(rooms)
  end
  if castle[current_room][:visited] == true
    puts
    puts "You have already visited this room and encountered its challenge."
    puts "Pick a different room as this one is now empty."
    puts
  else
    castle[current_room][:visited] = true
    challenges_played += 1
    puts
    puts "-"*5 + " #{current_room.capitalize} " + "-"*5
    puts "You are now visiting the #{current_room}"
    puts castle[current_room][:room_description]
    puts
    puts "Here comes the challenge, hit a key to continue"
    gets
    current_id = castle[current_room][:id]

    while response == ""
      puts challenges[current_id][:question]
      show_items(challenges[current_id][:options], "column", true)
      response = EnhanceIO.input_auto(challenges[current_id][:options])
    end

    if response == challenges[current_id][:answer]
      puts challenges[current_id][:success_follow_up]
      score += 1
    else
      puts challenges[current_id][:fail_follow_up]
      wrong_answers += 1
    end
  end
end
if score >=5
  puts
  puts "Congratulations! You have rescued the #{prisoner} and you will both live happily ever after."
  puts "THE END"
else
  puts
  puts "YOUR SCORE WAS: #{score} / 5. "
  puts "Sorry! You have failed to complete the challenges. The #{prisoner} will now rot away in the castle tower forever."
  puts "THE END"
end
